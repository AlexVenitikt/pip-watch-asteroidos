import QtQuick 2.6
import Nemo.DBus 2.0

Item {
    id: root
    visible: false

    property int clientId: 424242
    property int heartRate: -1
    property bool valid: heartRate > 0

    function parseBpm(value, seen) {
        if (typeof value === "number") {
            return value > 0 && value < 260 ? Math.round(value) : -1
        }

        if (!value || value.length === undefined) {
            if (!value || typeof value !== "object") {
                return -1
            }

            if (!seen) {
                seen = []
            }
            if (seen.indexOf(value) >= 0) {
                return -1
            }
            seen.push(value)

            var bestObjectBpm = -1
            for (var key in value) {
                var objectParsed = parseBpm(value[key], seen)
                if (objectParsed >= 30 && objectParsed < 260) {
                    bestObjectBpm = objectParsed
                } else if (bestObjectBpm < 0 && objectParsed > 0) {
                    bestObjectBpm = objectParsed
                }
            }

            return bestObjectBpm
        }

        if (!seen) {
            seen = []
        }

        var bestArrayBpm = -1
        for (var i = value.length - 1; i >= 0; --i) {
            var parsed = parseBpm(value[i], seen)
            if (parsed >= 30 && parsed < 260) {
                return parsed
            }
            if (bestArrayBpm < 0 && parsed > 0) {
                bestArrayBpm = parsed
            }
        }

        return bestArrayBpm
    }

    function updateFromReading(value) {
        var bpm = parseBpm(value)
        if (bpm > 0) {
            root.heartRate = bpm
        }
    }

    function startSensor() {
        hrm.call("start", [root.clientId])
        pollTimer.restart()
    }

    function stopSensor() {
        pollTimer.stop()
        hrm.call("stop", [root.clientId])
    }

    DBusInterface {
        id: hrm

        bus: DBus.SystemBus
        service: "com.nokia.SensorService"
        path: "/SensorManager/hrmsensor"
        iface: "local.HrmSensor"
        signalsEnabled: true

        function heartRateChanged(reading) {
            root.updateFromReading(reading)
        }
    }

    Timer {
        id: pollTimer
        interval: 5000
        repeat: true
        running: false

        onTriggered: {
            root.updateFromReading(hrm.getProperty("heartRate"))
        }
    }

    Component.onCompleted: root.startSensor()
    Component.onDestruction: root.stopSensor()
}
