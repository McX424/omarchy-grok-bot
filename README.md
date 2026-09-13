# Grok Bot for Omarchy

Icon-only Omarchy bar chip for the [Grok Bot](https://omarchy.org) desktop app — themeable, glanceable running state, hide without quitting.

This plugin drives the real Hyprland window. It does **not** embed Electron, wrap a CLI, or ship the Grok Bot binary.

<p align="center">
  <img src="preview.png" alt="Omarchy bar with themed Grok Bot chip" width="900" />
</p>

<p align="center">
  <img src="docs/bar.png" alt="Bar chip detail — themeable SVG next to other Omarchy icons" width="900" />
</p>

<p align="center">
  <a href="https://github.com/McX424/omarchy-grok-bot/releases"><img alt="version" src="https://img.shields.io/github/v/release/McX424/omarchy-grok-bot?include_prereleases&sort=semver&label=version&color=7aa2f7" /></a>
  <img alt="license" src="https://img.shields.io/badge/license-MIT-9ece6a" />
  <img alt="platform" src="https://img.shields.io/badge/platform-Omarchy%20%2F%20Hyprland-bb9af7" />
</p>

## Features

- **Themeable SVG chip** — monochrome symbolic mark, recolored with `MultiEffect` to the bar foreground (same pattern as other Omarchy icons). When the app is running, tint switches to the bar **urgent / active** color at full opacity; when stopped, dimmed foreground.
- **Glanceable running state** — bright when the process is alive, dim when not. Hidden on `special:grokbot` still counts as **running** (soft-hide keeps the process).
- **Left-click toggle** — hide ↔ show tiled. Hide uses a **dedicated** `special:grokbot` workspace (not the shared scratchpad other plugins toggle).
- **Right-click menu** — **Tiled** · **Floating** · **Hide** · **Close Grok Bot** (modes are set, never float↔tile toggles).
- **Float default 875×600** — matches stock Omarchy floating windows; overridable in settings.
- **SUPER+W soft-close** — when focused on Grok Bot, hides to `special:grokbot` (process stays; chip stays lit). Other windows still close normally.
- **Titlebar X still quits** — Electron’s window-close path calls `app.quit` on Linux; prefer Hide / left-click / SUPER+W to soft-dismiss.

## Requirements

- [Omarchy](https://omarchy.org) with the Quickshell bar (`omarchy-shell`)
- The **Grok Bot** desktop app on `PATH` (typically `grok-bot` → `/opt/Grok Bot`)

No API keys or extra services.

## Install

```bash
omarchy plugin add https://github.com/McX424/omarchy-grok-bot.git --enable
omarchy bar put mcx424.grok-bot --section right
```

Validate:

```bash
omarchy plugin validate ~/.config/omarchy/plugins/mcx424.grok-bot
```

## Usage

| Input | Action |
| --- | --- |
| **Left-click** | Toggle visibility: hide if on a normal workspace; show **tiled** + focus if hidden (`special:grokbot`) or not running |
| **Right-click → Tiled** | Focus and force tiled (launch if needed) |
| **Right-click → Floating** | Focus, force float, resize to settings, center |
| **Right-click → Hide** | Move to dedicated `special:grokbot` — process keeps running, chip stays active |
| **Right-click → Close Grok Bot** | Quit the app |

### Soft-hide vs quit

Hide (menu, left-click, or SUPER+W) keeps the Electron process alive so chats and local tools keep running while the window is out of the way.

The app titlebar **X** still quits Grok Bot on Linux. Prefer soft-hide when you only want it out of sight.

### SUPER+W soft-close

Enabled with the plugin: an idempotent snippet in `~/.config/hypr/hyprland.lua` (marker `BEGIN mcx424.grok-bot soft-close`). Hyprland reloads **only** if the snippet was newly added.

On remove:

```bash
~/.config/omarchy/plugins/mcx424.grok-bot/bin/grok-bot-hypr-hook uninstall
```

## Configure

Defaults in `manifest.json`. Override via Omarchy bar widget settings or the `mcx424.grok-bot` entry in `~/.config/omarchy/shell.json`.

| Key | Default | Description |
| --- | --- | --- |
| `command` | `grok-bot` | Launch command on `PATH` |
| `windowClass` | `grok-bot` | Hyprland window class |
| `floatWidth` / `floatHeight` | `875` / `600` | Float size in pixels, or a fraction ≤ 1 of the monitor |
| `showLabel` | `false` | Show chip text |
| `chipText` | `""` | Label when `showLabel` is true (falls back to `Grok`) |

## Update

```bash
omarchy plugin update mcx424.grok-bot
```

## Remove

```bash
~/.config/omarchy/plugins/mcx424.grok-bot/bin/grok-bot-hypr-hook uninstall
omarchy plugin remove mcx424.grok-bot
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md). Latest: **v1.3.14**.

## License

MIT · [McX424](https://github.com/McX424)
