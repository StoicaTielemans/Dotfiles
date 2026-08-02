import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
pragma Singleton

Singleton {
    id: root

    readonly property real step: 0.05
    readonly property real maxVolume: 2.0

    // Output (sink / speakers, headset)
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: root.sink && root.sink.audio ? root.sink.audio.volume : 0
    readonly property bool muted: root.sink && root.sink.audio ? root.sink.audio.muted : false
    readonly property int volumePercent: Math.round(root.volume * 100)
    readonly property var sinks: Pipewire.nodes.values.filter(n => n.isSink && !n.isStream && n.audio)

    // Input (source / microphone)
    readonly property var source: Pipewire.defaultAudioSource
    readonly property real sourceVolume: root.source && root.source.audio ? root.source.audio.volume : 0
    readonly property bool sourceMuted: root.source && root.source.audio ? root.source.audio.muted : false
    readonly property int sourceVolumePercent: Math.round(root.sourceVolume * 100)
    readonly property var sources: Pipewire.nodes.values.filter(n => !n.isSink && !n.isStream && n.audio && (n.type & PwNodeType.AudioSource) === PwNodeType.AudioSource)

    PwObjectTracker {
        objects: root.sinks.concat(root.sources)
    }

    function isDefaultSink(node) {
        return !!(node && root.sink && node.id === root.sink.id);
    }

    function isDefaultSource(node) {
        return !!(node && root.source && node.id === root.source.id);
    }

    function setDefaultSink(node) {
        if (node)
            Pipewire.preferredDefaultAudioSink = node;
    }

    function setDefaultSource(node) {
        if (node)
            Pipewire.preferredDefaultAudioSource = node;
    }

    function volumePercentFor(node) {
        return node && node.audio ? Math.round(node.audio.volume * 100) : 0;
    }

    function setVolume(value) {
        if (!root.sink || !root.sink.audio)
            return;
        root.sink.audio.volume = Math.max(0, Math.min(root.maxVolume, value));
    }

    function setSourceVolume(value) {
        if (!root.source || !root.source.audio)
            return;
        root.source.audio.volume = Math.max(0, Math.min(root.maxVolume, value));
    }

    function setVolumeFor(node, value) {
        if (!node || !node.audio)
            return;
        node.audio.volume = Math.max(0, Math.min(root.maxVolume, value));
    }

    function increase() {
        root.setVolume(root.volume + root.step);
    }

    function decrease() {
        root.setVolume(root.volume - root.step);
    }

    function increaseSource() {
        root.setSourceVolume(root.sourceVolume + root.step);
    }

    function decreaseSource() {
        root.setSourceVolume(root.sourceVolume - root.step);
    }

    function toggleMute() {
        if (root.sink && root.sink.audio)
            root.sink.audio.muted = !root.sink.audio.muted;
    }

    function toggleMuteSource() {
        if (root.source && root.source.audio)
            root.source.audio.muted = !root.source.audio.muted;
    }

    function toggleMuteFor(node) {
        if (node && node.audio)
            node.audio.muted = !node.audio.muted;
    }
}
