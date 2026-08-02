import QtQuick
import Quickshell
import Quickshell.Services.Mpris
pragma Singleton

Singleton {
    id: root

    readonly property var players: Mpris.players.values.filter(p => !p.dbusName.includes("playerctld"))
    readonly property var activePlayer: pickActive()

    property var _mutedVolumes: ({})

    function pickActive() {
        const list = root.players;
        if (!list || list.length === 0)
            return null;
        return list.find(p => p.isPlaying) || list[0];
    }

    function togglePlaying(player) {
        if (!player)
            return;
        if (player.canTogglePlaying)
            player.togglePlaying();
        else if (player.isPlaying && player.canPause)
            player.pause();
        else if (!player.isPlaying && player.canPlay)
            player.play();
    }

    function next(player) {
        if (player && player.canGoNext)
            player.next();
    }

    function previous(player) {
        if (player && player.canGoPrevious)
            player.previous();
    }

    function isMuted(player) {
        return !!(player && root._mutedVolumes[player.dbusName] !== undefined);
    }

    function toggleMute(player) {
        if (!player || !player.volumeSupported)
            return;

        const muted = Object.assign({}, root._mutedVolumes);
        const key = player.dbusName;

        if (key in muted) {
            player.volume = muted[key];
            delete muted[key];
        } else {
            muted[key] = player.volume;
            player.volume = 0;
        }

        root._mutedVolumes = muted;
    }
}
