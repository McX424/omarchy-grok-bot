import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "mcx424.grok-bot"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  property var runCtl: null
  property bool appRunning: false

  readonly property var barIdentity: hostWidget || root
  readonly property color contentForeground: bar ? bar.foreground : Color.foreground
  readonly property string contentFontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property color mutedForeground: Qt.darker(contentForeground, 1.55)

  function open() {
    root.controller.show()
  }
  function close() {
    root.controller.hide()
  }
  function toggle() {
    if (root.opened) root.close()
    else root.open()
  }
  function closeForPopoutSwitch() {
    root.close()
  }
  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.barIdentity, direction)
    return false
  }

  function act(mode) {
    if (typeof root.runCtl === "function")
      root.runCtl(mode)
    root.close()
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(220))
    contentHeight: panel.fittedContentHeight(content.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function (direction) { root.switchPanel(direction) }

      Column {
        id: content
        width: parent.width
        spacing: Style.space(2)

        Text {
          width: parent.width
          text: "GROK BOT"
          color: root.mutedForeground
          font.family: root.contentFontFamily
          font.pixelSize: Style.font.body
          font.bold: true
          font.letterSpacing: 1.1
          leftPadding: Style.space(8)
          topPadding: Style.space(4)
          bottomPadding: Style.space(4)
        }

        MenuRow {
          label: "Tiled"
          onActivated: root.act("tile")
        }
        MenuRow {
          label: "Floating"
          onActivated: root.act("float")
        }
        MenuRow {
          label: "Hide"
          onActivated: root.act("scratch")
        }
        MenuRow {
          label: "Close Grok Bot"
          danger: true
          rowEnabled: root.appRunning
          onActivated: root.act("quit")
        }
      }
    }
  }

  component MenuRow: Item {
    id: row
    property string label: ""
    property bool danger: false
    property bool rowEnabled: true
    signal activated()

    width: content.width
    height: Style.space(34)
    opacity: rowEnabled ? 1 : 0.35

    Rectangle {
      anchors.fill: parent
      radius: 6
      color: mouse.containsMouse && row.rowEnabled ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
    }

    Text {
      anchors.left: parent.left
      anchors.leftMargin: Style.space(8)
      anchors.verticalCenter: parent.verticalCenter
      text: row.label
      color: row.danger ? (typeof Color !== "undefined" && Color.urgent ? Color.urgent : "#c44") : root.contentForeground
      font.family: root.contentFontFamily
      font.pixelSize: Style.font.body
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      hoverEnabled: true
      enabled: row.rowEnabled
      cursorShape: Qt.PointingHandCursor
      onClicked: row.activated()
    }
  }
}
