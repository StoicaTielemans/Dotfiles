import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    property real cpuPercent: 0
    property int cpuTemp: 0
    property real cpuFreqGhz: 0
    property string loadAvg: ""
    property var coreUsages: []

    property int gpuPercent: 0
    property int gpuMemPercent: 0
    property int gpuTemp: 0
    property int gpuMemUsedMb: 0
    property int gpuMemTotalMb: 0
    property int gpuFanPercent: 0
    property real gpuPowerW: 0
    property string gpuPstate: ""

    property int memPercent: 0
    property real memUsedGb: 0
    property real memTotalGb: 0
    property real memFreeGb: 0
    property real swapUsedGb: 0
    property real swapTotalGb: 0
    property int swapPercent: 0

    property var _prevCores: ({})

    readonly property string stats: "CPU: %1% %2°C | GPU: %3% %4°C | MEM: %5% %6 GB".arg(cpuPercent.toFixed(1)).arg(cpuTemp).arg(gpuPercent).arg(gpuTemp).arg(memPercent).arg(memUsedGb.toFixed(2))

    readonly property string tooltip: buildTooltip()

    FileView {
        id: statFile
        path: "/proc/stat"
        blockAllReads: true
    }

    FileView {
        id: meminfoFile
        path: "/proc/meminfo"
        blockAllReads: true
    }

    FileView {
        id: thermalFile
        path: "/sys/class/thermal/thermal_zone1/temp"
        blockAllReads: true
    }

    FileView {
        id: cpuinfoFile
        path: "/proc/cpuinfo"
        blockAllReads: true
    }

    FileView {
        id: loadavgFile
        path: "/proc/loadavg"
        blockAllReads: true
    }

    Process {
        id: gpuProc

        command: ["nvidia-smi", "--query-gpu=utilization.gpu,utilization.memory,temperature.gpu,memory.used,memory.total,fan.speed,power.draw,pstate", "--format=csv,noheader,nounits"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split(",").map(s => s.trim());
                root.gpuPercent = Number(parts[0]);
                root.gpuMemPercent = Number(parts[1]);
                root.gpuTemp = Number(parts[2]);
                root.gpuMemUsedMb = Number(parts[3]);
                root.gpuMemTotalMb = Number(parts[4]);
                root.gpuFanPercent = Number(parts[5]);
                root.gpuPowerW = Number(parts[6]);
                root.gpuPstate = parts[7];
            }
        }
    }

    function percentFromJiffies(idleDelta, totalDelta) {
        return totalDelta > 0 ? Math.round((totalDelta - idleDelta) / totalDelta * 1000) / 10 : 0;
    }

    function pollCpu() {
        statFile.reload();
        const lines = statFile.text().split("\n").filter(l => l.startsWith("cpu"));
        const cores = [];

        for (const line of lines) {
            const parts = line.trim().split(/\s+/);
            const id = parts[0];
            const fields = parts.slice(1).map(Number);
            const idle = fields[3];
            const total = fields.reduce((a, b) => a + b, 0);

            const prev = root._prevCores[id];
            const percent = prev ? root.percentFromJiffies(idle - prev.idle, total - prev.total) : 0;
            root._prevCores[id] = {
                idle,
                total
            };

            if (id === "cpu") {
                root.cpuPercent = percent;
            } else {
                cores.push(percent);
            }
        }
        root.coreUsages = cores;

        thermalFile.reload();
        root.cpuTemp = Math.round(Number(thermalFile.text().trim()) / 1000);

        cpuinfoFile.reload();
        const mhzRegex = /cpu MHz\s*:\s*([\d.]+)/g;
        const mhz = [];
        let match;
        while ((match = mhzRegex.exec(cpuinfoFile.text())) !== null)
            mhz.push(Number(match[1]));
        root.cpuFreqGhz = mhz.length ? mhz.reduce((a, b) => a + b, 0) / mhz.length / 1000 : 0;

        loadavgFile.reload();
        root.loadAvg = loadavgFile.text().trim().split(/\s+/).slice(0, 3).join(" ");
    }

    function pollMem() {
        meminfoFile.reload();
        const memText = meminfoFile.text();
        const memTotalKb = Number(memText.match(/MemTotal:\s+(\d+)/)[1]);
        const memAvailableKb = Number(memText.match(/MemAvailable:\s+(\d+)/)[1]);
        const memUsedKb = memTotalKb - memAvailableKb;

        root.memPercent = Math.round(100 * memUsedKb / memTotalKb);
        root.memUsedGb = memUsedKb / 1024 / 1024;
        root.memTotalGb = memTotalKb / 1024 / 1024;
        root.memFreeGb = memAvailableKb / 1024 / 1024;

        const swapTotalKb = Number(memText.match(/SwapTotal:\s+(\d+)/)[1]);
        const swapFreeKb = Number(memText.match(/SwapFree:\s+(\d+)/)[1]);
        const swapUsedKb = swapTotalKb - swapFreeKb;

        root.swapTotalGb = swapTotalKb / 1024 / 1024;
        root.swapUsedGb = swapUsedKb / 1024 / 1024;
        root.swapPercent = swapTotalKb > 0 ? Math.round(100 * swapUsedKb / swapTotalKb) : 0;
    }

    function formatCoreLines() {
        let text = "";
        for (let i = 0; i < root.coreUsages.length; i++) {
            text += i + ": " + root.coreUsages[i].toFixed(1) + "%  ";
            if ((i + 1) % 4 === 0)
                text += "\n";
        }
        return text;
    }

    function buildTooltip() {
        return "CPU: " + root.cpuPercent.toFixed(1) + "% @ " + root.cpuFreqGhz.toFixed(2) + "GHz (" + root.coreUsages.length + " cores)\n" + "TEMP: " + root.cpuTemp + "°C\n" + "LOAD AVG: " + root.loadAvg + "\n\n" + "CPU CORES:\n" + root.formatCoreLines() + "\n\n" + "GPU (NVIDIA):\n" + "UTIL: " + root.gpuPercent + "% | MEM: " + root.gpuMemPercent + "%\n" + "TEMP: " + root.gpuTemp + "°C\n" + "VRAM: " + root.gpuMemUsedMb + "/" + root.gpuMemTotalMb + " MiB\n" + "POWER: " + root.gpuPowerW.toFixed(2) + "W | FAN: " + root.gpuFanPercent + "%\n" + "PSTATE: " + root.gpuPstate + "\n\n" + "MEM USED: " + root.memUsedGb.toFixed(2) + "/" + root.memTotalGb.toFixed(2) + " GB (" + root.memPercent + "%)\n" + "FREE: " + root.memFreeGb.toFixed(2) + " GB\n" + "SWAP: " + root.swapUsedGb.toFixed(2) + "/" + root.swapTotalGb.toFixed(2) + " GB (" + root.swapPercent + "%)";
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.pollCpu();
            root.pollMem();
            gpuProc.running = true;
        }
    }
}
