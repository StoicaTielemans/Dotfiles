pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../config.js" as Config

Rectangle {
    id: root

    required property string icon
    required property string label
    required property color accentColor
    signal triggered

    property bool hovered: false

    implicitWidth: 180
    implicitHeight: 180
    radius: 0
    color: root.hovered ? Config.colors.surface0 : Config.colors.mantle
    border.color: root.accentColor
    border.width: Config.bar.moduleBorderWidth
    antialiasing: true

    Behavior on color {
        ColorAnimation {
            duration: Config.animation.fast
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 8

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: root.icon
            color: root.accentColor
            font.pixelSize: Config.font.sizes.display
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: root.label
            color: root.accentColor
            font.pixelSize: Config.font.sizes.heading
            font.bold: true
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: root.triggered()
    }
}
