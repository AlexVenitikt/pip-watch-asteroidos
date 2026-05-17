# Test Matrix

1. Desktop preview (`qmlscene`)
- Launch `./scripts/preview-qmlscene.sh`
- Validate normal mode rendering, text fit, and animation.

2. Device deploy (SSH)
- Run `./scripts/deploy-ssh.sh <watch-ip>`
- Switch to `catfish-pipboy` on watch and verify startup.

3. Device deploy (ADB)
- Run `./scripts/deploy-adb.sh`
- Verify launcher picks updated watchface.

4. Ambient / AOD
- Force ambient entry (timeout/tilt workflow).
- Verify reduced updates and disabled heavy effects.
- Check burn-in micro-offset behavior.

5. Round screen clipping
- Confirm no text clipping across all themes.

6. Low battery
- Validate low-battery indicator visibility and readable contrast.

7. Data disconnected
- Disable companion/weather path.
- Validate placeholder text and no broken bindings.

8. Missing health data
- Validate `N/A` heart-rate and 0/default steps behavior.
