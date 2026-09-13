import QtQuick
import QtQuick.Effects
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
  // Icon-only by default
  readonly property bool showLabel: setting("showLabel", false) === true
  readonly property string chipText: String(setting("chipText", ""))

  property bool appRunning: false
  property double lastLeftClickMs: 0

  readonly property string ctlPath: {
    var u = Qt.resolvedUrl("bin/grok-bot-ctl").toString()
    if (u.indexOf("file://") === 0)
      return decodeURIComponent(u.substring(7))
    return u
  }

  // White symbolic SVG — MultiEffect recolors to bar theme (same pattern as other Omarchy chips)
  readonly property url iconSource: Qt.resolvedUrl("assets/grok-bot.svg")

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

  // Ensure SUPER+W soft-close snippet once (idempotent; reloads Hyprland only if newly added)
  function ensureHyprSoftClose() {
    var hook = root.ctlPath.replace(/grok-bot-ctl$/, "grok-bot-hypr-hook")
    hyprHookProc.command = ["bash", "-lc", shellQuote(hook) + " install"]
    hyprHookProc.running = false
    hyprHookProc.running = true
  }

  Component.onCompleted: Qt.callLater(root.ensureHyprSoftClose)

  Process {
    id: hyprHookProc
    running: false
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

  onBarChanged: {
    Qt.callLater(root.ensureHyprSoftClose)
    injectPanel()
  }

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
    // Image/MultiEffect is the visual when showLabel is false — without this,
    // WidgetButton treats empty text as no content and drops opacity to 0.
    hasVisualContent: true
    keepSpace: true
    labelVisible: root.showLabel && (root.chipText || "Grok").length > 0
    active: root.appRunning
    tooltipText: root.appRunning ? "Grok Bot · running" : "Grok Bot · not running"
    fixedWidth: root.showLabel ? -1 : (root.bar ? root.bar.barSize : Style.bar.sizeHorizontal)
    horizontalMargin: root.showLabel ? 8.5 : 4

    Item {
      id: iconSlot
      anchors.centerIn: parent
      width: Math.max(14, (root.bar ? root.bar.barSize : Style.bar.sizeHorizontal) - 8)
      height: width
      // Clear glanceable state: full urgent tint when running, dimmer fg when stopped
      opacity: root.appRunning ? 1.0 : 0.45

      Behavior on opacity {
        NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
      }

      Image {
        id: icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        source: root.iconSource
        sourceSize.width: width * 2
        sourceSize.height: height * 2
        fillMode: Image.PreserveAspectFit
        // Hidden — MultiEffect paints the themed glyph
        visible: false
        layer.enabled: true
      }

      MultiEffect {
        anchors.fill: icon
        source: icon
        colorization: 1.0
        colorizationColor: root.appRunning ? button.activeColor : button.foreground
      }
    }

    onPressed: function(buttonCode) {
      if (!root.bar) return
      if (buttonCode === Qt.LeftButton) {
        // Debounce rapid hide↔show (unmap/remap double-fire)
        var now = Date.now()
        if (now - root.lastLeftClickMs < 200)
          return
        root.lastLeftClickMs = now
        root.runCtl("left")
      } else if (buttonCode === Qt.RightButton) {
        root.toggle()
      }
    }
  }
}
