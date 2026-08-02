import QtQuick
import Quickshell
pragma Singleton

Singleton {
    id: root

    property bool open: false

    function toggle() {
        root.open = !root.open;
    }

    function close() {
        root.open = false;
    }
}
