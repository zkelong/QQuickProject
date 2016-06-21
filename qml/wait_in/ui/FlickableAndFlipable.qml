import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"

View {
    id: root

    Flipable {
        id: flipable
        anchors.centerIn: parent
        width: parent.width/2
        height: width*1.5

        property bool flipped: false

        front: Image {width: parent.width; height: parent.height; source: "qrc:/res/a.png"; anchors.centerIn: parent }
        back: Image {width: parent.width; height: parent.height; source: "qrc:/res/a.jpg"; anchors.centerIn: parent }

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     //旋转轴的设置，各个方向，三维的
            angle: 0    // the default angle
        }

        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180}
            when: flipable.flipped
        }

        transitions: Transition {
            NumberAnimation { target: rotation; property: "angle"; duration: 4000 } //旋转速度
        }

        MouseArea {
            anchors.fill: parent
            onClicked: flipable.flipped = !flipable.flipped
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
