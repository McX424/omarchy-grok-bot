-- mcx424.grok-bot: SUPER+W soft-closes Grok Bot to scratchpad (process stays alive).
-- Titlebar / app X still quits Electron — Hyprland cannot intercept that.
do
  local home = os.getenv("HOME") or ""
  local ctl = home .. "/.config/omarchy/plugins/mcx424.grok-bot/bin/grok-bot-soft-close"
  local f = io.open(ctl, "r")
  if not f then
    return
  end
  f:close()
  hl.unbind("SUPER + W")
  o.bind("SUPER + W", "Close window (Grok Bot → scratchpad)", ctl)
end
