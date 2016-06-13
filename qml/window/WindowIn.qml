import QtQuick 2.0
import "../controls"

View {
    id: root
    Text {
        anchors.centerIn: parent
        text: "Window"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.navigationView.push(wm)
        }
    }

    Component {
        id: wm
        WindowMain{}
    }
}

