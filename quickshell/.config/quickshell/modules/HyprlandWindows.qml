pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

Item {
    required property var screen

    readonly property int screenIndex: Quickshell.screens.indexOf(screen)
    readonly property int wsStart: screenIndex === 0 ? 1 : 6
    readonly property int wsEnd: screenIndex === 0 ? 5 : 10

    readonly property var kanjiMap: ({
            "1": "一",
            "2": "二",
            "3": "三",
            "4": "四",
            "5": "五",
            "6": "六",
            "7": "七",
            "8": "八",
            "9": "九",
            "10": "十"
        })

    function dispatch(cmd, arg) {
        if (Hyprland.usingLua) {
            Hyprland.dispatch(cmd + "('" + arg + "')");
        } else {
            Hyprland.dispatch(cmd + " " + arg);
        }
    }

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: {
                void Hyprland.toplevels.count;
                void Hyprland.focusedWorkspace?.id;

                const occupied = new Set(Hyprland.toplevels.values.map(t => t.workspace?.id).filter(id => id !== undefined && id >= wsStart && id <= wsEnd));

                const focusedId = Hyprland.focusedWorkspace?.id;
                if (focusedId !== undefined && focusedId >= wsStart && focusedId <= wsEnd) {
                    occupied.add(focusedId);
                }

                return Array.from(occupied).sort((a, b) => a - b);
            }

            Rectangle {
                required property var modelData
                property bool isActive: Hyprland.focusedWorkspace?.id === modelData
                property bool isHovered: false

                implicitWidth: kanjiText.implicitWidth + 14
                implicitHeight: kanjiText.implicitHeight + 6
                color: isActive ? "transparent" : (isHovered ? Config.colors.lavender : Config.colors.pink)
                border.color: isHovered ? Config.colors.lavender : Config.colors.pink
                border.width: 4

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                Text {
                    id: kanjiText
                    anchors.centerIn: parent
                    text: kanjiMap[String(modelData)] ?? String(modelData)
                    color: isActive ? (isHovered ? Config.colors.lavender : Config.colors.pink) : Config.colors.base
                    font.pixelSize: Config.font.fontSize - 0.5
                    font.bold: true
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.isHovered = true
                    onExited: parent.isHovered = false
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData + " })")
                }
            }
        }
    }
}
