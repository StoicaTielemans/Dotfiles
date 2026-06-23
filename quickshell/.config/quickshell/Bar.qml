import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import "config.js" as Config

Scope {
    id: root

    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            color: Config.colors.base
            screen: modelData
            implicitHeight: 30

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

                    Rectangle {
                        color: 'orange'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            anchors.centerIn: parent
                            text: root.time
                        }

                    }

                    Rectangle {
                        color: 'orange'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            anchors.centerIn: parent
                            text: root.time
                        }

                    }

                    Rectangle {
                        color: 'orange'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            anchors.centerIn: parent
                            text: root.time
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

                        Text {
                            anchors.centerIn: parent
                            text: root.time
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

                        Text {
                            anchors.centerIn: parent
                            text: root.time
                        }

                    }

                    Rectangle {
                        color: 'teal'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            anchors.centerIn: parent
                            text: root.time
                        }

                    }

                    Rectangle {
                        color: 'teal'
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            anchors.centerIn: parent
                            text: root.time
                        }

                    }

                }

            }

        }

    }

    Process {
        id: dateProc

        command: ["date"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.time = this.text
        }

    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }

}
