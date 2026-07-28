# MVP Scope

## Target
- Device: TicWatch Pro 2020 / AsteroidOS `catfish-ext`.
- Form factor: round display, designed and tested around a 480x480 viewport.
- Delivery type: AsteroidOS launcher watchface, not a standalone app.

## Confirmed Implementation Basis
- AsteroidOS watchfaces are QML files installed below
  `/usr/share/asteroid-launcher/watchfaces/`.
- Preview/development can use `qmlscene` or the AsteroidOS
  `unofficial-watchfaces` helper.
- Assets should be SVG where practical and installed under
  `/usr/share/asteroid-launcher/watchface-img/`.

## MVP Features
- Centered round Pip-Boy-inspired CRT HUD.
- Large 24h digital time with seconds in normal mode.
- Date, day-of-year, week-of-year.
- Header: `VAULT-TEC`.
- Status strip: `PWR` battery percent, `STAT` daily steps, `HP` heart rate.
- Lightweight geometric character in active mode.
- Scanline overlay in active mode.
- Ambient-safe visual mode property with seconds/animation removed.
- QML-only layout using `safeSize = min(width, height)` to avoid drift outside
  the round screen.

## Stubs / Hypotheses
- `batteryPercentStub`, `heartRateStub`, and `stepsStub` are static MVP
  placeholders.
- Real battery integration is expected to use AsteroidOS/Nemo MCE data, but the
  exact import/object should be confirmed on the target image before enabling it.
- Real steps/heart/weather integration depends on the installed AsteroidOS build
  and sync client data path.
- Ambient mode is exposed as `ambientMode` property and not yet wired to the
  launcher/display state.

## Blockers Before Final Device Deployment
- Confirm available QML modules on the VM/watch image.
- Run `qmlscene` or `asteroid-qmltester` and inspect the 480x480 rendering.
- Get explicit user approval for the selected visual variant.
- Deploy to the physical watch only after approval.
