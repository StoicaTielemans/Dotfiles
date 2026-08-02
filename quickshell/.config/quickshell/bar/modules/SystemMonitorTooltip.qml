import QtQuick
import Quickshell
import "../../components"
import "../../config.js" as Config

PopupWindow {
    id: root

    anchor.edges: Qt.BottomEdge | Qt.LeftEdge
    anchor.gravity: Qt.BottomEdge | Qt.LeftEdge

    implicitWidth: tooltipText.implicitWidth + 16
    implicitHeight: tooltipText.implicitHeight + 16

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.peach
        border.width: Config.bar.moduleBorderWidth

        StyledText {
            id: tooltipText
            anchors {
                top: parent.top
                left: parent.left
                margins: Config.bar.popupPadding
            }
            text: SystemMonitor.tooltip
            color: Config.colors.peach
            font.pixelSize: Config.font.sizes.tooltip
            font.bold: true
        }
    }
}
