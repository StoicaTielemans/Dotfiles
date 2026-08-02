pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../config.js" as Config

PopupWindow {
    id: root

    required property var entries

    anchor.edges: Qt.BottomEdge | Qt.RightEdge
    anchor.gravity: Qt.BottomEdge | Qt.LeftEdge

    implicitWidth: menuColumn.implicitWidth + 16
    implicitHeight: menuColumn.implicitHeight + 16

    function open() {
        root.visible = true;
        focusGrab.active = true;
    }

    function close() {
        root.visible = false;
        focusGrab.active = false;
    }

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.overlay0
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true

        Column {
            id: menuColumn
            anchors {
                top: parent.top
                left: parent.left
                margins: Config.bar.popupPadding
            }
            spacing: 6

            Repeater {
                model: root.entries
                delegate: Rectangle {
                    required property QsMenuEntry modelData
                    property QsMenuEntry entry: modelData
                    property bool hovered: false

                    visible: !entry.isSeparator
                    width: Math.max(menuColumn.implicitWidth, labelText.implicitWidth + 24)
                    height: labelText.implicitHeight + 16
                    radius: 4
                    color: hovered ? Config.colors.surface1 : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: Config.animation.fast
                        }
                    }

                    Text {
                        id: labelText
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 12
                        }
                        text: entry.text
                        color: entry.enabled ? Config.colors.text : Config.colors.overlay0
                        font.pixelSize: Config.font.sizes.label
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: {
                            if (entry.enabled) {
                                entry.triggered();
                                root.close();
                            }
                        }
                    }
                }
            }
        }
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        active: false
        onCleared: root.close()
    }
}
