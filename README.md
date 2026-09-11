# Grok Bot for Omarchy

Control the [Grok Bot](https://omarchy.org) desktop app from your Omarchy bar — icon-only chip, hide without quitting, tiled or floating on demand.

This plugin talks to the real app window over Hyprland. It does **not** embed Electron, wrap a CLI, or ship the Grok Bot binary.

<p align="center">
  <img src="preview.png" alt="Grok Bot bar chip and right-click menu" width="720" />
</p>

<p align="center">
  <a href="https://github.com/McX424/omarchy-grok-bot/releases"><img alt="version" src="https://img.shields.io/github/v/release/McX424/omarchy-grok-bot?include_prereleases&sort=semver&label=version&color=4C8BF5" /></a>
  <img alt="license" src="https://img.shields.io/badge/license-MIT-green" />
  <img alt="platform" src="https://img.shields.io/badge/platform-Omarchy%20%2F%20Hyprland-111111" />
</p>

## Why this plugin

- **One chip, no clutter** — icon-only by default; optional label if you want it
- **Left-click toggles visibility** — hide to a private special workspace, show tiled again; process stays alive and the chip stays lit
- **Right-click is literal** — **Tiled** · **Floating** · **Hide** · **Close Grok Bot** (no float↔tile toggles)
- **Omarchy-sized float** — default floating window is **875×600**, matching stock Omarchy floating windows
- **Explicit quit only** — casual dismiss keeps Grok Bot running until you choose **Close Grok Bot**
- **SUPER+W soft-close** — installed with the plugin; hides Grok Bot instead of quitting

## Requirements

- [Omarchy](https://omarchy.org) with the Quickshell-based bar (`omarchy-shell`)
- The **Grok Bot** desktop app on `PATH` (typically `grok-bot` → `/opt/Grok Bot`)

Nothing else — no API keys, no extra services.

## Install

```bash
omarchy plugin add https://github.com/McX424/omarchy-grok-bot.git --enable
omarchy bar put mcx424.grok-bot --section right
```

Validate if you like:

```bash
omarchy plugin validate ~/.config/omarchy/plugins/mcx424.grok-bot
```

The chip should appear in the bar. Left-click launches or restores Grok Bot tiled; right-click opens the menu.

## Usage

| Input | Action |
| --- | --- |
| **Left-click** | Toggle visibility: hide if the window is on a normal workspace; show **tiled** + focus if it is hidden (`special:grokbot`) or not running |
| **Right-click → Tiled** | Focus and force tiled (launch if needed) |
| **Right-click → Floating** | Focus, force float, resize to settings, center |
| **Right-click → Hide** | Move to dedicated `special:grokbot` — process keeps running, chip stays active (not the shared scratchpad) |
| **Right-click → Close Grok Bot** | Quit the app |

Menu actions **set** a mode; they never toggle float↔tile.

### Persist until Close

Hide (menu or left-click) is intentional soft-dismiss. The Electron process stays up so agents, chats, and local tools keep running while the window is out of the way.

**Caveat:** the app’s own titlebar **X** still quits Grok Bot on Linux (`window-all-closed` → `app.quit`). Hyprland cannot rewrite that into a hide. Prefer **Hide**, left-click, or the optional SUPER+W soft-close below.

### SUPER+W soft-close (default)

When the plugin is enabled, **SUPER+W** soft-hides a focused Grok Bot window to `special:grokbot` (process stays; chip stays lit). Other windows still close normally.

The chip ensures an idempotent snippet in `~/.config/hypr/hyprland.lua` once (marker `BEGIN mcx424.grok-bot soft-close`) and runs `hyprctl reload` **only** if the snippet was newly added — not on every update or QML save.

**Caveat:** the app titlebar **X** still quits Electron on Linux. Prefer SUPER+W, left-click, or **Hide**.

On remove, run:

```bash
~/.config/omarchy/plugins/mcx424.grok-bot/bin/grok-bot-hypr-hook uninstall
```

(`omarchy plugin remove` does not run Hyprland hooks automatically.)

## Configure

Defaults live in `manifest.json`. Override via Omarchy bar widget settings or the `mcx424.grok-bot` entry in `~/.config/omarchy/shell.json`.

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

That removes the SUPER+W snippet (and reloads Hyprland once), then deletes the plugin folder and drops the widget from your bar layout.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

MIT
