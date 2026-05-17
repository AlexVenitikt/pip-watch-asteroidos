import QtQuick 2.6
import QtQuick.Window 2.2
import "logic/pipboyFormatter.js" as Fmt
import "logic/pipboyThemes.js" as Themes
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
    property var pal: Themes.palette(cfg.colorTheme)
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
        color: pal.bg
    }

    Rectangle {
        id: crtGlow
        anchors.fill: parent
        color: "transparent"
        border.width: ambientMode ? 1 : 2
        border.color: pal.dim
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

        Text {
            x: 0; y: 0
            color: pal.fg
            font.pixelSize: 18
            text: cfg.faction + "  " + cfg.mapIcon
        }

        Text {
            x: 0; y: 30
            color: pal.fg
            font.pixelSize: 62
            font.bold: true
            text: Fmt.time24(root.now, !ambientMode && cfg.showSeconds && !cfg.simplifiedMode)
        }

        Text {
            x: 0; y: 96
            color: pal.accent
            font.pixelSize: 18
            text: Qt.formatDate(root.now, "ddd").toUpperCase() + "  " + Fmt.dateDDMMYYYY(root.now)
        }

        Text {
            x: 0; y: 121
            color: pal.dim
            font.pixelSize: 14
            text: "TZ " + bridge.timezoneAbbr + " | WOY " + Fmt.weekOfYear(root.now) + " | DOY " + Fmt.dayOfYear(root.now)
        }

        Rectangle {
            visible: cfg.showStatus
            x: 0; y: 148; width: parent.width; height: 24
            color: "transparent"
            border.width: 1
            border.color: pal.dim
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 8
                color: pal.fg
                font.pixelSize: 13
                text: "PWR " + bridge.batteryPercent + "% " + (bridge.charging ? "CHR" : "DIS")
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 8
                color: bridge.bluetoothConnected ? pal.fg : "#ff5555"
                font.pixelSize: 13
                text: bridge.bluetoothConnected ? "BT LINK" : "BT LOST"
            }
        }

        Column {
            visible: cfg.showHealth && !cfg.simplifiedMode
            x: 0; y: 182; width: parent.width; spacing: 8
            Text { color: pal.fg; font.pixelSize: 14; text: "HP " + (bridge.heartRateValid ? bridge.heartRate + " BPM" : "N/A") }
            PipboySegmentBar {
                width: parent.width; height: 8
                value: bridge.heartRateValid ? bridge.heartRate : 0
                maximum: 200
                activeColor: pal.fg
                passiveColor: pal.dim
            }
            Text { color: pal.fg; font.pixelSize: 14; text: "RAD " + (bridge.stepsValid ? bridge.steps : 0) + "/" + cfg.stepGoal }
            PipboySegmentBar {
                width: parent.width; height: 8
                value: bridge.stepsValid ? bridge.steps : 0
                maximum: cfg.stepGoal
                activeColor: pal.fg
                passiveColor: pal.dim
            }
        }

        Column {
            visible: cfg.showWeather && !cfg.simplifiedMode
            x: 0; y: 286; width: parent.width; spacing: 4
            Text {
                color: pal.fg
                font.pixelSize: 14
                text: "WX " + (bridge.weatherValid ? bridge.weatherIcon + " " + bridge.weatherCondition + " " + bridge.currentTempC + "C" : "NO DATA")
            }
            Text {
                color: pal.accent
                font.pixelSize: 13
                text: "RAIN " + bridge.precipitationPercent + "%  UV " + bridge.uvIndex
            }
            Text {
                color: pal.dim
                font.pixelSize: 13
                text: "SUN " + bridge.sunrise + " / " + bridge.sunset
            }
            Text {
                color: pal.dim
                font.pixelSize: 13
                text: "MOON " + Fmt.moonPhaseName(Fmt.moonPhaseIndex(root.now))
            }
        }

        PipboyCharacter {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            fg: pal.fg
            ambientMode: root.ambientMode || cfg.simplifiedMode
            state: root.characterState
            visible: !cfg.simplifiedMode
        }
    }

    PipboyScanlines {
        anchors.fill: parent
        enabledFx: !ambientMode && !cfg.simplifiedMode
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Lightweight fallback interaction for watchface environments
            // without configurable tap actions API exposure.
            var themes = ["green", "amber", "blue", "white", "red", "pink"];
            var idx = themes.indexOf(cfg.colorTheme);
            cfg.colorTheme = themes[(idx + 1) % themes.length];
        }
    }
}
