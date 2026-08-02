pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components"
import "../../config.js" as Config

Item {
    id: root

    readonly property var player: MediaPlayer.activePlayer

    Layout.fillHeight: true
    visible: root.player !== null
    implicitWidth: root.visible ? label.width + 12 : 0
    clip: true

    function icon() {
        return root.player && root.player.isPlaying ? "󰏤" : "󰐊";
    }

    function trackText() {
        if (!root.player)
            return "";
        const artist = root.player.trackArtist;
        const title = root.player.trackTitle || root.player.identity || "Unknown";
        return artist ? artist + " - " + title : title;
    }

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.yellow
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        width: Math.min(implicitWidth, 300)
        elide: Text.ElideRight
        text: root.icon() + "  " + root.trackText()
        color: Config.colors.yellow
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
        onClicked: MediaPlayer.togglePlaying(root.player)
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

        sourceComponent: MediaPopup {
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
