import QtQuick 2.6

QtObject {
    property int bus: 0
    property string service: ""
    property string path: ""
    property string iface: ""
    property bool signalsEnabled: false

    function call(method, args) {
    }

    function typedCall(method, args, callback) {
        if (callback) {
            callback([[0, 0], 0])
        }
    }
}
