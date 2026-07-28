import QtQuick 2.6
import "logic/pipboyFormatter.js" as Fmt
import "ui"

Item {
    id: app

    width: parent ? parent.width : 480
    height: parent ? parent.height : 480

    property int safeSize: Math.min(width, height)
    property bool ambientMode: false
    property date now: new Date()
    property int batteryPercentStub: 87
    property int heartRateStub: 72
    property int stepsStub: 8420

    readonly property color phosphor: ambientMode ? "#80ff77" : "#7aff6a"
    readonly property color phosphorDim: ambientMode ? "#245f2c" : "#1b6b28"
    readonly property color amber: "#f2c24a"
    readonly property color screenBg: "#020905"

    Timer {
        interval: ambientMode ? 60000 : 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: app.now = new Date()
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    Item {
        id: face

        width: app.safeSize
        height: app.safeSize
        anchors.centerIn: parent

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            radius: width / 2
            color: app.screenBg
            border.width: Math.max(1, face.width * 0.009)
            border.color: app.phosphorDim
        }

        Item {
            id: safe

            anchors.centerIn: parent
            width: parent.width * 0.84
            height: width

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: Math.max(1, safe.width * 0.004)
                border.color: app.phosphorDim
                opacity: 0.55
            }

            Repeater {
                model: 60
                Item {
                    anchors.fill: safe
                    rotation: index * 6

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: safe.height * 0.012
                        width: index % 5 === 0 ? safe.width * 0.010 : safe.width * 0.005
                        height: index % 5 === 0 ? safe.height * 0.042 : safe.height * 0.024
                        radius: width / 2
                        color: index % 15 === 0 ? app.amber : app.phosphorDim
                        opacity: index % 5 === 0 ? 0.9 : 0.5
                    }
                }
            }

            Text {
                id: tabs
                anchors.horizontalCenter: parent.horizontalCenter
                y: safe.height * 0.075
                color: app.phosphor
                text: "VAULT-TEC"
                font {
                    family: "monospace"
                    pixelSize: safe.height * 0.062
                    bold: true
                    letterSpacing: 0
                }
            }

            Rectangle {
                x: safe.width * 0.14
                y: safe.height * 0.17
                width: safe.width * 0.72
                height: Math.max(2, safe.height * 0.006)
                color: app.phosphor
            }

            Text {
                id: timeText
                x: safe.width * 0.075
                y: safe.height * 0.215
                width: safe.width * 0.84
                height: safe.height * 0.23
                color: app.phosphor
                text: Fmt.time24(app.now, !app.ambientMode)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font {
                    family: "monospace"
                    pixelSize: app.ambientMode ? safe.height * 0.185 : safe.height * 0.145
                    bold: true
                    letterSpacing: 0
                }
            }

            Text {
                x: safe.width * 0.09
                y: safe.height * 0.455
                width: safe.width * 0.53
                color: app.phosphor
                text: Qt.formatDate(app.now, "ddd").toUpperCase() + "  " + Fmt.dateDDMMYYYY(app.now)
                font {
                    family: "monospace"
                    pixelSize: safe.height * 0.044
                    bold: true
                    letterSpacing: 0
                }
            }

            Text {
                x: safe.width * 0.09
                y: safe.height * 0.515
                width: safe.width * 0.52
                color: app.phosphorDim
                text: "DOY " + Fmt.dayOfYear(app.now) + "   WOY " + Fmt.weekOfYear(app.now)
                font {
                    family: "monospace"
                    pixelSize: safe.height * 0.033
                    letterSpacing: 0
                }
            }

            Rectangle {
                id: lowerPanel
                x: safe.width * 0.095
                y: safe.height * 0.60
                width: safe.width * 0.81
                height: safe.height * 0.155
                color: "transparent"
                border.width: Math.max(1, safe.width * 0.004)
                border.color: app.phosphor
            }

            Text {
                x: lowerPanel.x
                y: lowerPanel.y + lowerPanel.height * 0.18
                width: lowerPanel.width / 3
                color: app.phosphor
                text: "PWR " + app.batteryPercentStub + "%"
                horizontalAlignment: Text.AlignHCenter
                font {
                    family: "monospace"
                    pixelSize: lowerPanel.height * 0.29
                    bold: true
                    letterSpacing: 0
                }
            }

            Text {
                x: lowerPanel.x + lowerPanel.width / 3
                y: lowerPanel.y + lowerPanel.height * 0.18
                width: lowerPanel.width / 3
                color: app.phosphor
                text: "STAT " + app.stepsStub
                horizontalAlignment: Text.AlignHCenter
                font {
                    family: "monospace"
                    pixelSize: lowerPanel.height * 0.29
                    bold: true
                    letterSpacing: 0
                }
            }

            Text {
                x: lowerPanel.x + lowerPanel.width * 2 / 3
                y: lowerPanel.y + lowerPanel.height * 0.18
                width: lowerPanel.width / 3
                color: app.phosphor
                text: "HP " + app.heartRateStub
                horizontalAlignment: Text.AlignHCenter
                font {
                    family: "monospace"
                    pixelSize: lowerPanel.height * 0.29
                    bold: true
                    letterSpacing: 0
                }
            }

            Text {
                anchors.horizontalCenter: safe.horizontalCenter
                y: safe.height * 0.855
                color: app.phosphorDim
                text: app.ambientMode ? "PIP-BOY ASTEROID  AMBIENT" : "PIP-BOY ASTEROID  MVP"
                font {
                    family: "monospace"
                    pixelSize: safe.height * 0.031
                    letterSpacing: 0
                }
            }
        }

        PipboyScanlines {
            anchors.fill: parent
            enabledFx: !app.ambientMode
            lineColor: "#2600ff44"
        }
    }
}
