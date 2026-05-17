import QtQuick 2.6
import Qt.labs.settings 1.0

Item {
    id: root
    visible: false
    width: 0
    height: 0

    Settings {
        id: cfg
        category: "catfish_pipboy"
        property string colorTheme: "green"
        property string faction: "VAULT-TEC"
        property string mapIcon: "VAULT"
        property bool showWeather: true
        property bool showHealth: true
        property bool showStatus: true
        property bool simplifiedMode: false
        property int stepGoal: 8000
        property bool showSeconds: true
    }

    property alias colorTheme: cfg.colorTheme
    property alias faction: cfg.faction
    property alias mapIcon: cfg.mapIcon
    property alias showWeather: cfg.showWeather
    property alias showHealth: cfg.showHealth
    property alias showStatus: cfg.showStatus
    property alias simplifiedMode: cfg.simplifiedMode
    property alias stepGoal: cfg.stepGoal
    property alias showSeconds: cfg.showSeconds
}
