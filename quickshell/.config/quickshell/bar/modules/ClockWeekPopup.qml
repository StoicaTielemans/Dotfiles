pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components"
import "../../components/CalendarUtils.js" as CalendarUtils
import "../../config.js" as Config

PopupWindow {
    id: root

    anchor.edges: Qt.BottomEdge
    anchor.gravity: Qt.BottomEdge

    implicitWidth: weekColumn.implicitWidth + 20
    implicitHeight: weekColumn.implicitHeight + 20

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.mauve
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true

        ColumnLayout {
            id: weekColumn
            anchors.centerIn: parent
            spacing: 10

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: root.visible ? CalendarUtils.weekLabel() : ""
                color: Config.colors.mauve
                font.bold: true
                font.pixelSize: Config.font.sizes.heading
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Repeater {
                    model: root.visible ? CalendarUtils.weekDates() : []

                    ColumnLayout {
                        id: dayCard
                        required property var modelData
                        required property int index
                        spacing: 4

                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: CalendarUtils.weekDayLabels[dayCard.index]
                            color: Config.colors.subtext0
                            font.pixelSize: Config.font.sizes.md
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: 30
                            height: 30
                            radius: 15
                            antialiasing: true
                            color: CalendarUtils.isSameDay(dayCard.modelData, new Date()) ? Config.colors.mauve : "transparent"
                            border.color: Config.colors.mauve
                            border.width: CalendarUtils.isSameDay(dayCard.modelData, new Date()) ? 0 : 1

                            StyledText {
                                anchors.centerIn: parent
                                text: dayCard.modelData.getDate()
                                color: CalendarUtils.isSameDay(dayCard.modelData, new Date()) ? Config.colors.base : Config.colors.text
                                font.bold: CalendarUtils.isSameDay(dayCard.modelData, new Date())
                                font.pixelSize: Config.font.sizes.label
                            }
                        }
                    }
                }
            }
        }
    }
}
