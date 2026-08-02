pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components"
import "../../config.js" as Config

PopupWindow {
    id: root

    signal hoverEntered
    signal hoverExited

    anchor.edges: Qt.BottomEdge
    anchor.gravity: Qt.BottomEdge

    implicitWidth: playerColumn.implicitWidth + Config.bar.popupPadding * 2
    implicitHeight: playerColumn.implicitHeight + Config.bar.popupPadding * 2

    // Some players (e.g. browser tabs playing a livestream) report
    // lengthSupported: true with a bogus sentinel value instead of correctly
    // reporting no known length. Treat anything past a sane ceiling as "no duration".
    readonly property real maxSaneDuration: 86400 // 24 hours, in seconds

    function hasDuration(player) {
        return player.lengthSupported && player.length > 0 && player.length < root.maxSaneDuration;
    }

    function formatTime(seconds) {
        if (!seconds || seconds < 0)
            return "0:00";
        const total = Math.floor(seconds);
        const m = Math.floor(total / 60);
        const s = total % 60;
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    // MPRIS position doesn't push updates while playing (see Quickshell docs
    // on MprisPlayer.position); poll it while the popup is open to keep the
    // timeline moving.
    Timer {
        interval: 1000
        running: root.visible
        repeat: true
        onTriggered: {
            for (const p of MediaPlayer.players)
                p.positionChanged();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Config.colors.mantle
        border.color: Config.colors.yellow
        border.width: Config.bar.moduleBorderWidth
        antialiasing: true

        HoverHandler {
            onHoveredChanged: hovered ? root.hoverEntered() : root.hoverExited()
        }

        ColumnLayout {
            id: playerColumn
            anchors {
                top: parent.top
                left: parent.left
                margins: Config.bar.popupPadding
            }
            spacing: 12

            Repeater {
                model: root.visible ? MediaPlayer.players : []

                ColumnLayout {
                    id: playerCard
                    required property var modelData
                    spacing: 4

                    StyledText {
                        Layout.maximumWidth: 300
                        elide: Text.ElideRight
                        text: "󰝚 " + (playerCard.modelData.trackArtist ? playerCard.modelData.trackArtist + " - " : "") + (playerCard.modelData.trackTitle || playerCard.modelData.identity || "Unknown")
                        color: Config.colors.yellow
                        font.bold: true
                        font.pixelSize: Config.font.sizes.label
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: root.hasDuration(playerCard.modelData)
                        spacing: 6

                        StyledText {
                            text: root.formatTime(playerCard.modelData.position)
                            color: Config.colors.subtext0
                            font.pixelSize: Config.font.sizes.sm
                        }

                        Item {
                            id: timelineTrack
                            Layout.fillWidth: true
                            Layout.preferredWidth: 200
                            implicitHeight: 4

                            Rectangle {
                                anchors.fill: parent
                                radius: 2
                                color: Config.colors.surface1
                            }

                            Rectangle {
                                anchors {
                                    left: parent.left
                                    top: parent.top
                                    bottom: parent.bottom
                                }
                                radius: 2
                                color: Config.colors.yellow
                                width: playerCard.modelData.length > 0 ? parent.width * Math.min(1, playerCard.modelData.position / playerCard.modelData.length) : 0
                            }

                            MouseArea {
                                anchors.fill: parent
                                enabled: playerCard.modelData.canSeek
                                cursorShape: Qt.PointingHandCursor
                                onClicked: mouse => {
                                    if (playerCard.modelData.length > 0)
                                        playerCard.modelData.position = (mouse.x / timelineTrack.width) * playerCard.modelData.length;
                                }
                            }
                        }

                        StyledText {
                            text: root.formatTime(playerCard.modelData.length)
                            color: Config.colors.subtext0
                            font.pixelSize: Config.font.sizes.sm
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 14

                        StyledText {
                            text: "󰒮"
                            color: playerCard.modelData.canGoPrevious ? Config.colors.yellow : Config.colors.overlay0
                            font.pixelSize: Config.font.sizes.heading

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                enabled: playerCard.modelData.canGoPrevious
                                onClicked: MediaPlayer.previous(playerCard.modelData)
                            }
                        }

                        StyledText {
                            text: playerCard.modelData.isPlaying ? "󰏤" : "󰐊"
                            color: Config.colors.yellow
                            font.pixelSize: Config.font.sizes.heading

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: MediaPlayer.togglePlaying(playerCard.modelData)
                            }
                        }

                        StyledText {
                            text: "󰒭"
                            color: playerCard.modelData.canGoNext ? Config.colors.yellow : Config.colors.overlay0
                            font.pixelSize: Config.font.sizes.heading

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                enabled: playerCard.modelData.canGoNext
                                onClicked: MediaPlayer.next(playerCard.modelData)
                            }
                        }

                        StyledText {
                            text: MediaPlayer.isMuted(playerCard.modelData) ? "󰖁" : "󰕾"
                            color: playerCard.modelData.volumeSupported ? Config.colors.yellow : Config.colors.overlay0
                            font.pixelSize: Config.font.sizes.heading

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                enabled: playerCard.modelData.volumeSupported
                                onClicked: MediaPlayer.toggleMute(playerCard.modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
