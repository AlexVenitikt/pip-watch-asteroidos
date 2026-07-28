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
- `PWR` uses the confirmed AsteroidOS `Nemo.Mce` battery module on the watch.
- `HP` is wired through an optional `QtSensors` `HrmSensor` loader so missing
  sensor support does not break the watchface.
- Scanline overlay in active mode.
- Ambient-safe visual mode property with seconds/animation removed.
- QML-only layout using `safeSize = min(width, height)` to avoid drift outside
  the round screen.

## Data Status
- Battery integration is enabled through `Nemo.Mce` (`MceBatteryLevel` and
  `MceBatteryState`), confirmed on the target catfish watch image.
- Live heart-rate integration is attempted through `QtSensors` (`HrmSensor`),
  following the official `asteroid-hrm` app, but it falls back to `--` when the
  target image does not expose that QML type.
- Real steps are not faked. `STAT` displays `--` until a confirmed data source
  such as `asteroid-sensorlogd` / `asteroid-health` is installed and mapped.
- Local Qt Creator/qmlscene preview uses dev-only stubs for `Nemo.Mce` and
  `HrmSensor`; those files are not deployed to the watch.
- Real weather integration depends on the installed AsteroidOS build and sync
  client data path.
- Ambient mode is exposed as `ambientMode` property and not yet wired to the
  launcher/display state.

## Blockers Before Full Telemetry
- Confirm or install `asteroid-sensorlogd` / `asteroid-health` for step and
  heart-rate history.
- Confirm why this catfish image logs `HrmSensor is not a type` in
  `asteroid-launcher` despite `asteroid-hrm` being installed.
- Run `qmlscene` or `asteroid-qmltester` and inspect the 480x480 rendering.
