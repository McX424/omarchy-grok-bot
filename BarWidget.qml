import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "mcx424.grok-bot"

  readonly property string launchCmd: String(setting("command", "grok-bot"))
  readonly property string windowClass: String(setting("windowClass", "grok-bot"))
  readonly property real floatWidth: Number(setting("floatWidth", 875)) || 875
  readonly property real floatHeight: Number(setting("floatHeight", 600)) || 600
  // Icon-only by default (Carl UX)
  readonly property bool showLabel: setting("showLabel", false) === true
  readonly property string chipText: String(setting("chipText", ""))

  property bool appRunning: false

  readonly property string ctlPath: {
    var u = Qt.resolvedUrl("bin/grok-bot-ctl").toString()
    if (u.indexOf("file://") === 0)
      return decodeURIComponent(u.substring(7))
    return u
  }

  readonly property string iconPath: Qt.resolvedUrl("assets/grok-bot.png")

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false
  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false

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
    Qt.callLater(root.refreshRunning)
  }

  function open() {
    if (panelLoader.item) panelLoader.item.open()
  }
  function close() {
    if (panelLoader.item) panelLoader.item.close()
  }
  function toggle() {
    if (panelLoader.item) panelLoader.item.toggle()
  }
  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("anchorItem" in target) target.anchorItem = button
    if ("hostWidget" in target) target.hostWidget = root
    if ("runCtl" in target) target.runCtl = root.runCtl
    if ("appRunning" in target) target.appRunning = root.appRunning
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
      onStreamFinished: {
        root.appRunning = (text.trim() === "yes")
        if (panelLoader.item && "appRunning" in panelLoader.item)
          panelLoader.item.appRunning = root.appRunning
      }
    }
  }

  Timer {
    interval: 4000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refreshRunning()
  }

  onBarChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.showLabel ? (root.chipText || "Grok") : ""
    // Image child is the visual when showLabel is false — without this,
    // WidgetButton treats empty text as no content and drops opacity to 0.
    hasVisualContent: true
    keepSpace: true
    labelVisible: root.showLabel && (root.chipText || "Grok").length > 0
    active: root.appRunning
    tooltipText: ""
    fixedWidth: root.showLabel ? -1 : (root.bar ? root.bar.barSize : Style.bar.sizeHorizontal)
    horizontalMargin: root.showLabel ? 8.5 : 4

    Image {
      id: icon
      anchors.centerIn: parent
      // ~barSize-8 so the glyph fills the chip without clipping
      width: Math.max(14, (root.bar ? root.bar.barSize : Style.bar.sizeHorizontal) - 8)
      height: width
      source: root.iconPath
      fillMode: Image.PreserveAspectFit
      smooth: true
      mipmap: true
      visible: true
      opacity: root.appRunning ? 1 : 0.85
    }

    onPressed: function(buttonCode) {
      if (!root.bar) return
      if (buttonCode === Qt.LeftButton) {
        // Toggle visibility: hide if visible; show tiled if scratched/stopped
        root.runCtl("left")
      } else if (buttonCode === Qt.RightButton) {
        root.toggle()
      }
    }
  }
}
