import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import "../components"
import "../config.js" as Config
import "modules"

Scope {
    id: root

    Loader {
        active: PowerMenuState.open

        sourceComponent: Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData

                screen: modelData
                visible: true

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
                focusable: true

                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }

                color: "#4D" + Config.colors.crust.substring(1)

                MouseArea {
                    anchors.fill: parent
                    focus: true
                    Keys.onEscapePressed: PowerMenuState.close()
                    onClicked: PowerMenuState.close()

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 24

                        PowerButton {
                            icon: "󰍃"
                            label: "Logout"
                            accentColor: Config.colors.yellow
                            onTriggered: {
                                PowerMenuState.close();
                                Hyprland.dispatch("exit");
                            }
                        }

                        PowerButton {
                            icon: "󰑓"
                            label: "Restart"
                            accentColor: Config.colors.sky
                            onTriggered: {
                                PowerMenuState.close();
                                restartProc.running = true;
                            }
                        }

                        PowerButton {
                            icon: "󰐥"
                            label: "Shutdown"
                            accentColor: Config.colors.red
                            onTriggered: {
                                PowerMenuState.close();
                                shutdownProc.running = true;
                            }
                        }
                    }
                }

                Process {
                    id: restartProc
                    command: ["systemctl", "reboot"]
                }

                Process {
                    id: shutdownProc
                    command: ["systemctl", "poweroff"]
                }
            }
        }
    }
}
