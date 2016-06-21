import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"
import "../net"

View {
    id: root

    Rectangle {
        id: rect
        width: 100; height: 100
        anchors.top: titleBar.bottom
        color: "red"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
        }

        states: State {
            name: "moved"; when: mouseArea.pressed
            PropertyChanges { target: rect; x: 50; y: 200 }
        }

        transitions: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.InOutQuad }
        }
    }
    Rectangle {
        id: rect1
        width: 100; height: 100
        anchors.top: rect.bottom; anchors.topMargin: 190
        color: "red"

        MouseArea { id: mouseArea1; anchors.fill: parent }

        states: State {
            name: "brighter"
            when: mouseArea1.pressed
            PropertyChanges { target: rect1; color: "yellow"; x: 50 }
        }

        transitions: Transition {
            SequentialAnimation {
                PropertyAnimation { property: "x"; duration: 1000 }
                ColorAnimation { duration: 1000 }
            }
        }
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
