import QtQuick 2.6

QtObject {
    property bool active: false
    property var reading: ({ "bpm": 0 })

    onActiveChanged: if (active) reading = ({ "bpm": 72 })
    Component.onCompleted: if (active) reading = ({ "bpm": 72 })
}
