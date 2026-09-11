# Changelog

## 1.3.12 — 2026-09-11
- Hide to dedicated `special:grokbot` instead of shared `special:scratchpad` (other bar plugins no longer unhide Grok when they toggle the shared scratchpad)
- Still address-by-window; never `togglespecialworkspace`
- Legacy windows already on `special:scratchpad` still count as hidden until the next hide (migrates to grokbot)

## 1.3.11 — 2026-09-08
- Fix chip load: merge duplicate `onBarChanged` handlers (QML "Property value set multiple times")

## 1.3.10 — 2026-09-08
- Fix hypr-hook marker grep (`--` so markers are not flags); dedupe duplicate soft-close blocks

## 1.3.9 — 2026-09-08
- Enforce SUPER+W soft-close when the plugin is enabled (idempotent hyprland.lua snippet; reload only if newly added)
- `bin/grok-bot-hypr-hook` install|uninstall|status; README remove steps include uninstall

## 1.3.8 — 2026-09-08
- Tighten main PID match: require `--ozone-platform`, skip `local-exec-daemon`

## 1.3.7 — 2026-09-08
- Hide/scratch no-ops when there is no window (never launches into scratchpad)
- `process_running` / quit target the main Electron process only (exclude `--type=` helpers)
- Debounce left-click (~200ms) to avoid hide↔show double-fire

## 1.3.6 — 2026-09-08
- Scrub personal comments for marketplace release

## 1.3.5 — 2026-09-08
- Professional GitHub README + `preview.png` for marketplace listing

## 1.3.4 — 2026-09-08
- Marketplace polish: CHANGELOG, README screenshot, tightened listing copy
- Soft-close remains optional (documented; no auto-edit of hyprland.lua)

## 1.3.3 — 2026-09-08
- Menu labels: **Tiled**, **Floating**, **Hide**, **Close Grok Bot**
- README / description clarified for marketplace listing

## 1.3.2 — 2026-09-08
- Fix: scratch/hide Lua `window.move` always targets `address:$ADDR` (was moving the focused window)

## 1.3.1 — 2026-09-08
- Left-click toggles visibility (hide ↔ show tiled); never flips float↔tile

## 1.3.0 — 2026-09-08
- Persist until **Close Grok Bot**: hide to scratchpad keeps process + active chip
- Optional SUPER+W soft-close Hyprland snippet
- Caveat documented: titlebar X still quits Electron on Linux

## 1.2.2 — 2026-09-08
- Icon-only chip: `hasVisualContent: true` + crisp 256px icon
- Default float size **875×600** px

## 1.2.1 — 2026-09-08
- Only dispatch float set/unset when state must change (Omarchy toggles)

## 1.2.0 — 2026-09-08
- Icon-only by default; left focus tiled; right-click action menu

## 1.1.0 — 2026-09-07
- Left = tile, right = menu

## 1.0.1 — 2026-09-07
- Import `Quickshell.Io` so the chip loads

## 1.0.0 — 2026-09-07
- Initial bar chip: float / tile / scratchpad
