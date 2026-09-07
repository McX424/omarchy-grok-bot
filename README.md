# Grok Bot (Omarchy)

Bar chip for the [Grok Bot](https://grok.x.ai/) **desktop app** on Omarchy / Hyprland. It opens or focuses the real app window — it does **not** embed Electron, scrape usage, or wrap the Grok CLI.

Not related to `ai-usagebar` (token meters) or terminal Grok CLIs.

## Install

```bash
omarchy plugin add https://github.com/McX424/omarchy-grok-bot.git --enable
```

Place on the bar if needed:

```bash
omarchy bar put mcx424.grok-bot --section right
```

Requires `grok-bot` on `PATH` (Omarchy package installs `/usr/bin/grok-bot`) and `hyprctl` + `jq`.

## Clicks

| Click | Action |
|-------|--------|
| Left | Launch or focus, **float**, resize (~70%×75% of the focused monitor), center |
| Right | Launch or focus, **tile** |
| Middle | Move to Omarchy **`special:scratchpad`** (same as Super+Alt+S) |

## Settings

| Key | Default | Meaning |
|-----|---------|---------|
| `command` | `grok-bot` | Launch command |
| `windowClass` | `grok-bot` | Hyprland client class to focus |
| `floatWidth` / `floatHeight` | `0.70` / `0.75` | Fraction of monitor (or px if > 1) |
| `showLabel` | `true` | Show chip text |
| `chipText` | `Grok Bot` | Chip label |

Example override:

```bash
omarchy bar set mcx424.grok-bot command "/opt/Grok Bot/grok-bot"
omarchy bar set mcx424.grok-bot windowClass grok-bot
```

Confirm class / title:

```bash
hyprctl clients -j | jq '.[] | {class,title,address}'
```

## How it works

`bin/grok-bot-ctl` mirrors Omarchy’s `omarchy-launch-or-focus` / `hypr_dispatch` pattern: try Lua `hl.dsp.*` first, fall back to classic Hyprland dispatchers. Floating size uses the focused monitor’s geometry.

Middle-click uses the stock Omarchy scratchpad workspace `special:scratchpad` (toggle with Super+S).

The chip polls whether a matching window exists and keeps the label bright when Grok Bot is running.

## License

MIT
