# Source Layout

This watchface MVP is QML-only.

- Runtime source: `../qml/`
- AsteroidOS install layout: `../catfish-pipboy/usr/share/asteroid-launcher/`
- Tests: `../tests/`

Native C++/CMake sources are intentionally not present in the MVP because a
watchface can be installed as launcher QML plus assets.
