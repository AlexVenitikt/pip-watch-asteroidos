import QtQuick 2.6

QtObject {
    id: root

    property bool ambientMode: false
    property bool bluetoothConnected: true
    property bool charging: false
    property int batteryPercent: 76
    property real batteryTempC: -1
    property bool lowBattery: batteryPercent <= 15

    property int heartRate: 72
    property int steps: 3456
    property bool heartRateValid: true
    property bool stepsValid: true

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

    // In AsteroidOS this bridge is intentionally thin; values can be wired from
    // environment/context providers when available, otherwise fallback data keeps UI stable.
}
