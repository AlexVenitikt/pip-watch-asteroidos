import QtQuick 2.6

Item {
    id: root
    property color fg: "#79ff66"
    property bool ambientMode: false
    property string state: "resting"

    width: 56
    height: 72

    Rectangle { x: 24; y: 4; width: 8; height: 8; radius: 4; color: root.fg }
    Rectangle { x: 22; y: 12; width: 12; height: 18; radius: 2; color: root.fg }
    Rectangle { id: armL; x: 14; y: 14; width: 8; height: 3; color: root.fg; transformOrigin: Item.Right }
    Rectangle { id: armR; x: 34; y: 14; width: 8; height: 3; color: root.fg; transformOrigin: Item.Left }
    Rectangle { id: legL; x: 22; y: 30; width: 4; height: 20; color: root.fg; transformOrigin: Item.Top }
    Rectangle { id: legR; x: 30; y: 30; width: 4; height: 20; color: root.fg; transformOrigin: Item.Top }

    SequentialAnimation on rotation {
        running: !root.ambientMode && root.state === "reading"
        loops: Animation.Infinite
        NumberAnimation { to: -3; duration: 450 }
        NumberAnimation { to: 3; duration: 450 }
    }

    SequentialAnimation {
        running: !root.ambientMode && root.state === "walking"
        loops: Animation.Infinite
        NumberAnimation { target: legL; property: "rotation"; to: 18; duration: 180 }
        NumberAnimation { target: legL; property: "rotation"; to: -18; duration: 180 }
        NumberAnimation { target: legR; property: "rotation"; to: 18; duration: 180 }
        NumberAnimation { target: legR; property: "rotation"; to: -18; duration: 180 }
    }
}
