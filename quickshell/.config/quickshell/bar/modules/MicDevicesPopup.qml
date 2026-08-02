pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components"
import "../../config.js" as Config

PopupWindow {
    id: root

    signal hoverEntered
    signal hoverExited

    anchor.edges: Qt.BottomEdge
    anchor.gravity: Qt.BottomEdge

    implicitWidth: deviceColumn.implicitWidth + Config.bar.popupPadding * 2
    implicitHeight: deviceColumn.implicitHeight + Config.bar.popupPadding * 2

    function muteIcon(node) {
        const muted = node && node.audio && node.audio.muted;
        return muted ? "󰍭" : "󰍬";
    }

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.blue
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true

        HoverHandler {
            onHoveredChanged: hovered ? root.hoverEntered() : root.hoverExited()
        }

        ColumnLayout {
            id: deviceColumn
            anchors {
                top: parent.top
                left: parent.left
                margins: Config.bar.popupPadding
            }
            spacing: 8

            Repeater {
                model: root.visible ? AudioMonitor.sources : []

                RowLayout {
                    id: deviceRow
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 10

                    StyledText {
                        text: AudioMonitor.isDefaultSource(deviceRow.modelData) ? "󰥧" : "󰄰"
                        color: Config.colors.blue
                        font.pixelSize: Config.font.sizes.heading

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: AudioMonitor.setDefaultSource(deviceRow.modelData)
                        }
                    }

                    StyledText {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 260
                        elide: Text.ElideRight
                        text: "󰍬 " + (deviceRow.modelData.description || deviceRow.modelData.name)
                        color: AudioMonitor.isDefaultSource(deviceRow.modelData) ? Config.colors.blue : Config.colors.text
                        font.bold: AudioMonitor.isDefaultSource(deviceRow.modelData)
                        font.pixelSize: Config.font.sizes.label

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: AudioMonitor.setDefaultSource(deviceRow.modelData)
                        }
                    }

                    StyledText {
                        Layout.preferredWidth: 40
                        horizontalAlignment: Text.AlignRight
                        text: AudioMonitor.volumePercentFor(deviceRow.modelData) + "%"
                        color: Config.colors.subtext0
                        font.pixelSize: Config.font.sizes.sm
                    }

                    StyledText {
                        text: root.muteIcon(deviceRow.modelData)
                        color: (deviceRow.modelData.audio && deviceRow.modelData.audio.muted) ? Config.colors.overlay0 : Config.colors.blue
                        font.pixelSize: Config.font.sizes.heading

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: AudioMonitor.toggleMuteFor(deviceRow.modelData)
                        }
                    }
                }
            }
        }
    }
}
