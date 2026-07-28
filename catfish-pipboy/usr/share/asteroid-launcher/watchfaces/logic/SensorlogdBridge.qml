import QtQuick 2.6
import org.asteroid.sensorlogd 1.0

Item {
    id: root
    visible: false

    property int steps: stepsLoader.todayTotal
    property bool stepsValid: steps >= 0
    property int heartRate: -1
    property bool heartRateValid: heartRate > 0

    function refreshHeartRate() {
        var points = hrLoader.getTodayData()
        if (!points || points.length === 0) {
            return
        }

        var last = points[points.length - 1]
        if (last && last.y > 0) {
            root.heartRate = Math.round(last.y)
        }
    }

    LoggerSettings {
        id: logSettings
        stepCounterEnabled: true
        heartrateSensorEnabled: true
    }

    StepsDataLoader {
        id: stepsLoader
        onTodayTotalChanged: root.steps = todayTotal
        onDataChanged: root.steps = getTodayTotal()
    }

    HrDataLoader {
        id: hrLoader
        onDataChanged: root.refreshHeartRate()
    }

    Timer {
        interval: 60000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            root.steps = stepsLoader.getTodayTotal()
            root.refreshHeartRate()
        }
    }

    Component.onCompleted: {
        stepsLoader.triggerDaemonRecording()
        hrLoader.triggerDaemonRecording()
        logSettings.reInitLogger()
    }
}
