---
name: jinja-templates
description: >
  Jinja2 template conventions, TailwindCSS component classes, Material You color
  system, and HTMX markup patterns for apps built on the flask-htmx-template.
  Use when writing or editing .jinja template files.
---

## File conventions

- All templates use the `.jinja` extension
- Formatter: `djlint` with `profile = "jinja"` and
  `prettier-plugin-jinja-template`
- Template root: `templates/`
  - `shared/` — layout, nav, dialogs, reusable partials
  - `<resource>/` — per-resource pages and fragments

## Base layout

Content pages do **not** extend `base.jinja` themselves. The `base.page()`
controller helper wraps content in the base layout for full page loads:

```jinja
{# templates/items/page-all.jinja — standalone partial #}
<div hx-get="..." hx-trigger="item from:body" hx-target="#main">
  <h1>Items</h1>
  ...
</div>
```

`base.jinja` provides a single `{% block content required %}` block.

## Custom element: icons

Use `<icon>name</icon>` for Material Symbols icons (loaded as font glyph):

```html
<icon>add</icon>
<icon>delete</icon>
<icon>edit</icon>
```

Icons referenced in templates are auto-detected and bundled at startup. You can
also declare icons in script/variables with `set icon = "name"`.

## Jinja filters

| Filter        | Input   | Output example              |
| ------------- | ------- | --------------------------- |
| `seconds`     | int     | `"1h 23m"`                  |
| `days`        | int     | `"2 years"`                 |
| `days_abv`    | int     | `"2 yrs"`                   |
| `comma`       | Decimal | `"1,234.56"`                |
| `qty`         | Decimal | `"1,234.567890"`            |
| `tojson`      | dict    | JSON string for JS          |
| `input_value` | Decimal | `"1.5"` (no trailing zeros) |
| `percent`     | Decimal | `" 12.50%"`                 |

```jinja
{{ item.value | comma }}
{{ item.value | input_value }}
{{ ctx | tojson }}
```

## Typography rules

**Never use `text-sm` or `text-xs`** in templates. Font sizes are set globally
by the design system. Using utility size classes overrides the theme and creates
inconsistent, too-small text. Use semantic HTML (`<small>`, `<label>`, headings)
or component classes instead.

## TailwindCSS component classes

These custom component classes are defined in `static/src/css/`:

### Buttons

```html
<button class="btn-filled">Primary action</button>
<button class="btn-tonal">Secondary action</button>
<button class="btn-outlined">Outlined</button>
<button class="btn-text">Text only</button>
<button class="btn-text-error">Destructive action</button>
```

### Text inputs (Material You outlined style)

```html
<label class="input-outlined input-bg-surface-container-high">
  <input name="field" value="{{ value }}" placeholder="" />
  <div><div>Label text</div></div>
  <div>
    <error></error>
    <span>Helper text</span>
  </div>
</label>
```

The `<error>` element is the HTMX validation target.

### Status / feedback

```html
<div class="status-error">Error message here</div>
<div id="dialog-error" class="status-error"></div>
```

## Material You color classes

The theme uses `materialyoucolor` to generate a full color palette. All colors
are available as Tailwind utilities:

```html
<!-- Background -->
<div class="bg-surface-container-high">
  <div class="bg-primary-container">
    <div class="bg-tertiary-container">
      <!-- Text -->
      <span class="text-primary">
        <span class="text-on-surface">
          <span class="text-on-tertiary-container">
            <span class="text-tertiary">
              <span class="text-error">
                <!-- Outline -->
                <div class="border border-outline">
                  <div
                    class="border border-outline-variant"
                  ></div></div></span></span></span></span
      ></span>
    </div>
  </div>
</div>
```

Full palette: `primary`, `on-primary`, `primary-container`,
`on-primary-container`, `inverse-primary`, `secondary`, `on-secondary`,
`secondary-container`, `on-secondary-container`, `tertiary`, `on-tertiary`,
`tertiary-container`, `on-tertiary-container`, `error`, `on-error`,
`error-container`, `on-error-container`, `surface`, `on-surface`, `surface-dim`,
`surface-bright`, `surface-variant`, `on-surface-variant`, `inverse-surface`,
`inverse-on-surface`, `surface-container-lowest`, `surface-container-low`,
`surface-container`, `surface-container-high`, `surface-container-highest`,
`outline`, `outline-variant`, `shadow`, `scrim`.

## Dialog templates

Structure for dialog content templates:

```jinja
{# Shared headline with save button #}
{% if item.uri %}
  {% with headline="Edit item", save_url=url_for("items.item", uri=item.uri) %}
    {% include "shared/dialog-headline.jinja" %}
  {% endwith %}
{% else %}
  {% with headline="New item", save_url=url_for("items.new"), save_method="post" %}
    {% include "shared/dialog-headline.jinja" %}
  {% endwith %}
{% endif %}

<form class="grid w-88 gap-2" onsubmit="return false">
  ...form fields...
</form>

<div id="dialog-error" class="status-error"></div>
<script>dialog.onLoad();</script>
```

## Page templates

```jinja
{# Trigger reload when "item" event fires on body #}
<div
  hx-get="{{ url_for('items.page_all') }}"
  hx-trigger="item from:body"
  hx-target="#main"
>
  <h1>Items</h1>
  <button
    class="btn-tonal"
    hx-get="{{ url_for('items.new') }}"
    hx-target="#dialog"
    hx-swap="innerHTML show:#dialog:top"
    hx-push-url="#dialog"
  ><icon>add</icon>New</button>
</div>
```

## Collapsible/details sections

```html
<details class="mx-auto mb-2 max-w-2xl rounded-md bg-surface-container-high">
  <summary
    class="flex items-center gap-2 rounded-md bg-tertiary-container p-2 text-on-tertiary-container"
  >
    <icon>help</icon>
    <span class="mr-auto">Section title</span>
    <icon class="details-icon-open">keyboard_arrow_up</icon>
    <icon class="details-icon-closed">keyboard_arrow_down</icon>
  </summary>
  <div class="mx-auto prose px-2">
    <p>Content here</p>
  </div>
</details>
```

## Looping with dividers

```jinja
{% for item in ctx["items"] %}
  {% include "items/item-row.jinja" %}
  {% if not loop.last %}<hr class="mx-4 my-1" />{% endif %}
{% endfor %}
```

## djlint suppressions

Use `{# djlint: off #}` and `{# djlint: on #}` to suppress specific warnings:

```jinja
{# djlint: off #}
{# ignore missing <head> #}
<html lang="en-US">
{# djlint: on #}
```

## JavaScript actions in templates

To do something after a template loads on a client, use this pattern.

```jinja
<script>onLoad(() => { console.log("I did it"); })</script>
```

onLoad is defined in `head.jinja`.

```

```

## Moving data to JavaScript

Namely for generating charts using `Chart.js`, the chart is configured in a
JavaScript function. `JSON.parse` must have single quotes around jinja expander
since JSON has double quotes always. Hence the prettier-ignore to NOT change
them to double quotes.

```jinja
<script>
  // prettier-ignore
  onLoad(() => {
    const data = JSON.parse('{{ ctx | tojson }}');
    console.log("do stuff with", data);
  });
</script>
```

```

```
