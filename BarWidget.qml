import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root
  moduleName: "mcx424.grok-bot"

  readonly property string launchCmd: String(setting("command", "grok-bot"))
  readonly property string windowClass: String(setting("windowClass", "grok-bot"))
  readonly property real floatWidth: Number(setting("floatWidth", 0.70)) || 0.70
  readonly property real floatHeight: Number(setting("floatHeight", 0.75)) || 0.75
  readonly property bool showLabel: setting("showLabel", true) !== false
  readonly property string chipText: String(setting("chipText", "Grok Bot"))

  property bool appRunning: false

  readonly property string ctlPath: {
    var u = Qt.resolvedUrl("bin/grok-bot-ctl").toString()
    if (u.indexOf("file://") === 0)
      return decodeURIComponent(u.substring(7))
    return u
  }

  function shellQuote(s) {
    return "'" + String(s).replace(/'/g, "'\\''") + "'"
  }

  function runCtl(mode) {
    if (!root.bar || typeof root.bar.run !== "function")
      return
    var cmd = "GROK_BOT_CMD=" + shellQuote(root.launchCmd)
      + " GROK_BOT_CLASS=" + shellQuote(root.windowClass)
      + " " + shellQuote(root.ctlPath)
      + " " + mode
      + " " + root.floatWidth
      + " " + root.floatHeight
    root.bar.run(cmd)
  }

  function refreshRunning() {
    runningProc.running = false
    runningProc.command = ["bash", "-lc",
      "GROK_BOT_CLASS=" + shellQuote(root.windowClass) + " " + shellQuote(root.ctlPath) + " running"]
    runningProc.running = true
  }

  Process {
    id: runningProc
    running: false
    stdout: StdioCollector {
      onStreamFinished: root.appRunning = (text.trim() === "yes")
    }
  }

  Timer {
    interval: 4000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refreshRunning()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.showLabel ? root.chipText : "✦"
    active: root.appRunning
    tooltipText: root.appRunning
      ? "Grok Bot (running)\nLeft: float · Right: tile · Middle: scratchpad"
      : "Grok Bot\nLeft: float · Right: tile · Middle: scratchpad"

    onPressed: function(buttonCode) {
      if (!root.bar) return
      if (buttonCode === Qt.LeftButton) {
        root.runCtl("float")
        Qt.callLater(root.refreshRunning)
      } else if (buttonCode === Qt.RightButton) {
        root.runCtl("tile")
        Qt.callLater(root.refreshRunning)
      } else if (buttonCode === Qt.MiddleButton) {
        root.runCtl("scratch")
        Qt.callLater(root.refreshRunning)
      }
    }
  }
}
