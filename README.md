# Catfish Pip-Boy Watchface for AsteroidOS

QML-only Pip-Boy-inspired watchface MVP for AsteroidOS on TicWatch Pro 2020
(`catfish-ext`). The first goal is a stable, centered, readable round
watchface; device-specific data providers are documented as stubs until tested
on the target image.

## Current MVP

- Round 480x480-first layout using `safeSize = min(width, height)`.
- Large 24h time, date, day-of-year, and week-of-year.
- Pip-Boy-like CRT HUD styling with scanlines and simple geometric character.
- `VAULT-TEC` header and lower `PWR` / `STAT` / `HP` status strip.
- `ambientMode` property for reduced seconds/animation/scanline behavior.
- Qt Creator project file: `pip-boy-asteroidos.qmlproject`.

## Project Layout

- `qml/` - source QML and shared components.
- `catfish-pipboy/usr/share/asteroid-launcher/` - installable AsteroidOS layout.
- `src/` - MVP source notes; no native C++ is needed yet.
- `tests/` - QML/JS formatter tests.
- `docs/` - MVP scope, design brief, architecture, platform notes.
- `scripts/` - preview, sync, deploy, and packaging helpers.

## Design

The concept sheet is in `docs/pipboy-design-concepts.png`.

MVP direction: hybrid of `A CLASSIC` and `C AMBIENT`: large readable time,
compact status panels, no proprietary Fallout assets, and geometry that stays
inside the round display.

## Preview in Qt Creator

1. Open `pip-boy-asteroidos.qmlproject`.
2. Set `qml/Main.qml` as the run target if Qt Creator does not pick it
   automatically.
3. Run with a 480x480 preview window.

Command-line preview on Ubuntu:

```bash
./scripts/preview-qmlscene.sh
```

Headless screenshot preview:

```bash
./scripts/capture-preview.sh
```

The screenshot is written to `docs/qmlscene-preview.png`.

If `qmlscene` is missing, install Qt Creator / Qt declarative tools on the VM.
The AsteroidOS wiki notes that `qmlscene` is provided by the `qt-creator`
package for watchface development.

## Sync to AsteroidOS Layout

```bash
./scripts/sync-watchface-layout.sh
```

This copies `qml/Main.qml` and support files into:

```text
catfish-pipboy/usr/share/asteroid-launcher/watchfaces/
```

## Deploy

Do not deploy before visual approval.

After approval and with the watch reachable over SSH:

```bash
./scripts/deploy-ssh.sh <watch-ip>
```

The script installs the QML watchface files under
`/usr/share/asteroid-launcher/` and restarts the launcher session.

## Tests

```bash
qmltestrunner -input tests
```

If `qmltestrunner` is unavailable, install Qt test/declarative tooling on the
Ubuntu VM.

## Stubs and Research Items

- `batteryPercentStub`, `heartRateStub`, and `stepsStub` are static placeholders
  in `qml/Main.qml`.
- Battery/charging integration is expected to use AsteroidOS/Nemo MCE, but the
  exact QML module/object must be confirmed on the target image.
- Steps, heart-rate, weather, notifications, Bluetooth, and alarms depend on
  the installed AsteroidOS build and sync client path.
- Ambient mode is exposed as a property and still needs launcher/display-state
  wiring after module availability is verified.

See also:

- `docs/mvp.md`
- `docs/platform-gap-analysis.md`
- `docs/asset-license-notes.md`
