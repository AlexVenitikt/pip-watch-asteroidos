import QtQuick 2.6

Item {
    id: root

    property color fg: "#79ff66"
    property color dim: "#245f2c"
    property bool ambientMode: false
    property string state: "resting"

    width: 88
    height: 118

    Item {
        id: body
        anchors.fill: parent
        transformOrigin: Item.Center

        Rectangle {
            id: head
            x: root.width * 0.34
            y: root.height * 0.05
            width: root.width * 0.31
            height: root.width * 0.31
            radius: width / 2
            color: "transparent"
            border.width: Math.max(2, root.width * 0.025)
            border.color: root.fg
        }

        Repeater {
            model: 5
            Rectangle {
                x: root.width * (0.30 + index * 0.055)
                y: root.height * (index % 2 === 0 ? 0.025 : 0.005)
                width: root.width * 0.10
                height: root.width * 0.10
                radius: width / 2
                color: root.fg
                rotation: -12 + index * 6
            }
        }

        Rectangle {
            x: root.width * 0.42
            y: root.height * 0.15
            width: root.width * 0.035
            height: root.width * 0.06
            radius: width / 2
            color: root.fg
        }

        Rectangle {
            x: root.width * 0.55
            y: root.height * 0.15
            width: root.width * 0.035
            height: root.width * 0.06
            radius: width / 2
            color: root.fg
        }

        Rectangle {
            x: root.width * 0.45
            y: root.height * 0.235
            width: root.width * 0.14
            height: Math.max(2, root.height * 0.018)
            radius: height / 2
            color: root.fg
            rotation: -5
        }

        Rectangle {
            x: root.width * 0.30
            y: root.height * 0.33
            width: root.width * 0.40
            height: root.height * 0.30
            radius: root.width * 0.05
            color: "transparent"
            border.width: Math.max(2, root.width * 0.022)
            border.color: root.fg
        }

        Rectangle {
            x: root.width * 0.47
            y: root.height * 0.34
            width: root.width * 0.055
            height: root.height * 0.28
            color: root.fg
            opacity: 0.85
        }

        Rectangle {
            x: root.width * 0.28
            y: root.height * 0.55
            width: root.width * 0.45
            height: Math.max(2, root.height * 0.035)
            radius: height / 2
            color: root.fg
        }

        Rectangle {
            id: armL
            x: root.width * 0.18
            y: root.height * 0.38
            width: root.width * 0.22
            height: root.height * 0.06
            radius: height / 2
            color: root.fg
            transformOrigin: Item.Right
            rotation: 18
        }

        Rectangle {
            id: armR
            x: root.width * 0.64
            y: root.height * 0.38
            width: root.width * 0.22
            height: root.height * 0.06
            radius: height / 2
            color: root.fg
            transformOrigin: Item.Left
            rotation: -18
        }

        Rectangle {
            x: root.width * 0.15
            y: root.height * 0.43
            width: root.width * 0.08
            height: root.width * 0.08
            radius: width / 2
            color: root.fg
        }

        Rectangle {
            x: root.width * 0.78
            y: root.height * 0.43
            width: root.width * 0.08
            height: root.width * 0.08
            radius: width / 2
            color: root.fg
        }

        Rectangle {
            id: legL
            x: root.width * 0.34
            y: root.height * 0.62
            width: root.width * 0.11
            height: root.height * 0.27
            radius: width / 2
            color: root.fg
            transformOrigin: Item.Top
            rotation: -18
        }

        Rectangle {
            id: legR
            x: root.width * 0.55
            y: root.height * 0.62
            width: root.width * 0.11
            height: root.height * 0.27
            radius: width / 2
            color: root.fg
            transformOrigin: Item.Top
            rotation: 18
        }

        Rectangle {
            id: footL
            x: root.width * 0.22
            y: root.height * 0.86
            width: root.width * 0.24
            height: root.height * 0.07
            radius: height / 2
            color: root.fg
            rotation: -10
        }

        Rectangle {
            id: footR
            x: root.width * 0.57
            y: root.height * 0.86
            width: root.width * 0.24
            height: root.height * 0.07
            radius: height / 2
            color: root.fg
            rotation: 10
        }
    }

    SequentialAnimation {
        running: !root.ambientMode && root.state === "walking"
        loops: Animation.Infinite
        ParallelAnimation {
            NumberAnimation { target: body; property: "y"; to: -2; duration: 220 }
            NumberAnimation { target: armL; property: "rotation"; to: -18; duration: 220 }
            NumberAnimation { target: armR; property: "rotation"; to: 18; duration: 220 }
            NumberAnimation { target: legL; property: "rotation"; to: 18; duration: 220 }
            NumberAnimation { target: legR; property: "rotation"; to: -18; duration: 220 }
            NumberAnimation { target: footL; property: "rotation"; to: 10; duration: 220 }
            NumberAnimation { target: footR; property: "rotation"; to: -10; duration: 220 }
        }
        ParallelAnimation {
            NumberAnimation { target: body; property: "y"; to: 0; duration: 220 }
            NumberAnimation { target: armL; property: "rotation"; to: 18; duration: 220 }
            NumberAnimation { target: armR; property: "rotation"; to: -18; duration: 220 }
            NumberAnimation { target: legL; property: "rotation"; to: -18; duration: 220 }
            NumberAnimation { target: legR; property: "rotation"; to: 18; duration: 220 }
            NumberAnimation { target: footL; property: "rotation"; to: -10; duration: 220 }
            NumberAnimation { target: footR; property: "rotation"; to: 10; duration: 220 }
        }
    }
}
