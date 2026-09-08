# Grok Bot (Omarchy)

Bar chip for the Grok Bot **desktop app** on Omarchy / Hyprland. Icon-only by default. Left-click toggles hide/show; right-click picks tiled, floating, or hide. Does **not** embed Electron.

## Install

```bash
omarchy plugin add https://github.com/McX424/omarchy-grok-bot.git --enable
omarchy bar put mcx424.grok-bot --section right
```

Requires the `grok-bot` desktop app on `PATH` (Omarchy package / `/opt/Grok Bot`).

### Optional: SUPER+W soft-close

So **SUPER+W** hides Grok Bot to the scratchpad instead of quitting, add this to `~/.config/hypr/hyprland.lua` (after Omarchy defaults), then `hyprctl reload`:

```lua
do local path = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config")
  .. "/omarchy/plugins/mcx424.grok-bot/hypr/mcx424-grok-bot.lua"
  local file = io.open(path, "r"); if file then file:close(); dofile(path) end end
```

## Clicks

| Click | Action |
|-------|--------|
| Left | Toggle visibility: **Hide** if visible; show **Tiled** if hidden / not running. Never flips float↔tile. |
| Right | **Tiled** · **Floating** · **Hide** · **Close Grok Bot** |

Menu actions set mode explicitly (no toggles). Floating uses **875×600** by default (Omarchy-like).

## Persist until Close Grok Bot

- **Hide** / soft-close keeps the process; the chip stays active.
- **Close Grok Bot** quits the app.
- **Caveat:** the window titlebar **X** still quits Electron on Linux. Prefer Hide / SUPER+W for casual dismiss.

## Settings

| Key | Default | Meaning |
|-----|---------|---------|
| `command` | `grok-bot` | Launch command |
| `windowClass` | `grok-bot` | Hyprland class |
| `floatWidth` / `floatHeight` | `875` / `600` | Float size (px, or fraction ≤1) |
| `showLabel` | `false` | Icon only unless true |
| `chipText` | `""` | Optional label when `showLabel` |

## License

MIT
