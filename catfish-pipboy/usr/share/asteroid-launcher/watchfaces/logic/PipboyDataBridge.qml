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

    property bool enableSensorlogd: false
    property bool enableQtSensorsHrm: false
    property bool enableNemoDbusHrm: false
    property bool telemetryReady: telemetryLoader.status === Loader.Ready
    property bool sensorlogdReady: sensorlogdLoader.status === Loader.Ready
    property bool hrmDbusReady: hrmDbusLoader.status === Loader.Ready && hrmDbusLoader.item.valid
    property bool liveHrmReady: hrmLoader.status === Loader.Ready && hrmLoader.item.valid
    property int heartRate: telemetryReady && telemetryLoader.item.heartRateValid
                            ? telemetryLoader.item.heartRate
                            : sensorlogdReady && sensorlogdLoader.item.heartRateValid
                            ? sensorlogdLoader.item.heartRate
                            : hrmDbusReady
                              ? hrmDbusLoader.item.heartRate
                              : liveHrmReady
                                ? hrmLoader.item.heartRate
                                : -1
    property int steps: stepsValid
                        ? telemetryReady && telemetryLoader.item.stepsValid
                          ? telemetryLoader.item.steps
                          : sensorlogdLoader.item.steps
                        : -1
    property bool heartRateValid: heartRate > 0
    property bool stepsValid: telemetryReady && telemetryLoader.item.stepsValid
                              || sensorlogdReady && sensorlogdLoader.item.stepsValid
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
        id: telemetryLoader
        active: true
        source: Qt.resolvedUrl("TelemetryFileBridge.qml")
    }

    Loader {
        id: hrmLoader
        active: root.enableQtSensorsHrm && !root.ambientMode
        source: Qt.resolvedUrl("HrmSensorBridge.qml")
    }

    Loader {
        id: hrmDbusLoader
        active: root.enableNemoDbusHrm && !root.ambientMode
        source: Qt.resolvedUrl("HrmDbusBridge.qml")
    }

    Loader {
        id: sensorlogdLoader
        active: root.enableSensorlogd
        source: Qt.resolvedUrl("SensorlogdBridge.qml")
    }

    // Confirmed on catfish: Nemo.Mce provides battery level/state.
    // Sensorlogd is disabled by default because current Qt6 catfish images do
    // not ship it. QtSensors HrmSensor is disabled by default because sensorfw
    // logs DBus marshalling warnings on catfish; direct SensorService DBus is
    // the primary HR path.
}
