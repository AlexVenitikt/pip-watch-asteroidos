import QtQuick 2.6

Item {
    id: root
    property real value: 0
    property real maximum: 100
    property int segments: 12
    property color activeColor: "#79ff66"
    property color passiveColor: "#244023"

    Repeater {
        model: root.segments
        Rectangle {
            width: (root.width - (root.segments - 1) * 2) / root.segments
            height: root.height
            x: index * (width + 2)
            radius: 1
            color: index < Math.round((root.value / Math.max(1, root.maximum)) * root.segments) ? root.activeColor : root.passiveColor
        }
    }
}
