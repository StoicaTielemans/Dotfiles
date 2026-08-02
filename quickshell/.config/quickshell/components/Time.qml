import QtQuick
import Quickshell
// with this line our type becomes a Singleton
pragma Singleton

// your singletons should always have Singleton as the type
Singleton {
    id: root

    property string time: formatTime()

    function pad(n) {
        return n < 10 ? "0" + n : String(n);
    }

    function formatTime() {
        const now = new Date();
        const dd = pad(now.getDate());
        const mm = pad(now.getMonth() + 1);
        const yy = pad(now.getFullYear() % 100);
        const hh = pad(now.getHours());
        const mi = pad(now.getMinutes());
        const ss = pad(now.getSeconds());
        return "  " + dd + "/" + mm + "/" + yy + "    " + hh + ":" + mi + ":" + ss;
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.time = root.formatTime()
    }
}
