# Catfish Pip-Boy Watchface for AsteroidOS

QML-only Pip-Boy-inspired watchface for AsteroidOS on TicWatch Pro 2020
(`catfish-ext`). The release target is a stable, centered, readable round
watchface with real battery, step, and heart-rate telemetry on the tested
catfish Qt 6 AsteroidOS image.

This project was developed with help from AI-assisted tooling; release code,
packaging, and device behavior are verified on real hardware.

## Features

- Round 480x480-first layout using `safeSize = min(width, height)`.
- Large 24h time, date, day-of-year, and week-of-year.
- Pip-Boy-like CRT HUD styling with scanlines.
- `VAULT-TEC` header and lower `PWR` / `STAT` / `HP` status strip.
- Real `PWR` battery percentage via AsteroidOS/Nemo MCE on the watch.
- Live `HP` BPM through the installed `pipboy-telemetry` service, which reads
  the confirmed AsteroidOS `com.nokia.SensorService` HR DBus endpoint.
- `ambientMode` property for reduced seconds/animation/scanline behavior.
- Qt Creator project file: `pip-boy-asteroidos.qmlproject`.

## Quick Install

Prerequisites:

- AsteroidOS watch with SSH enabled.
- Host machine with `ssh`, `scp`, `tar`, and `ar`.
- Watch IP address, for example USB networking `192.168.2.15` or Wi-Fi.

Build and install directly from the repository:

```bash
git clone https://github.com/AlexVenitikt/pip-watch-asteroidos.git
cd pip-watch-asteroidos
./scripts/install-watchface.sh <watch-ip>
```

The installer builds the `.ipk`, copies it to the watch, installs it with
`opkg`, starts `pipboy-telemetry.service`, and tries to select the watchface for
the `ceres` user.

Manual package install:

```bash
./scripts/build-ipk.sh
scp dist/asteroid-watchface-catfish-pipboy_*.ipk root@<watch-ip>:/tmp/
ssh root@<watch-ip> 'opkg install --force-reinstall /tmp/asteroid-watchface-catfish-pipboy_*.ipk'
```

Useful upstream references:

- [AsteroidOS watchface and package installation](https://wiki.asteroidos.org/index.php/Watchface_and_Package_Installation)
- [AsteroidOS creating a watchface](https://wiki.asteroidos.org/index.php/Creating_a_Watchface)
- [AsteroidOS SSH](https://wiki.asteroidos.org/index.php/SSH)
- [AsteroidOS SDK installation](https://wiki.asteroidos.org/index.php/Installing_the_SDK)

## Project Layout

- `qml/` - source QML and shared components.
- `catfish-pipboy/usr/share/asteroid-launcher/` - installable AsteroidOS watchface layout.
- `catfish-pipboy/usr/bin/` and `catfish-pipboy/etc/systemd/` - telemetry
  helper service installed by the package or SSH deploy script.
- `packaging/` - IPK control metadata and package maintainer scripts.
- `src/` - MVP source notes; no native C++ is needed yet.
- `tests/` - QML/JS formatter tests.
- `docs/` - MVP scope, design brief, architecture, platform notes.
- `scripts/` - preview, sync, deploy, and packaging helpers.

## Design

The release layout uses a compact Pip-Boy-inspired CRT HUD: large readable time,
compact status panels, repository-authored SVG preview art, and no redistributed
proprietary Fallout assets.

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

## Build Release Artifacts

```bash
./scripts/release.sh
```

Outputs are written under `dist/release-v<version>/`:

- `asteroid-watchface-catfish-pipboy_<version>_all.ipk`
- source archive
- `SHA256SUMS`

The build script does not require the full AsteroidOS SDK because this package
contains QML, shell, SVG, and systemd files only. The SDK is still useful for
emulator testing and broader AsteroidOS development.

## Developer Deploy

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

- `docs/architecture.md`
- `docs/platform-gap-analysis.md`
- `docs/asset-license-notes.md`
