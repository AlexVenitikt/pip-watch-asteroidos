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

    property int heartRate: heartRateValid ? hrmLoader.item.heartRate : -1
    property int steps: -1
    property bool heartRateValid: hrmLoader.status === Loader.Ready && hrmLoader.item.valid
    property bool stepsValid: false
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

    // Confirmed on catfish: Nemo.Mce provides battery level/state.
    // HR is optional because some images install asteroid-hrm but do not expose
    // HrmSensor to the launcher QML engine. Steps need sensorlogd/health.
}
