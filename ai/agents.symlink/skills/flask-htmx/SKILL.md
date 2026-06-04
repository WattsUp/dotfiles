---
name: flask-htmx
description: >
  Flask app structure, routing conventions, controller patterns, and HTMX
  integration for apps built on the flask-htmx-template. Use when writing
  controllers, routes, or HTMX-driven interactions.
---

## Project structure

- `web.py` — creates the Flask app via `create_app()` and exposes `ext` and `db`
- `controllers/` — one module per resource (e.g. `items.py`, `auth.py`)
- `models/` — SQLAlchemy models
- `templates/` — Jinja templates (`.jinja` extension)
- `static/src/` — CSS and JS source; compiled to `static/dist/` by flask-assets

## Route conventions

Each controller module defines a `ROUTES` dict at the bottom:

```python
ROUTES: base.Routes = {
    "/items":               (page_all,   ["GET"]),
    "/items/<path:uri>":    (page,       ["GET"]),
    "/h/items/new":         (new,        ["GET", "POST"]),
    "/h/items/i/<path:uri>":(item,       ["GET", "PUT", "DELETE"]),
    "/h/items/validation":  (validation, ["GET"]),
    "/j/items":             (json_all,   ["GET"]),
    "/j/items/new":         (json_new,   ["POST"]),
    "/j/items/i/<path:uri>":(json,       ["GET", "PUT"]),
}
```

URL prefix conventions:

- `/` — full HTML pages
- `/h/` — HTMX partials (return HTML fragments)
- `/j/` — JSON API endpoints (return dicts; error format: `{"errors": [...]}`)

## Controller patterns

### Full page response

```python
def page_all() -> flask.Response:
    with web.db.begin_session():
        return base.page("items/page-all.jinja", "Items", ctx=ctx_items())
```

`base.page()` automatically detects `HX-Request` and returns either a full page
(with base layout) or just the content partial.

### HTMX dialog — GET + POST

```python
def new() -> str | flask.Response:
    with web.db.begin_session() as s:
        if flask.request.method == "GET":
            return flask.render_template("items/edit.jinja", item=ctx)

        form = flask.request.form
        try:
            with s.begin_nested():
                Item.create(name=form["name"].strip(), ...)
        except (exc.IntegrityError, exc.InvalidORMValueError) as e:
            return base.error(e)  # returns inline HTML error string

        return base.dialog_swap(event="item", snackbar="All changes saved")
```

`base.dialog_swap(event=..., snackbar=...)` closes the dialog and fires an
`HX-Trigger` header with the event name; listeners on `:body` can reload data.

### JSON endpoint

```python
def json_new() -> ItemContext | base.JSONResponse:
    with web.db.begin_session() as s:
        j: ItemContext = flask.request.json
        j, e = utils.validate_json(j, ItemContext)
        if e:
            return {"errors": e}, base.HTTP_CODE_BAD_REQUEST
        ...
        return ctx_item(item)
```

### Finding objects by URI

```python
item = base.find(Item, uri)   # raises BadRequest or NotFound automatically
```

### Context helpers

Build `TypedDict` context objects and pass them to templates:

```python
class ItemContext(TypedDict):
    uri: NotRequired[str]
    name: str
    value: Decimal

def ctx_item(item: Item) -> ItemContext:
    return {"uri": item.uri, "name": item.name, "value": item.value}
```

### Inline validation endpoint

```python
def validation() -> str:
    args = flask.request.args
    if "value" in args:
        return base.validate_real(args["value"], is_required=True)
    with web.db.begin_session():
        uri = args.get("uri")
        if "name" in args:
            return base.validate_string(
                args["name"],
                is_required=True,
                duplicate=base.DuplicateCheck(
                    cls=Item,
                    column=Item.name,
                    extra_wheres=None if uri is None else [Item.id_ != Item.uri_to_id(uri)],
                ),
            )
    raise NotImplementedError
```

Validation functions return `""` on success or a short error message string.

## HTMX patterns

### Loading a dialog

```html
<button
  hx-get="{{ url_for('items.new') }}"
  hx-target="#dialog"
  hx-swap="innerHTML show:#dialog:top"
  hx-push-url="#dialog"
>
  New
</button>
```

### Reloading content after an event

```html
<div
  hx-get="{{ url_for('items.page_all') }}"
  hx-trigger="item from:body"
  hx-target="#main"
>
  ...
</div>
```

### Inline field validation

```html
<input
  name="name"
  hx-get="{{ url_for('items.validation', uri=item.uri) }}"
  hx-trigger="input delay:200ms"
  hx-target="next error"
  hx-include="this"
/>
```

Validation response is plain text placed into the `<error>` element.

### Delete with confirm

```html
<button
  class="btn-text-error"
  hx-delete="{{ url_for('items.item', uri=item.uri) }}"
  hx-trigger="delete"
  hx-disabled-elt="this"
  onclick="items.confirmDelete(event)"
>
  Delete
</button>
```

### Redirect handling

After a DELETE that redirects, `base.change_redirect_to_htmx` converts the 302
to `200 + HX-Redirect` header automatically (registered as `after_request`).

### Dialog lifecycle

Always include `<script>dialog.onLoad();</script>` at the end of dialog
templates.

## Error handling

- HTTP errors from `/j/` routes return `{"errors": [...]}` JSON
- HTTP errors from HTML routes return the default Werkzeug response
- `base.error(e)` formats SQLAlchemy `IntegrityError` into human-readable HTML

## Asset pipeline

CSS and JS are built by `flask_assets` using custom filters:

- CSS: `pytailwindcss` (TailwindCSS v4, `--minify` in production)
- JS: `jsmin` in production; `src/top.js` is always first in bundle

In debug mode, assets are rebuilt on each request; in production they are served
from `static/dist/`.
