import QtQuick 2.6
import QtSensors 5.0

Item {
    id: root
    visible: false

    property int heartRate: -1
    property bool valid: heartRate > 0

    HrmSensor {
        active: true

        onReadingChanged: {
            if (reading && reading.bpm > 0) {
                root.heartRate = reading.bpm
            }
        }
    }
}
