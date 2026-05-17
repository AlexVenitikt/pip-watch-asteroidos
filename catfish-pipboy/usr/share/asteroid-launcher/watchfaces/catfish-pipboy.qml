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

    // External launchers can bind this for true ambient/AOD behavior.
    property bool ambientMode: false
    property var now: new Date()
    property color fg: "#00ff44"
    property color dim: "#0a7d2c"
    property color bg: "#031107"
    property color accent: "#7aff9e"
    property int burninOffsetX: ambientMode ? ((now.getMinutes() % 3) - 1) : 0
    property int burninOffsetY: ambientMode ? ((now.getSeconds() % 3) - 1) : 0
    property string characterState: bridge.steps > 3000 ? "walking" : (bridge.weatherCondition === "Rain" ? "reading" : "resting")

    PipboySettings { id: cfg }
    PipboyDataBridge { id: bridge; ambientMode: root.ambientMode }

    Timer {
        interval: root.ambientMode ? 60000 : (cfg.showSeconds ? 1000 : 15000)
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Rectangle {
        anchors.fill: parent
        color: bg
    }

    Rectangle {
        id: crtGlow
        anchors.fill: parent
        color: "transparent"
        border.width: ambientMode ? 1 : 2
        border.color: dim
        radius: width / 2
        anchors.margins: 10
    }

    Item {
        id: safeCircle
        width: parent.width - 36
        height: parent.height - 36
        anchors.centerIn: parent
        x: burninOffsetX
        y: burninOffsetY

        Rectangle {
            x: parent.width * 0.36
            y: 0
            width: parent.width * 0.28
            height: 34
            color: "transparent"
            border.width: 2
            border.color: fg
            Text { anchors.centerIn: parent; color: fg; font.pixelSize: 20; font.bold: true; text: "VAULT-TEC" }
        }

        Rectangle {
            x: 0; y: 56
            width: parent.width * 0.46
            height: 56
            color: "transparent"
            border.width: 2
            border.color: fg
            Text { x: 10; y: 6; color: fg; font.pixelSize: 22; font.bold: true; text: Fmt.two(root.now.getDate()) + "  " + Qt.formatDate(root.now, "MMM").toUpperCase() + "  " + root.now.getFullYear() }
            Text { x: 10; y: 32; color: accent; font.pixelSize: 18; font.bold: true; text: "WD " + Qt.formatDate(root.now, "ddd").toUpperCase() + "  w " + Fmt.weekOfYear(root.now) + "  d " + Fmt.dayOfYear(root.now) }
        }

        Rectangle {
            x: 0; y: 114
            width: parent.width * 0.46
            height: 58
            color: "transparent"
            border.width: 2
            border.color: fg
            Text { x: 10; y: 8; color: fg; font.pixelSize: 20; font.bold: true; text: "DATA    MAP" }
            Text { x: 24; y: 30; color: fg; font.pixelSize: 40; font.bold: true; text: bridge.stepsValid ? Math.min(99, Math.floor(bridge.steps / 100)).toString() : "0" }
            Text { x: 128; y: 30; color: fg; font.pixelSize: 34; font.bold: true; text: "<>" }
        }

        Rectangle {
            x: 0; y: 174
            width: parent.width * 0.46
            height: 116
            color: "transparent"
            border.width: 2
            border.color: fg
            Text { x: 10; y: 6; color: fg; font.pixelSize: 16; text: bridge.timezoneAbbr + "   " + (bridge.alarmEnabled ? bridge.nextAlarm : "--:--") + "  @" }
            Text { x: 10; y: 28; color: fg; font.pixelSize: 66; font.bold: true; text: Fmt.time24(root.now, !ambientMode && cfg.showSeconds) }
            Text { x: 12; y: 92; color: accent; font.pixelSize: 34; font.bold: true; text: "App shortcut" }
        }

        Text {
            x: parent.width * 0.52
            y: 62
            color: fg
            font.pixelSize: 48
            font.bold: true
            text: "CORE"
        }

        Text {
            x: parent.width * 0.70
            y: 62
            color: fg
            font.pixelSize: 52
            font.bold: true
            text: bridge.batteryPercent + "%"
        }

        Text { x: parent.width * 0.52; y: 94; color: dim; font.pixelSize: 30; text: "Temp " + bridge.currentTempC + " C*" }

        PipboyCharacter {
            x: parent.width * 0.57
            y: 134
            width: 126
            height: 154
            fg: fg
            ambientMode: root.ambientMode || cfg.simplifiedMode
            state: root.characterState
            visible: !cfg.simplifiedMode
        }

        Text { x: parent.width * 0.78; y: 120; color: fg; font.pixelSize: 48; font.bold: true; text: "STAT" }
        Text { x: parent.width * 0.78; y: 162; color: fg; font.pixelSize: 30; text: bridge.weatherValid ? bridge.weatherCondition : "NO DATA" }
        Text { x: parent.width * 0.78; y: 194; color: accent; font.pixelSize: 24; text: "PPT " + bridge.precipitationPercent + "%" }
        Text { x: parent.width * 0.78; y: 220; color: accent; font.pixelSize: 24; text: bridge.currentTempC + "F" }
        Text { x: parent.width * 0.78; y: 246; color: accent; font.pixelSize: 24; text: "+" + bridge.uvIndex }

        Text { x: parent.width * 0.52; y: 298; color: fg; font.pixelSize: 46; font.bold: true; text: "HP"; }
        Text { x: parent.width * 0.72; y: 298; color: fg; font.pixelSize: 46; font.bold: true; text: bridge.heartRateValid ? bridge.heartRate : 0; }
        PipboySegmentBar {
            x: parent.width * 0.52; y: 338
            width: parent.width * 0.42; height: 10
            value: bridge.heartRateValid ? bridge.heartRate : 0
            maximum: 200
            activeColor: fg
            passiveColor: dim
        }
        Text { x: parent.width * 0.52; y: 354; color: fg; font.pixelSize: 46; font.bold: true; text: "RAD 0"; }

        Text { x: 0; y: 410; color: fg; font.pixelSize: 50; font.bold: true; text: "AP: " + bridge.batteryPercent + "/" + bridge.batteryPercent; }
        Text { x: parent.width * 0.35; y: 450; color: accent; font.pixelSize: 18; text: "PIP v6.0_CLASSIC"; }
        Text { x: parent.width * 0.70; y: 450; color: accent; font.pixelSize: 18; text: "en_US"; }

        Rectangle {
            x: 0; y: 44
            width: parent.width; height: 3
            color: dim
        }
        Rectangle {
            x: 0; y: 430
            width: parent.width; height: 3
            color: dim
        }
    }

    PipboyScanlines {
        anchors.fill: parent
        enabledFx: !ambientMode && !cfg.simplifiedMode
    }

    MouseArea {
        anchors.fill: parent
        enabled: false
    }
}
