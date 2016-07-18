import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"
import "../net"

View {
    id: root

    property var currentItem: rect1

    Rectangle {
        id: rect
        z: 9
        width: 150; height: 150
        anchors.centerIn: parent
        color: "purple"
        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }
    }
    Rectangle {
        id: rect1
        z: 9
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#ff0000"
        transformOrigin: Item.Center   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.Center"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect1.z = 10;
                currentItem = rect1
            }
        }
    }
    Rectangle {
        id: rect2
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#00ff00"
        transformOrigin: Item.Top   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.Top"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect2.z = 10;
                currentItem = rect2
            }
        }
    }
    Rectangle {
        id: rect3
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#0000ff"
        transformOrigin: Item.TopLeft   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.TopLeft"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect3.z = 10;
                currentItem = rect3
            }
        }
    }
    Rectangle {
        id: rect4
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#000000"
        transformOrigin: Item.TopRight   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.TopRight"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect4.z = 10;
                currentItem = rect4
            }
        }
    }
    Rectangle {
        id: rect5
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#ff00ff"
        transformOrigin: Item.Left   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.Left"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect5.z = 10;
                currentItem = rect5
            }
        }
    }
    Rectangle {
        id: rect6
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#00ffff"
        transformOrigin: Item.Right   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.Right"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect6.z = 10;
                currentItem = rect6
            }
        }
    }
    Rectangle {
        id: rect7
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#f000f0"
        transformOrigin: Item.Bottom   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.Bottom"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect7.z = 10;
                currentItem = rect7
            }
        }
    }
    Rectangle {
        id: rect8
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#0f0f00"
        transformOrigin: Item.BottomLeft   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.BottomLeft"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect8.z = 10;
                currentItem = rect8
            }
        }
    }
    Rectangle {
        id: rect9
        width: 150; height: 150
        anchors.centerIn: parent
        color: "#0f000f"
        transformOrigin: Item.BottomRight   //9个旋转点，哇咔咔
        rotation: 45
        Text {
            anchors.centerIn: parent
            text: "Item.BottomRight"
            font.pointSize: 15
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentItem.z = 1
                rect9.z = 10;
                currentItem = rect9
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
