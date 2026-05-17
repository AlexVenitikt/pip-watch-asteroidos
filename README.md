# Catfish Pip-Boy Watchface for AsteroidOS

Pip-Boy/Fallout-style HUD watchface for AsteroidOS, optimized for TicWatch Pro 2020 (`catfish_ext`).

## Features
- Pip-Boy style CRT/HUD look with monochrome theme engine.
- Color themes: `green`, `amber`, `blue`, `white`, `red`, `pink`.
- Time/date panel: 24h clock, weekday, `DD/MM/YYYY`, timezone indicator, week-of-year, day-of-year.
- Status panel: battery %, low-battery behavior, charging state, Bluetooth state, alarm placeholder.
- Health panel: heart-rate (`HP`) and steps (`RAD`) with segmented bars and configurable step goal.
- Weather panel: temperature, condition, precipitation, UV, moon phase, sunrise/sunset.
- Ambient/AOD mode: simplified refresh and animation reduction, burn-in micro-offset.
- Lightweight interactive fallback: tap cycles color theme.

## Compatibility
- Primary target: TicWatch Pro 2020 (`catfish_ext`) on AsteroidOS.
- Also expected to run on similar round AsteroidOS devices.
- Verified architecture assumptions: Qt/QML watchface style used by Asteroid launcher.

## Project Layout
- `qml/` main watchface and components.
- `assets/` author-created assets.
- `scripts/` preview/deploy/package scripts.
- `packaging/` package metadata.
- `docs/` architecture and platform gap analysis.
- `manual-test-checklists/` QA matrix and checklist.

## Build / Install
1. Local preview:
```bash
./scripts/preview-qmlscene.sh
```
2. Sync to Asteroid watchface layout:
```bash
./scripts/sync-watchface-layout.sh
```
3. Deploy via SSH:
```bash
./scripts/deploy-ssh.sh <watch-ip>
```
If the watch has no `sudo`, use staging + manual root install:
```bash
ssh ceres@<watch-ip>
su
cp /home/ceres/catfish-pipboy-deploy/watchfaces/catfish-pipboy.qml /usr/share/asteroid-launcher/watchfaces/
cp -r /home/ceres/catfish-pipboy-deploy/watchfaces/logic /usr/share/asteroid-launcher/watchfaces/
cp -r /home/ceres/catfish-pipboy-deploy/watchfaces/ui /usr/share/asteroid-launcher/watchfaces/
cp -r /home/ceres/catfish-pipboy-deploy/watchfaces/settings /usr/share/asteroid-launcher/watchfaces/
cp /home/ceres/catfish-pipboy-deploy/watchfaces-preview/480x480/catfish-pipboy.svg /usr/share/asteroid-launcher/watchfaces-preview/480x480/
cp /home/ceres/catfish-pipboy-deploy/watchface-img/catfish-pipboy.svg /usr/share/asteroid-launcher/watchface-img/
systemctl restart user@1000.service
```
4. Deploy via ADB:
```bash
./scripts/deploy-adb.sh
```
5. Build `.ipk`:
```bash
./scripts/build-ipk.sh
```

## Debugging
- Desktop: use `qmlscene qml/Main.qml` for layout and animation checks.
- Device: use `asteroid-qmltester` for live validation on target.
- Logs: `journalctl -f` on watch (over SSH) while restarting `user@1000.service`.

## Screenshots
- Place generated screenshots into `screenshots/`:
  - normal
  - ambient
  - each color theme
- This repository intentionally does not ship copyrighted Fallout assets.

## Known Limitations
- Companion-driven weather/alarm/BT integration depends on available AsteroidOS data channels on a specific build.
- Watchface tap actions are limited compared with Wear OS complication/action APIs.
- Dual-display specific behavior for TicWatch Pro family is partially supported at platform level.

Details: [docs/platform-gap-analysis.md](/C:/Users/alexv/Documents/NEURO/pip-boy-asteroidos/docs/platform-gap-analysis.md)
Assets: [docs/asset-license-notes.md](/C:/Users/alexv/Documents/NEURO/pip-boy-asteroidos/docs/asset-license-notes.md)
