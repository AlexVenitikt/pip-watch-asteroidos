import QtQuick 2.6
import Nemo.Mce 1.0

Item {
    id: root
    visible: false

    property bool ambientMode: false
    property bool bluetoothConnected: false
    property bool batteryAvailable: batteryLevel.percent >= 0
    property bool charging: batteryState.state === "charging"
    property int batteryPercent: batteryAvailable ? Math.max(0, Math.min(100, batteryLevel.percent)) : -1
    property string batteryText: batteryAvailable ? batteryPercent + "%" : "--"
    property real batteryTempC: -1
    property bool lowBattery: batteryAvailable && batteryPercent <= 15

    property bool sensorlogdReady: sensorlogdLoader.status === Loader.Ready
    property bool liveHrmReady: hrmLoader.status === Loader.Ready && hrmLoader.item.valid
    property int heartRate: heartRateValid ? (sensorlogdLoader.item.heartRateValid ? sensorlogdLoader.item.heartRate : hrmLoader.item.heartRate) : -1
    property int steps: stepsValid ? sensorlogdLoader.item.steps : -1
    property bool heartRateValid: (sensorlogdReady && sensorlogdLoader.item.heartRateValid) || liveHrmReady
    property bool stepsValid: sensorlogdReady && sensorlogdLoader.item.stepsValid
    property string heartRateText: heartRateValid ? heartRate : "--"
    property string stepsText: stepsValid ? steps : "--"

    property string weatherCondition: "Clear"
    property string weatherIcon: "CLR"
    property real currentTempC: 19
    property int precipitationPercent: 5
    property int uvIndex: 2
    property string sunrise: "06:01"
    property string sunset: "20:47"
    property bool weatherValid: false
    property string timezoneAbbr: "UTC"
    property bool alarmEnabled: false
    property string nextAlarm: "--:--"

    MceBatteryLevel {
        id: batteryLevel
    }

    MceBatteryState {
        id: batteryState
    }

    Loader {
        id: hrmLoader
        active: !root.ambientMode
        source: Qt.resolvedUrl("HrmSensorBridge.qml")
    }

    Loader {
        id: sensorlogdLoader
        active: true
        source: Qt.resolvedUrl("SensorlogdBridge.qml")
    }

    // Confirmed on catfish: Nemo.Mce provides battery level/state.
    // Sensorlogd is optional at load time so removing its package does not
    // break the watchface. Direct HrmSensor remains a fallback for other images.
}
