import QtQuick 2.0
import "../controls"

View {
    id: root
    Text {
        anchors.centerIn: parent
        text: "UI"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.navigationView.push(ui)
        }
    }

    Component {
        id: ui
        UiMain {}
    }
}

