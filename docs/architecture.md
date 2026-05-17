# Architecture

## Modules
- `qml/Main.qml`: composition root, mode switching, layout orchestration.
- `qml/ui/`: presentational components (`PipboySegmentBar`, `PipboyScanlines`, `PipboyCharacter`).
- `qml/logic/`: formatting, theme registry, data bridge.
- `qml/settings/`: persistent settings via `Qt.labs.settings`.

## Separation of Concerns
- Presentation: all visual nodes and effects in `qml/Main.qml` + `qml/ui/*`.
- Data access: `qml/logic/PipboyDataBridge.qml`.
- Formatting and mapping: `qml/logic/pipboyFormatter.js`.
- Theme/config: `qml/logic/pipboyThemes.js` and `qml/settings/PipboySettings.qml`.

## Performance Strategy
- Timer frequency lowered in ambient mode to 60s.
- Scanline overlay and most animations disabled in simplified/ambient.
- Lightweight geometric drawing instead of heavy texture-based effects.
- Defensive fallback states for unavailable data (no null binding storms).
