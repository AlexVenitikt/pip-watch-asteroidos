import QtQuick 2.6

QtObject {
    property int todayTotal: 0

    signal dataChanged()

    function getTodayTotal() {
        return todayTotal
    }

    function triggerDaemonRecording() {
    }
}
