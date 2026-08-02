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

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.peach
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        text: "󰍛 " + SystemMonitor.stats
        color: Config.colors.peach
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

        sourceComponent: SystemMonitorTooltip {
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
