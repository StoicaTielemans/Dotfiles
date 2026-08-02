import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    property bool connected: false
    property bool isWifi: false
    property string interfaceName: ""
    property string gateway: ""
    property string ipAddress: ""
    property string macAddress: ""
    property string mtu: ""
    property string linkSpeed: ""
    property string duplex: ""
    property var dnsServers: []

    property real rxRate: 0
    property real txRate: 0
    property real rxTotal: 0
    property real txTotal: 0

    readonly property string rxRateText: formatRate(rxRate)
    readonly property string txRateText: formatRate(txRate)
    readonly property string rxTotalText: formatBytes(rxTotal)
    readonly property string txTotalText: formatBytes(txTotal)

    readonly property string tooltip: buildTooltip()

    property real _prevRx: -1
    property real _prevTx: -1
    property real _prevSampleTime: -1

    function formatRate(bytesPerSec) {
        if (bytesPerSec >= 1024 * 1024)
            return (bytesPerSec / 1024 / 1024).toFixed(1) + " MB/s";
        if (bytesPerSec >= 1024)
            return (bytesPerSec / 1024).toFixed(1) + " KB/s";
        return bytesPerSec.toFixed(0) + " B/s";
    }

    function formatBytes(bytes) {
        if (bytes >= 1024 * 1024 * 1024)
            return (bytes / 1024 / 1024 / 1024).toFixed(2) + " GB";
        if (bytes >= 1024 * 1024)
            return (bytes / 1024 / 1024).toFixed(2) + " MB";
        if (bytes >= 1024)
            return (bytes / 1024).toFixed(2) + " KB";
        return bytes.toFixed(0) + " B";
    }

    function hexToIp(hex) {
        if (!hex || hex.length !== 8)
            return "";
        const b3 = parseInt(hex.substr(6, 2), 16);
        const b2 = parseInt(hex.substr(4, 2), 16);
        const b1 = parseInt(hex.substr(2, 2), 16);
        const b0 = parseInt(hex.substr(0, 2), 16);
        return b3 + "." + b2 + "." + b1 + "." + b0;
    }

    function buildTooltip() {
        if (!root.interfaceName)
            return "No active connection";

        const lines = ["INTERFACE: " + root.interfaceName + " (" + (root.isWifi ? "Wi-Fi" : "Ethernet") + ")", "STATUS: " + (root.connected ? "Up" : "Down"), "IP ADDRESS: " + (root.ipAddress || "-"), "GATEWAY: " + (root.gateway || "-"), "MAC ADDRESS: " + (root.macAddress || "-"), "MTU: " + (root.mtu || "-")];

        if (!root.isWifi)
            lines.push("LINK SPEED: " + (root.linkSpeed ? root.linkSpeed + " Mbps" : "-") + " (" + (root.duplex || "-") + " duplex)");

        lines.push("");
        lines.push("DOWN: " + root.rxRateText + "  |  UP: " + root.txRateText);
        lines.push("TOTAL RX: " + root.rxTotalText + "  |  TOTAL TX: " + root.txTotalText);

        if (root.dnsServers.length > 0) {
            lines.push("");
            lines.push("DNS:");
            for (const dns of root.dnsServers)
                lines.push(dns);
        }

        return lines.join("\n");
    }

    FileView {
        id: routeFile
        path: "/proc/net/route"
        blockAllReads: true
    }

    FileView {
        id: wirelessFile
        path: "/proc/net/wireless"
        blockAllReads: true
    }

    FileView {
        id: resolvFile
        path: "/etc/resolv.conf"
        blockAllReads: true
        printErrors: false
    }

    FileView {
        id: operstateFile
        path: root.interfaceName ? "/sys/class/net/" + root.interfaceName + "/operstate" : ""
        blockAllReads: true
        printErrors: false
    }

    FileView {
        id: rxBytesFile
        path: root.interfaceName ? "/sys/class/net/" + root.interfaceName + "/statistics/rx_bytes" : ""
        blockAllReads: true
        printErrors: false
    }

    FileView {
        id: txBytesFile
        path: root.interfaceName ? "/sys/class/net/" + root.interfaceName + "/statistics/tx_bytes" : ""
        blockAllReads: true
        printErrors: false
    }

    FileView {
        id: macFile
        path: root.interfaceName ? "/sys/class/net/" + root.interfaceName + "/address" : ""
        blockAllReads: true
        printErrors: false
    }

    FileView {
        id: mtuFile
        path: root.interfaceName ? "/sys/class/net/" + root.interfaceName + "/mtu" : ""
        blockAllReads: true
        printErrors: false
    }

    FileView {
        id: speedFile
        path: root.interfaceName ? "/sys/class/net/" + root.interfaceName + "/speed" : ""
        blockAllReads: true
        printErrors: false
    }

    FileView {
        id: duplexFile
        path: root.interfaceName ? "/sys/class/net/" + root.interfaceName + "/duplex" : ""
        blockAllReads: true
        printErrors: false
    }

    Process {
        id: ipAddrProc

        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const match = this.text.match(/inet (\d+\.\d+\.\d+\.\d+)/);
                root.ipAddress = match ? match[1] : "";
            }
        }
    }

    function findDefaultRoute() {
        routeFile.reload();
        const lines = routeFile.text().split("\n").slice(1);
        for (const line of lines) {
            const parts = line.trim().split(/\s+/);
            if (parts.length >= 3 && parts[1] === "00000000")
                return {
                    iface: parts[0],
                    gateway: root.hexToIp(parts[2])
                };
        }
        return null;
    }

    function poll() {
        const route = root.findDefaultRoute();
        const iface = route ? route.iface : "";
        const ifaceChanged = iface !== root.interfaceName;

        if (ifaceChanged) {
            root.interfaceName = iface;
            root._prevRx = -1;
            root._prevTx = -1;
        }

        if (!iface) {
            root.connected = false;
            root.isWifi = false;
            root.gateway = "";
            root.ipAddress = "";
            root.rxRate = 0;
            root.txRate = 0;
            return;
        }

        root.gateway = route.gateway;

        operstateFile.reload();
        root.connected = operstateFile.text().trim() === "up";

        wirelessFile.reload();
        root.isWifi = wirelessFile.text().split("\n").some(line => line.trim().startsWith(iface + ":"));

        macFile.reload();
        root.macAddress = macFile.text().trim();

        mtuFile.reload();
        root.mtu = mtuFile.text().trim();

        speedFile.reload();
        const speed = Number(speedFile.text().trim());
        root.linkSpeed = speed > 0 ? String(speed) : "";

        duplexFile.reload();
        root.duplex = duplexFile.text().trim();

        resolvFile.reload();
        root.dnsServers = resolvFile.text().split("\n").filter(line => line.trim().startsWith("nameserver")).map(line => line.trim().split(/\s+/)[1]);

        // The IP rarely changes once assigned, so only re-run this on an
        // actual interface change instead of every poll tick.
        if (ifaceChanged) {
            ipAddrProc.command = ["ip", "-4", "addr", "show", "dev", iface];
            ipAddrProc.running = true;
        }

        rxBytesFile.reload();
        txBytesFile.reload();
        const rx = Number(rxBytesFile.text().trim());
        const tx = Number(txBytesFile.text().trim());
        const now = Date.now();

        if (root._prevRx >= 0 && root._prevSampleTime > 0) {
            const elapsed = (now - root._prevSampleTime) / 1000;
            if (elapsed > 0) {
                root.rxRate = Math.max(0, (rx - root._prevRx) / elapsed);
                root.txRate = Math.max(0, (tx - root._prevTx) / elapsed);
            }
        }

        root.rxTotal = rx;
        root.txTotal = tx;
        root._prevRx = rx;
        root._prevTx = tx;
        root._prevSampleTime = now;
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.poll()
    }
}
