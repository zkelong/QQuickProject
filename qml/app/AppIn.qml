import QtQuick 2.0
import QtQuick.Window 2.2
import "../controls"
import "../.."
import "../toolsbox/tools.js" as Tools

View {
    id: root
    Text {
        anchors.centerIn: parent
        text: "APP"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.navigationView.push(app)
        }
    }

    Component {
        id: app
        AppMain {}
    }
}

