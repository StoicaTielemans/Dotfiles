pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../../config.js" as Config

RowLayout {
    id: trayLayout
    visible: trayRepeater.count > 0
    implicitWidth: trayRepeater.implicitWidth
    implicitHeight: trayRepeater.implicitHeight

    Repeater {
        id: trayRepeater
        model: SystemTray.items
        delegate: Item {
            id: trayDelegate
            required property SystemTrayItem modelData
            property SystemTrayItem item: modelData
            property bool menuLoaded: false
            width: Config.bar.height
            height: Config.bar.height

            IconImage {
                anchors.fill: parent
                source: trayDelegate.item.icon
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: event => {
                    if (trayDelegate.item.hasMenu) {
                        trayDelegate.menuLoaded = true;
                        if (contextMenuLoader.item)
                            contextMenuLoader.item.open();
                        unloadTimer.restart();
                    } else if (event.button === Qt.LeftButton) {
                        trayDelegate.item.activate();
                    }
                }
            }

            QsMenuOpener {
                id: menuHandle
                menu: trayDelegate.item.menu
            }

            Loader {
                id: contextMenuLoader
                active: trayDelegate.menuLoaded
                onLoaded: item.open()

                sourceComponent: TrayContextMenu {
                    anchor.item: trayDelegate
                    entries: menuHandle.children
                }
            }

            Timer {
                id: unloadTimer
                interval: Config.bar.popupIdleUnload
                onTriggered: {
                    if (contextMenuLoader.item && !contextMenuLoader.item.visible)
                        trayDelegate.menuLoaded = false;
                }
            }
        }
    }
}
