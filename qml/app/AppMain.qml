import QtQuick 2.0
import "../controls"
import "../"

View {
    id: root
    hidenTabbarWhenPush: true

    Text {
        anchors.centerIn: parent
        text: "APP"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.navigationView.push(test)
        }
    }

    Component {
        id: test
        MainTest {}
    }
}

