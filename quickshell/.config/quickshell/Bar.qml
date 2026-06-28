import QtQuick
import QtQuick.Layouts
import Quickshell
import "components"
import "config.js" as Config
import "modules"

Scope {
    id: root

    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            color: Config.colors.base
            screen: modelData
            implicitHeight: Config.bar.height

            anchors {
                top: true
                left: true
                right: true
            }

            RowLayout {
                id: mainlayout

                anchors.fill: parent
                spacing: 200

                RowLayout {
                    id: leftLayout

                    Layout.minimumWidth: 200
                    Layout.fillHeight: true
                    spacing: 6

                    HyprlandWindows {
                        screen: modelData
                    }

                    Rectangle {
                        color: 'orange'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        StyledText {
                            anchors.centerIn: parent
                            text: "test"
                        }
                    }

                    Rectangle {
                        color: 'orange'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        StyledText {
                            anchors.centerIn: parent
                            text: "test"
                        }
                    }
                }

                RowLayout {
                    id: centerLayout

                    Layout.minimumWidth: 100
                    Layout.fillHeight: true
                    spacing: 6

                    Rectangle {
                        color: 'green'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        StyledText {
                            anchors.centerIn: parent
                            text: "test"
                        }
                    }
                }

                RowLayout {
                    id: rightlayout

                    Layout.minimumWidth: 200
                    Layout.fillHeight: true
                    spacing: 6

                    Rectangle {
                        color: 'teal'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        StyledText {
                            anchors.centerIn: parent
                            text: "test"
                        }
                    }

                    Rectangle {
                        color: 'teal'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        StyledText {
                            anchors.centerIn: parent
                            text: Time.time
                        }
                    }

                    Tray {}
                }
            }
        }
    }
}
