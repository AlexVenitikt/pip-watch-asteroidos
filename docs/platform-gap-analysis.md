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
- Data ingest is abstracted through `PipboyDataBridge.qml` to map Asteroid-available sources.
- Burn-in handling done via micro-offset in ambient updates.

## Not Fully Reproducible
- Wear OS companion-specific complication ecosystem and direct app-launch actions are not API-identical on AsteroidOS watchface layer.
- Guaranteed availability of weather, next alarm, and some telemetry depends on companion integration stack/version (AsteroidOSSync/Gadgetbridge path).
- Dual-display behavior on TicWatch Pro family remains partially constrained by platform support state.

## Licensing / Asset Policy
- No direct reuse of proprietary Fallout assets.
- All shipped visual assets are repository-authored primitives/SVG.
- If third-party font/assets are added later, they must include redistribution-friendly licenses and attribution.
