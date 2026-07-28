# Platform Gap Analysis (Wear OS refs vs AsteroidOS)

## Implemented 1:1 or Near-Equivalent
- Pip-Boy HUD identity with monochrome CRT-inspired UI.
- Multi-color theme palette (green/amber/blue/white/red/pink).
- 24h time-first layout, date, weekday, timezone label, WOY/DOY.
- Battery/charging/low-power indicators.
- HP/RAD metaphors for heart-rate and steps, segmented bars.
- Weather section fields with resilient placeholders.
- Ambient mode with reduced visual complexity.

## Adapted for AsteroidOS
- Wear OS complications/actions replaced by watchface-level lightweight interaction (theme cycling on tap).
- Data ingest is abstracted through `PipboyDataBridge.qml`; battery is wired to
  the confirmed AsteroidOS `Nemo.Mce` QML module. Steps and recorded HR are
  isolated in an optional `SensorlogdBridge.qml` loader.
- Burn-in handling done via micro-offset in ambient updates.

## Not Fully Reproducible
- Wear OS companion-specific complication ecosystem and direct app-launch actions are not API-identical on AsteroidOS watchface layer.
- Guaranteed availability of weather, next alarm, steps, and heart-rate history
  depends on companion integration stack/version and installed health services.
- Dual-display behavior on TicWatch Pro family remains partially constrained by platform support state.

## Current Device Findings
- `Nemo.Mce` is present on the catfish watch and exposes battery level/state.
- `asteroid-hrm` is installed as a foreground heart-rate app and its official
  QML source uses `QtSensors` `HrmSensor { active: true }` with `reading.bpm`.
- The current launcher log reports `HrmSensor is not a type`, so the watchface
  keeps HR optional and does not fail when that type is unavailable.
- `asteroid-health` / `asteroid-sensorlogd` were installed from the AsteroidOS
  2.0 Qt5 feed because current nightly feeds expose Qt6 package upgrades while
  the watch is running a Qt5 launcher.

## Licensing / Asset Policy
- No direct reuse of proprietary Fallout assets.
- All shipped visual assets are repository-authored primitives/SVG.
- If third-party font/assets are added later, they must include redistribution-friendly licenses and attribution.
