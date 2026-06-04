---
name: unit-quantities
description: >
  Naming conventions for variables, fields, and parameters that represent
  real-world physical quantities with units. Use when writing or reviewing any
  code that stores a measured or computed value that has physical units
  (voltage, time, current, frequency, temperature, distance, etc.).
---

## Rule: encode the unit in the name

Any identifier that holds a real-world quantity **must** include the unit as a
suffix separated by an underscore. Unitless identifiers are reserved for pure
counts, ratios, or dimensionless values.

```python
# Bad — reader must hunt for the unit
battery = read_adc()
timeout = 5
offset = get_pll_offset()

# Good — unit is self-documenting
battery_v = read_adc()
timeout_s = 5
offset_ns = get_pll_offset()
```

## Preferred units (use the base SI unit by default)

| Quantity     | Preferred suffix | Notes                                     |
| ------------ | ---------------- | ----------------------------------------- |
| Voltage      | `_v`             |                                           |
| Current      | `_a`             |                                           |
| Time / delay | `_s`             |                                           |
| Frequency    | `_hz`            |                                           |
| Temperature  | `_c`             | Celsius; use `_k` only for thermodynamics |
| Distance     | `_m`             |                                           |
| Power        | `_w`             |                                           |
| Resistance   | `_ohm`           |                                           |
| Angle        | `_rad`           | Use `_deg` only for display values        |

## When to use a sub-unit

Use a sub-unit suffix when the base unit forces awkward floats or precision loss
in integer storage:

```python
# Awkward — sub-nanosecond floats, precision issues
offset_s: float = 1.5e-9

# Better — integer nanoseconds
offset_ns: int = 1500

# Awkward — milliamp floats everywhere
current_a: float = 0.012

# Fine either way — pick what matches the hardware register
current_ma: int = 12
```

**Do not use ambiguous prefixes.** `mv` is ambiguous (millivolts or megavolts).
Spell out the prefix or use the base unit:

```python
# Bad — mv is ambiguous
vcc_mv = 3300

# Good
vcc_mv = 3300   # acceptable only if the repo standardises on mV throughout
vcc_v = 3.3     # unambiguous

# Bad
freq_mhz = 10   # MHz vs mHz?

# Good
freq_hz = 10_000_000   # unambiguous integer
```

Acceptable sub-unit suffixes (all unambiguous at these scales):

| Suffix | Meaning           |
| ------ | ----------------- |
| `_ms`  | milliseconds      |
| `_us`  | microseconds      |
| `_ns`  | nanoseconds       |
| `_ps`  | picoseconds       |
| `_mv`  | millivolts        |
| `_ma`  | milliamps         |
| `_uhz` | microhertz        |
| `_khz` | kilohertz         |
| `_mhz` | megahertz         |
| `_ghz` | gigahertz         |
| `_mm`  | millimetres       |
| `_km`  | kilometres        |
| `_ppb` | parts per billion |
| `_ppm` | parts per million |

## Compound names

Put the unit suffix at the very end, after the descriptive noun:

```python
# Good
holdover_quality_ns = 500
pll_lock_timeout_s = 30
antenna_current_ma = 12
osc_temp_c = 45.2
phase_error_ns = 3

# Bad — unit buried in the middle
ns_holdover_quality = 500
timeout_s_pll_lock = 30
```

## Struct / class fields follow the same rule

```python
class OscStatus:
    temp_c: float
    aging_ppb: float
    pid_raw: int        # dimensionless register value — no unit suffix
```

## Return types and function parameters

Apply the convention to parameters and return-type documentation too:

```python
def estimate_holdover_error(elapsed_s: float) -> float:
    """Return estimated time error in nanoseconds."""
    ...  # caller knows return is nanoseconds only from the name

# Better — encode unit in the return variable name at call site
error_ns = estimate_holdover_error(elapsed_s=holdover_duration_s)
```
