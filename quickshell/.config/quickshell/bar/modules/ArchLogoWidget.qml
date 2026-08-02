import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../config.js" as Config

Item {
    id: root

    Layout.fillHeight: true
    implicitWidth: label.implicitWidth + 8
    clip: true

    Rectangle {
        anchors.fill: parent
        color: Config.colors.sapphire
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        text: ""
        color: Config.colors.mantle
        font.pixelSize: Config.font.sizes.label
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: PowerMenuState.toggle()
    }
}
