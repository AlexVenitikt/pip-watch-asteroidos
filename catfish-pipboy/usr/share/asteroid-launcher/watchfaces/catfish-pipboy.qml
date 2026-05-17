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
    property int burninOffsetX: ambientMode ? ((now.getMinutes() % 3) - 1) : 0
    property int burninOffsetY: ambientMode ? ((now.getSeconds() % 3) - 1) : 0

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
        width: parent.width - 20
        height: width
        radius: width / 2
        color: "transparent"
        border.width: 2
        border.color: dim
    }

    Item {
        id: stage
        anchors.centerIn: parent
        width: parent.width - 44
        height: width
        x: burninOffsetX
        y: burninOffsetY

        readonly property real gap: 6
        readonly property real leftW: width * 0.52
        readonly property real rightW: width * 0.44
        readonly property real topH: 32
        readonly property real y1: topH + gap
        readonly property real hDate: 56
        readonly property real hDataMap: 56
        readonly property real hTime: 126

        Rectangle {
            x: width * 0.36; y: 0
            width: width * 0.28; height: stage.topH
            color: "transparent"; border.width: 2; border.color: fg
            Text { anchors.centerIn: parent; color: fg; font.pixelSize: 16; font.bold: true; text: "VAULT-TEC" }
        }

        Rectangle {
            x: 0; y: stage.y1; width: stage.leftW; height: stage.hDate
            color: "transparent"; border.width: 2; border.color: fg
            Text { x: 8; y: 4; color: fg; font.pixelSize: 18; font.bold: true; text: Fmt.two(now.getDate()) + "  " + Qt.formatDate(now, "MMM").toUpperCase() + "  " + now.getFullYear() }
            Text { x: 8; y: 30; color: accent; font.pixelSize: 14; font.bold: true; text: "WD " + Qt.formatDate(now, "ddd").toUpperCase() + "  w " + Fmt.weekOfYear(now) + "  d " + Fmt.dayOfYear(now) }
        }

        Rectangle {
            x: 0; y: stage.y1 + stage.hDate + stage.gap; width: stage.leftW; height: stage.hDataMap
            color: "transparent"; border.width: 2; border.color: fg
            Text { x: 8; y: 4; color: fg; font.pixelSize: 18; font.bold: true; text: "DATA    MAP" }
            Text { x: 20; y: 24; color: fg; font.pixelSize: 30; font.bold: true; text: bridge.stepsValid ? Math.min(99, Math.floor(bridge.steps / 100)).toString() : "0" }
            Text { x: 118; y: 24; color: fg; font.pixelSize: 24; font.bold: true; text: "<>" }
        }

        Rectangle {
            x: 0; y: stage.y1 + stage.hDate + stage.gap + stage.hDataMap + stage.gap; width: stage.leftW; height: stage.hTime
            color: "transparent"; border.width: 2; border.color: fg
            Text { x: 8; y: 4; color: fg; font.pixelSize: 14; text: bridge.timezoneAbbr + "   " + (bridge.alarmEnabled ? bridge.nextAlarm : "--:--") }
            Text { x: 8; y: 24; color: fg; font.pixelSize: 52; font.bold: true; text: Fmt.time24(now, !ambientMode && cfg.showSeconds) }
            Text { x: 8; y: 92; color: accent; font.pixelSize: 20; font.bold: true; text: "App shortcut" }
        }

        Item {
            x: stage.leftW + stage.gap
            y: stage.y1
            width: stage.rightW
            height: stage.hDate + stage.gap + stage.hDataMap + stage.gap + stage.hTime

            Text { x: 0; y: 0; color: fg; font.pixelSize: 32; font.bold: true; text: "CORE" }
            Text { x: width - 84; y: 0; color: fg; font.pixelSize: 34; font.bold: true; text: bridge.batteryPercent + "%" }
            Text { x: 0; y: 32; color: dim; font.pixelSize: 18; text: "Temp " + bridge.currentTempC + " C*" }

            PipboyCharacter {
                x: 10; y: 58
                width: 92; height: 118
                fg: root.fg
                ambientMode: root.ambientMode || cfg.simplifiedMode
                state: bridge.steps > 3000 ? "walking" : "resting"
                visible: !cfg.simplifiedMode
            }

            Text { x: 108; y: 64; color: fg; font.pixelSize: 36; font.bold: true; text: "STAT" }
            Text { x: 108; y: 98; color: fg; font.pixelSize: 18; text: bridge.weatherValid ? bridge.weatherCondition : "NO DATA" }
            Text { x: 108; y: 122; color: accent; font.pixelSize: 16; text: "PPT " + bridge.precipitationPercent + "%" }
            Text { x: 108; y: 142; color: accent; font.pixelSize: 16; text: bridge.currentTempC + "F" }
            Text { x: 108; y: 162; color: accent; font.pixelSize: 16; text: "+" + bridge.uvIndex }

            Text { x: 0; y: 182; color: fg; font.pixelSize: 32; font.bold: true; text: "HP"; }
            Text { x: width - 36; y: 182; color: fg; font.pixelSize: 32; font.bold: true; text: bridge.heartRateValid ? bridge.heartRate : 0; }
            PipboySegmentBar {
                x: 0; y: 216
                width: parent.width; height: 8
                value: bridge.heartRateValid ? bridge.heartRate : 0
                maximum: 200
                activeColor: fg
                passiveColor: dim
            }
            Text { x: 0; y: 228; color: fg; font.pixelSize: 30; font.bold: true; text: "RAD 0"; }
        }

        Text { x: 0; y: stage.height - 40; color: fg; font.pixelSize: 36; font.bold: true; text: "AP: " + bridge.batteryPercent + "/" + bridge.batteryPercent }
        Text { x: stage.width * 0.34; y: stage.height - 14; color: accent; font.pixelSize: 12; text: "PIP v6.0_CLASSIC  en_US" }
    }

    PipboyScanlines {
        anchors.fill: parent
        enabledFx: !ambientMode && !cfg.simplifiedMode
    }
}
