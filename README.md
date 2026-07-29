# Catfish Pip-Boy Watchface for AsteroidOS

QML-only Pip-Boy-inspired watchface MVP for AsteroidOS on TicWatch Pro 2020
(`catfish-ext`). The first goal is a stable, centered, readable round
watchface; device-specific data providers are wired only after they are
confirmed on the target image.

## Current MVP

- Round 480x480-first layout using `safeSize = min(width, height)`.
- Large 24h time, date, day-of-year, and week-of-year.
- Pip-Boy-like CRT HUD styling with scanlines.
- `VAULT-TEC` header and lower `PWR` / `STAT` / `HP` status strip.
- Real `PWR` battery percentage via AsteroidOS/Nemo MCE on the watch.
- Live `HP` BPM through the installed `pipboy-telemetry` service, which reads
  the confirmed AsteroidOS `com.nokia.SensorService` HR DBus endpoint.
- `ambientMode` property for reduced seconds/animation/scanline behavior.
- Qt Creator project file: `pip-boy-asteroidos.qmlproject`.

## Project Layout

- `qml/` - source QML and shared components.
- `catfish-pipboy/usr/share/asteroid-launcher/` - installable AsteroidOS watchface layout.
- `catfish-pipboy/usr/bin/` and `catfish-pipboy/etc/systemd/` - telemetry
  helper service installed by the SSH deploy script.
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

Local preview uses `dev/qml-stubs/Nemo/Mce` so Qt Creator/qmlscene can render
on a development desktop that does not have AsteroidOS Nemo QML modules.

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
`/usr/share/asteroid-launcher/`, installs/enables `pipboy-telemetry.service`,
and restarts the launcher session.

## Tests

```bash
qmltestrunner -input tests
```

If `qmltestrunner` is unavailable, install Qt test/declarative tooling on the
Ubuntu VM.

## Runtime Data

- `PWR`: real battery percentage from `Nemo.Mce` (`MceBatteryLevel`) on
  AsteroidOS.
- `STAT`: daily steps from the catfish `stepcountersensor` DBus path. The
  telemetry service loads `hybrisstepcounteradaptor` / `stepcountersensor`,
  reads `local.StepCounterSensor.steps`, and stores a per-day baseline under
  `/var/lib/pipboy-telemetry/`. The raw sensor value is "steps since boot", so
  today's count starts from the first telemetry sample of the day.
- `HP`: live heart-rate from `pipboy-telemetry.service`. The service polls the
  confirmed `com.nokia.SensorService` DBus endpoint
  (`/SensorManager/hrmsensor`) with `busctl` for a short sample window every
  180 seconds, writes `/tmp/pipboy-telemetry.qml`, and the watchface reads that
  simple QML snapshot.
  This avoids the current Qt6/Nemo.DBus custom-struct unmarshalling issue for
  `heartRate` type `((x)i)`.
- Development stubs under `dev/qml-stubs/` exist only for desktop preview.
- Weather, notifications, Bluetooth, and alarms depend on the installed
  AsteroidOS build and sync client path.
- Ambient mode is exposed as a property and still needs launcher/display-state
  wiring after module availability is verified.

See also:

- `docs/mvp.md`
- `docs/platform-gap-analysis.md`
- `docs/asset-license-notes.md`
