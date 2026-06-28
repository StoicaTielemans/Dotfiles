pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../config.js" as Config

RowLayout {
    id: trayLayout
    implicitWidth: trayRepeater.implicitWidth
    implicitHeight: trayRepeater.implicitHeight

    Repeater {
        id: trayRepeater
        model: SystemTray.items
        delegate: Item {
            id: trayDelegate
            required property SystemTrayItem modelData
            property SystemTrayItem item: modelData
            width: 20
            height: 20

            IconImage {
                anchors.fill: parent
                source: trayDelegate.item.icon
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: event => {
                    switch (event.button) {
                    case Qt.LeftButton:
                        if (trayDelegate.item.onlyMenu) {
                            if (trayDelegate.item.hasMenu) {
                                customMenu.visible = true;
                                focusGrab.active = true;
                            }
                        } else {
                            trayDelegate.item.activate();
                        }
                        break;
                    case Qt.RightButton:
                        if (trayDelegate.item.hasMenu) {
                            customMenu.visible = true;
                            focusGrab.active = true;
                        }
                        break;
                    }
                }
            }

            QsMenuOpener {
                id: menuHandle
                menu: trayDelegate.item.menu
            }

            PopupWindow {
                id: customMenu
                visible: false

                anchor.item: trayDelegate
                anchor.edges: Qt.BottomEdge | Qt.LeftEdge
                anchor.gravity: Qt.BottomEdge | Qt.LeftEdge

                implicitWidth: menuColumn.implicitWidth + 16
                implicitHeight: menuColumn.implicitHeight + 16

                Rectangle {
                    anchors.fill: parent
                    color: Config.colors.base
                    border.color: Config.colors.surface1
                    border.width: 2

                    Column {
                        id: menuColumn
                        anchors {
                            top: parent.top
                            left: parent.left
                            margins: 8
                        }
                        spacing: 2

                        Repeater {
                            model: menuHandle.children
                            delegate: Rectangle {
                                required property QsMenuEntry modelData
                                property QsMenuEntry entry: modelData
                                property bool hovered: false

                                visible: !entry.isSeparator
                                width: Math.max(menuColumn.implicitWidth, labelText.implicitWidth + 24)
                                height: labelText.implicitHeight + 10
                                radius: 4
                                color: hovered ? Config.colors.surface1 : "transparent"

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 100
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
                                    font.pixelSize: Config.font.fontSize
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
                                            customMenu.visible = false;
                                            focusGrab.active = false;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            HyprlandFocusGrab {
                id: focusGrab
                windows: [customMenu]
                active: false
                onCleared: {
                    customMenu.visible = false;
                    active = false;
                }
            }
        }
    }
}
