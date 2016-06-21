import QtQuick 2.0
import "../controls"
import "."

View {
    id: root
    Text {
        anchors.centerIn: parent
        text: "JS"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.navigationView.push(js)
        }
    }

    Component {
        id: js
        JsMain{}
    }
}

