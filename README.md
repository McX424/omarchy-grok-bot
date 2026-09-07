# Grok Bot (Omarchy)

Bar chip for the Grok Bot **desktop app** on Omarchy / Hyprland. Opens or focuses the real window — does **not** embed Electron, scrape usage, or wrap a Grok CLI.

## Install

```bash
omarchy plugin add https://github.com/McX424/omarchy-grok-bot.git --enable
omarchy bar put mcx424.grok-bot --section right
```

Requires `grok-bot` on `PATH`, `hyprctl`, and `jq`.

## Clicks

| Click | Action |
|-------|--------|
| Left | Open / focus **tiled** (normal window) |
| Right | Menu: Open/Focus tiled · Open floating · Scratchpad · Quit |

No hover tooltip (on purpose — the right-click menu is the how-to).

## Settings

| Key | Default | Meaning |
|-----|---------|---------|
| `command` | `grok-bot` | Launch command |
| `windowClass` | `grok-bot` | Hyprland client class |
| `floatWidth` / `floatHeight` | `0.70` / `0.75` | Float size (monitor fraction or px) |
| `showLabel` | `true` | Show chip text |
| `chipText` | `Grok Bot` | Chip label |

```bash
hyprctl clients -j | jq '.[] | {class,title,address}'
```

## License

MIT
