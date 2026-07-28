# Design Brief

The generated concept sheet is stored at `docs/pipboy-design-concepts.png`.

## Variant A: Classic
- Large left-side time, top terminal tabs, simple right-side mascot/status.
- Best default MVP direction because it is readable on a small circular display.

## Variant B: Terminal
- Dense telemetry grid with chart and multiple data bands.
- Useful later, but risky for the first watch build because many fields are
  currently unconfirmed on AsteroidOS.

## Variant C: Ambient
- Minimal time-first layout with battery ring and sparse labels.
- Good target for AOD/low-power mode after the normal face is stable.

## Selected MVP Direction
Implement `A CLASSIC`: a readable classic Pip-Boy-like composition in normal
mode, with an `ambientMode` property that removes seconds, scanlines, and
animation.

User-requested A Classic adjustments:
- Replace the repeated top `PWR STAT RAD` labels with `VAULT-TEC`.
- Remove the character entirely and return seconds to the main clock line.
- Lower status strip: `PWR` battery percent, `STAT` steps, `HP` heart rate.

## Rendered MVP Preview
The current QML render is stored at `docs/qmlscene-preview.png`.

The thin square guide visible in the desktop preview is outside the practical
round safe area and is useful while checking centering in `qmlscene`.
