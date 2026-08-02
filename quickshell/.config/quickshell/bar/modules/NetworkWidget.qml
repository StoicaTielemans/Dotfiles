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
        if (!NetworkMonitor.interfaceName)
            return "󰚰";
        if (!NetworkMonitor.connected)
            return NetworkMonitor.isWifi ? "󰖪" : "󰈂";
        return NetworkMonitor.isWifi ? "󰖩" : "󰈀";
    }

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.green
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        text: root.icon() + (NetworkMonitor.connected ? "  ↓" + NetworkMonitor.rxRateText + "  ↑" + NetworkMonitor.txRateText : " Disconnected")
        color: Config.colors.green
        font.pixelSize: Config.font.sizes.label
        font.bold: true
    }

    property bool tooltipLoaded: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            root.tooltipLoaded = true;
            if (tooltipLoader.item)
                tooltipLoader.item.visible = true;
            unloadTimer.restart();
        }
        onExited: {
            if (tooltipLoader.item)
                tooltipLoader.item.visible = false;
        }
    }

    Loader {
        id: tooltipLoader
        active: root.tooltipLoaded
        onLoaded: item.visible = true

        sourceComponent: NetworkTooltip {
            anchor.item: root
        }
    }

    Timer {
        id: unloadTimer
        interval: Config.bar.popupIdleUnload
        onTriggered: {
            if (tooltipLoader.item && !tooltipLoader.item.visible)
                root.tooltipLoaded = false;
        }
    }
}
