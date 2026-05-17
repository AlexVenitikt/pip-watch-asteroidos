import QtQuick 2.6
import "logic/pipboyFormatter.js" as Fmt
import "ui"
import "logic"
import "settings"

Item {
    id: root
    width: 480
    height: 480
    clip: true

    property bool ambientMode: false
    property var now: new Date()
    property color fg: "#00ff44"
    property color dim: "#0a7d2c"
    property color bg: "#031107"
    property color accent: "#7aff9e"
    property real u: height

    PipboySettings { id: cfg }
    PipboyDataBridge { id: bridge; ambientMode: root.ambientMode }

    Timer {
        interval: root.ambientMode ? 60000 : (cfg.showSeconds ? 1000 : 15000)
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Rectangle { anchors.fill: parent; color: bg }

    Rectangle {
        anchors.centerIn: parent
        width: parent.width - u * 0.04
        height: width
        radius: width / 2
        color: "transparent"
        border.width: 2
        border.color: dim
    }

    Item {
        id: stage
        anchors.centerIn: parent
        width: parent.width - u * 0.14
        height: width

        property real gap: u * 0.01
        property real leftW: width * 0.57
        property real rightW: width * 0.40
        property real headH: u * 0.06
        property real dateH: u * 0.11
        property real dataH: u * 0.11
        property real timeH: u * 0.225

        Rectangle {
            id: logoBox
            width: stage.leftW * 0.5
            height: stage.headH
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            color: "transparent"
            border.width: 2
            border.color: fg
            Image {
                anchors.fill: parent
                anchors.margins: 3
                fillMode: Image.PreserveAspectFit
                smooth: true
                source: Qt.resolvedUrl("assets/logos/Vault-Tec.png")
            }
        }

        Rectangle {
            id: dateBox
            anchors.top: logoBox.bottom
            anchors.topMargin: stage.gap
            anchors.left: parent.left
            width: stage.leftW
            height: stage.dateH
            color: "transparent"
            border.width: 2
            border.color: fg
            Text { x: 8; y: 4; color: fg; font.pixelSize: u * 0.038; font.bold: true; text: Fmt.two(now.getDate()) + "  " + Qt.formatDate(now, "MMM").toUpperCase() + "  " + now.getFullYear() }
            Text { x: 8; y: height - u * 0.04; color: accent; font.pixelSize: u * 0.026; font.bold: true; text: "WD " + Qt.formatDate(now, "ddd").toUpperCase() + "  w " + Fmt.weekOfYear(now) + "  d " + Fmt.dayOfYear(now) }
        }

        Rectangle {
            id: dataBox
            anchors.top: dateBox.bottom
            anchors.topMargin: stage.gap
            anchors.left: parent.left
            width: stage.leftW
            height: stage.dataH
            color: "transparent"
            border.width: 2
            border.color: fg
            Text { x: 8; y: 4; color: fg; font.pixelSize: u * 0.04; font.bold: true; text: "DATA    MAP" }
            Text { x: 14; y: u * 0.045; color: fg; font.pixelSize: u * 0.06; font.bold: true; text: bridge.stepsValid ? Math.min(99, Math.floor(bridge.steps / 100)).toString() : "0" }
            Image {
                x: width - u * 0.08
                y: u * 0.05
                width: u * 0.05
                height: u * 0.05
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("assets/map-icons/Vault.png")
            }
        }

        Rectangle {
            id: timeBox
            anchors.top: dataBox.bottom
            anchors.topMargin: stage.gap
            anchors.left: parent.left
            width: stage.leftW
            height: stage.timeH
            color: "transparent"
            border.width: 2
            border.color: fg
            Text { x: 8; y: 4; color: fg; font.pixelSize: u * 0.028; text: bridge.timezoneAbbr + "   " + (bridge.alarmEnabled ? bridge.nextAlarm : "--:--") }
            Text { x: 8; y: u * 0.05; color: fg; font.pixelSize: u * 0.11; font.bold: true; text: Fmt.time24(now, !ambientMode && cfg.showSeconds) }
            Image { x: 8; y: height - u * 0.05; width: u * 0.04; height: u * 0.04; fillMode: Image.PreserveAspectFit; source: Qt.resolvedUrl("assets/other-icons/Radio.png") }
            Text { x: u * 0.05; y: height - u * 0.05; color: accent; font.pixelSize: u * 0.038; font.bold: true; text: "App shortcut" }
        }

        Item {
            id: rightCol
            anchors.top: dateBox.top
            anchors.left: dateBox.right
            anchors.leftMargin: stage.gap
            width: stage.rightW
            height: timeBox.y + timeBox.height - y

            Text { x: 0; y: 0; color: fg; font.pixelSize: u * 0.052; font.bold: true; text: "CORE" }
            Text { x: width - u * 0.12; y: 0; color: fg; font.pixelSize: u * 0.052; font.bold: true; text: bridge.batteryPercent + "%" }
            Text { x: 0; y: u * 0.045; color: dim; font.pixelSize: u * 0.035; text: "Temp " + bridge.currentTempC + " C*" }
            Image {
                x: width - u * 0.055
                y: u * 0.045
                width: u * 0.04
                height: u * 0.04
                fillMode: Image.PreserveAspectFit
                source: bridge.charging ? Qt.resolvedUrl("assets/other-icons/Charge On.png") : Qt.resolvedUrl("assets/other-icons/Charge Off.png")
            }

            PipboyCharacter {
                x: 0
                y: u * 0.10
                width: u * 0.14
                height: u * 0.18
                fg: root.fg
                ambientMode: root.ambientMode || cfg.simplifiedMode
                state: bridge.steps > 3000 ? "walking" : "resting"
                visible: !cfg.simplifiedMode
            }

            Text { x: u * 0.15; y: u * 0.10; color: fg; font.pixelSize: u * 0.07; font.bold: true; text: "STAT" }
            Text { x: u * 0.15; y: u * 0.16; color: fg; font.pixelSize: u * 0.03; text: bridge.weatherValid ? bridge.weatherCondition : "NO DATA" }
            Text { x: u * 0.15; y: u * 0.20; color: accent; font.pixelSize: u * 0.03; text: "PPT " + bridge.precipitationPercent + "%" }
            Text { x: u * 0.15; y: u * 0.235; color: accent; font.pixelSize: u * 0.03; text: bridge.currentTempC + "F" }
            Text { x: u * 0.15; y: u * 0.27; color: accent; font.pixelSize: u * 0.03; text: "+" + bridge.uvIndex }

            Text { x: 0; y: u * 0.30; color: fg; font.pixelSize: u * 0.065; font.bold: true; text: "HP" }
            Text { x: width - u * 0.06; y: u * 0.30; color: fg; font.pixelSize: u * 0.065; font.bold: true; text: bridge.heartRateValid ? bridge.heartRate : 0 }
            PipboySegmentBar {
                x: 0
                y: u * 0.36
                width: rightCol.width
                height: u * 0.016
                value: bridge.heartRateValid ? bridge.heartRate : 0
                maximum: 200
                activeColor: fg
                passiveColor: dim
            }
            Text { x: 0; y: u * 0.375; color: fg; font.pixelSize: u * 0.06; font.bold: true; text: "RAD 0" }
        }

        Text {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            color: fg
            font.pixelSize: u * 0.06
            font.bold: true
            text: "AP: " + bridge.batteryPercent + "/" + bridge.batteryPercent
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            color: accent
            font.pixelSize: u * 0.023
            text: "PIP v6.0_CLASSIC  en_US"
        }
    }

    PipboyScanlines {
        anchors.fill: parent
        enabledFx: !ambientMode && !cfg.simplifiedMode
    }
}
