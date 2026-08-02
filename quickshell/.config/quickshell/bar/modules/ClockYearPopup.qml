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

    implicitWidth: yearColumn.implicitWidth + 24
    implicitHeight: yearColumn.implicitHeight + 24

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.mauve
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true

        ColumnLayout {
            id: yearColumn
            anchors.centerIn: parent
            spacing: 10

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: String(new Date().getFullYear())
                color: Config.colors.mauve
                font.bold: true
                font.pixelSize: Config.font.sizes.title
            }

            GridLayout {
                columns: 4
                rowSpacing: 16
                columnSpacing: 24

                Repeater {
                    model: root.visible ? 12 : 0

                    ColumnLayout {
                        id: monthCard
                        required property int index
                        property int year: new Date().getFullYear()
                        spacing: 4

                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: CalendarUtils.monthNames[monthCard.index]
                            color: Config.colors.peach
                            font.bold: true
                            font.pixelSize: Config.font.sizes.md
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 4

                            Repeater {
                                model: CalendarUtils.weekDayLabels

                                StyledText {
                                    required property string modelData
                                    Layout.preferredWidth: 18
                                    horizontalAlignment: Text.AlignHCenter
                                    text: modelData.charAt(0)
                                    color: Config.colors.subtext0
                                    font.pixelSize: Config.font.sizes.sm
                                }
                            }
                        }

                        Repeater {
                            model: CalendarUtils.monthGrid(monthCard.year, monthCard.index)

                            RowLayout {
                                id: weekRowItem
                                required property var modelData
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 4

                                Repeater {
                                    model: weekRowItem.modelData

                                    Rectangle {
                                        required property int modelData
                                        width: 18
                                        height: 18
                                        radius: 9
                                        antialiasing: true
                                        color: (modelData !== 0 && CalendarUtils.isSameDay(new Date(monthCard.year, monthCard.index, modelData), new Date())) ? Config.colors.mauve : "transparent"

                                        StyledText {
                                            anchors.centerIn: parent
                                            text: modelData === 0 ? "" : String(modelData)
                                            color: (modelData !== 0 && CalendarUtils.isSameDay(new Date(monthCard.year, monthCard.index, modelData), new Date())) ? Config.colors.base : Config.colors.text
                                            font.pixelSize: Config.font.sizes.xs
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
