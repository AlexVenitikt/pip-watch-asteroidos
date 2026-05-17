import QtQuick 2.6

Item {
    id: root
    property color lineColor: "#19000000"
    property bool enabledFx: true

    visible: enabledFx
    Repeater {
        model: Math.floor(root.height / 3)
        Rectangle {
            width: root.width
            height: 1
            y: index * 3
            color: root.lineColor
        }
    }
}
