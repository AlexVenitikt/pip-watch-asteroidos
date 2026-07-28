# Architecture

## Modules
- `qml/Main.qml`: composition root, mode switching, layout orchestration.
- `qml/ui/`: presentational components (`PipboySegmentBar`, `PipboyScanlines`, `PipboyCharacter`).
- `qml/logic/`: formatting helpers and future data bridge stubs.
- `qml/settings/`: reserved settings surface.

## Separation of Concerns
- Presentation: all visual nodes and effects in `qml/Main.qml` + `qml/ui/*`.
- Data access: currently stubbed inside `qml/Main.qml`; `qml/logic/PipboyDataBridge.qml` is retained for later confirmed AsteroidOS providers.
- Formatting and mapping: `qml/logic/pipboyFormatter.js`.
- Theme/config: retained as a future extension point.

## Performance Strategy
- Timer frequency lowered in ambient mode to 60s.
- Scanline overlay and most animations disabled in simplified/ambient.
- Lightweight geometric drawing instead of heavy texture-based effects.
- Defensive fallback states for unavailable data (no null binding storms).

## Layout Strategy
- Top-level QML has a 480x480 fallback size for desktop preview.
- Runtime geometry is based on `Math.min(width, height)`.
- Content is placed inside an 84% square safe area centered in the circular face.
