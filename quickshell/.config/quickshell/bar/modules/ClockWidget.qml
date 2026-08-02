pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../../components"
import "../../config.js" as Config

Item {
    id: root

    Layout.fillHeight: true
    implicitWidth: label.implicitWidth + 12
    clip: true

    property bool yearOpen: false
    property bool weekLoaded: false
    property bool yearLoaded: false

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.mauve
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        text: Time.time
        color: Config.colors.mauve
        font.pixelSize: Config.font.sizes.label
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: {
            if (!root.yearOpen) {
                root.weekLoaded = true;
                if (weekPopupLoader.item)
                    weekPopupLoader.item.visible = true;
                weekUnloadTimer.restart();
            }
        }
        onExited: {
            if (weekPopupLoader.item)
                weekPopupLoader.item.visible = false;
        }
        onClicked: {
            if (weekPopupLoader.item)
                weekPopupLoader.item.visible = false;

            root.yearOpen = !root.yearOpen;

            if (root.yearOpen) {
                root.yearLoaded = true;
                if (yearPopupLoader.item) {
                    yearPopupLoader.item.visible = true;
                    focusGrab.active = true;
                }
                yearUnloadTimer.restart();
            } else {
                if (yearPopupLoader.item)
                    yearPopupLoader.item.visible = false;
                focusGrab.active = false;
            }
        }
    }

    Loader {
        id: weekPopupLoader
        active: root.weekLoaded
        onLoaded: item.visible = true

        sourceComponent: ClockWeekPopup {
            anchor.item: root
        }
    }

    Loader {
        id: yearPopupLoader
        active: root.yearLoaded
        onLoaded: {
            item.visible = true;
            focusGrab.active = true;
        }

        sourceComponent: ClockYearPopup {
            anchor.item: root
        }
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: yearPopupLoader.item ? [yearPopupLoader.item] : []
        active: false
        onCleared: {
            root.yearOpen = false;
            if (yearPopupLoader.item)
                yearPopupLoader.item.visible = false;
            active = false;
        }
    }

    Timer {
        id: weekUnloadTimer
        interval: Config.bar.popupIdleUnload
        onTriggered: {
            if (weekPopupLoader.item && !weekPopupLoader.item.visible)
                root.weekLoaded = false;
        }
    }

    Timer {
        id: yearUnloadTimer
        interval: Config.bar.popupIdleUnload
        onTriggered: {
            if (yearPopupLoader.item && !yearPopupLoader.item.visible && !root.yearOpen)
                root.yearLoaded = false;
        }
    }
}
