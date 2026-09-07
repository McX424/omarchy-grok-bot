# Grok Bot (Omarchy)

Bar chip for the Grok Bot **desktop app** on Omarchy / Hyprland. Icon-only by default. Opens or focuses the real window — does **not** embed Electron or wrap a CLI.

## Install

```bash
omarchy plugin add https://github.com/McX424/omarchy-grok-bot.git --enable
omarchy bar put mcx424.grok-bot --section right
```

## Clicks

| Click | Action |
|-------|--------|
| Left | Focus **tiled** only (launch if needed). Never toggles float. |
| Right | Menu: Open/Focus tiled · Open floating · Scratchpad · Quit |

Each menu action **sets** the mode explicitly (no toggle). Floating recenters/resizes; if already floating it stays floating.

## Settings

| Key | Default | Meaning |
|-----|---------|---------|
| `command` | `grok-bot` | Launch command |
| `windowClass` | `grok-bot` | Hyprland class |
| `floatWidth` / `floatHeight` | `0.70` / `0.75` | Float size |
| `showLabel` | `false` | Icon only unless true |
| `chipText` | `""` | Optional label when `showLabel` |

Icon asset: `assets/grok-bot.png` (from the desktop `grok-bot` icon).

## License

MIT
