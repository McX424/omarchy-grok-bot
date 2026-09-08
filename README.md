# Grok Bot (Omarchy)

Bar chip for the Grok Bot **desktop app** on Omarchy / Hyprland. Icon-only by default. Opens or focuses the real window — does **not** embed Electron or wrap a CLI.

## Install

```bash
omarchy plugin add https://github.com/McX424/omarchy-grok-bot.git --enable
omarchy bar put mcx424.grok-bot --section right
```

Soft-close (recommended): load the Hyprland snippet so **SUPER+W** hides Grok Bot to the scratchpad instead of quitting:

```lua
-- in ~/.config/hypr/hyprland.lua (after Omarchy defaults)
do local path = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config")
  .. "/omarchy/plugins/mcx424.grok-bot/hypr/mcx424-grok-bot.lua"
  local file = io.open(path, "r"); if file then file:close(); dofile(path) end end
```

Then reload Hyprland / restart the session config.

## Clicks

| Click | Action |
|-------|--------|
| Left | **Toggle visibility**: hide to scratchpad if visible; show **tiled** + focus if hidden/not running. Never flips float↔tile. |
| Right | Menu: Open/Focus tiled · Floating · Move to scratchpad · Close Grok Bot |

Each menu action **sets** the mode explicitly (no toggle). Floating recenters/resizes at **875×600** by default.

## Persist until Close Grok Bot

- **Move to scratchpad** / soft-close (**SUPER+W** with the snippet) hides the window; the process stays up and the chip stays active.
- **Close Grok Bot** is the only chip action that quits the app.
- **Caveat:** the app’s own titlebar / window **X** still quits Electron on Linux (`window-all-closed` → `app.quit`). Hyprland cannot rewrite that into a hide. Prefer SUPER+W or the scratchpad menu item for casual dismiss.

## Settings

| Key | Default | Meaning |
|-----|---------|---------|
| `command` | `grok-bot` | Launch command |
| `windowClass` | `grok-bot` | Hyprland class |
| `floatWidth` / `floatHeight` | `875` / `600` | Float size (px, or fraction ≤1) |
| `showLabel` | `false` | Icon only unless true |
| `chipText` | `""` | Optional label when `showLabel` |

Icon asset: `assets/grok-bot.png` (from the desktop `grok-bot` icon).

## License

MIT
