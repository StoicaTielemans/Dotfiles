import QtQuick
import QtQuick.Layouts
import Quickshell
import "../components"
import "../config.js" as Config
import "modules"

Scope {
    id: root

    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            color: Config.colors.mantle
            screen: modelData
            implicitHeight: Config.bar.height

            anchors {
                top: true
                left: true
                right: true
            }

            Item {
                anchors.fill: parent

                RowLayout {
                    id: leftLayout

                    height: parent.height
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: Config.bar.itemSpacing

                    ArchLogoWidget {}

                    HyprlandWindows {
                        screen: modelData
                    }

                    SystemMonitorWidget {}
                }

                RowLayout {
                    id: centerLayout

                    height: parent.height
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: Config.bar.itemSpacing

                    MediaWidget {}
                }

                RowLayout {
                    id: rightlayout

                    height: parent.height
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: Config.bar.itemSpacing

                    MicWidget {}

                    VolumeWidget {}

                    NetworkWidget {}

                    ClockWidget {}

                    Tray {}
                }
            }
        }
    }
}
