pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components"
import "../../config.js" as Config

Item {
    id: root

    Layout.fillHeight: true
    implicitWidth: label.implicitWidth + 12
    clip: true

    function icon() {
        return AudioMonitor.sourceMuted || AudioMonitor.sourceVolumePercent === 0 ? "󰍭" : "󰍬";
    }

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.blue
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        text: root.icon() + "  " + AudioMonitor.sourceVolumePercent + "%"
        color: Config.colors.blue
        font.pixelSize: Config.font.sizes.label
        font.bold: true
    }

    property bool popupLoaded: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: {
            closeTimer.stop();
            root.popupLoaded = true;
            if (popupLoader.item)
                popupLoader.item.visible = true;
            unloadTimer.restart();
        }
        onExited: closeTimer.restart()
        onClicked: AudioMonitor.toggleMuteSource()
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                AudioMonitor.increaseSource();
            else if (wheel.angleDelta.y < 0)
                AudioMonitor.decreaseSource();
        }
    }

    Timer {
        id: closeTimer
        interval: 250
        onTriggered: {
            if (popupLoader.item)
                popupLoader.item.visible = false;
        }
    }

    Loader {
        id: popupLoader
        active: root.popupLoaded
        onLoaded: item.visible = true

        sourceComponent: MicDevicesPopup {
            anchor.item: root
            onHoverEntered: closeTimer.stop()
            onHoverExited: closeTimer.restart()
        }
    }

    Timer {
        id: unloadTimer
        interval: Config.bar.popupIdleUnload
        onTriggered: {
            if (popupLoader.item && !popupLoader.item.visible)
                root.popupLoaded = false;
        }
    }
}
