import QtQuick 2.6

Item {
    id: root
    visible: false

    property int heartRate: -1
    property bool heartRateValid: heartRate > 0
    property int steps: -1
    property bool stepsValid: steps >= 0
    property string sourcePath: "file:///tmp/pipboy-telemetry.qml"

    function refresh() {
        snapshotLoader.source = ""
        snapshotLoader.source = root.sourcePath + "?t=" + Date.now()
    }

    Loader {
        id: snapshotLoader
        asynchronous: false

        onLoaded: {
            var nextHeartRate = item ? Number(item.heartRate) : -1
            var nextSteps = item ? Number(item.steps) : -1
            root.heartRate = nextHeartRate > 0 && nextHeartRate < 260 ? Math.round(nextHeartRate) : -1
            root.steps = nextSteps >= 0 ? Math.round(nextSteps) : -1
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
