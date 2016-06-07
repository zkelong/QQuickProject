import QtQuick 2.4

import "../controls"

View {

    property string pathcurrentChoice: ""

    Component.objectName: {
        pathcurrentChoice = appModel.get(view.currentIndex).name
    }

    Text {
        id: tx
        anchors.horizontalCenter: parent.horizontalCenter
        text: pathcurrentChoice
    }

    ListModel {
        id: appModel
        ListElement {name: "Musice-1"; icon: Config.testPicUrl[0]}
        ListElement {name: "Movie-2"; icon: Config.testPicUrl[1]}
        ListElement {name: "Camera-3"; icon: Config.testPicUrl[2]}
        ListElement {name: "Messaging-4"; icon: Config.testPicUrl[3]}
        ListElement {name: "ContactsList-5"; icon: Config.testPicUrl[4]}
    }

    Component {
        id: appDelegate
        Item {
            id: test
            width: 100; height: 100
            scale: PathView.iconScale //放大缩小倍数
            Image {
                id: myIcon
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
                width: 55
                height: 55
                source: icon
                smooth: true
            }
            Text {
                id: txt
                anchors{
                    top: myIcon.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                text: name
                smooth: true
                color: test.PathView.isCurrentItem ? "red" : "black"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: view.currentIndex = index
            }
        }
    }

    Component {
        id: appHighlight
        Rectangle {width: 80; height: 80; color: "lightsteelblue"}
    }

    PathView {
        id: view
        anchors.fill: parent
        highlight: appHighlight
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: appModel
        delegate: appDelegate
        //Path由一个或者多个路径组成，可用的路径包括PathLine、PathQuad和PathCubic
        path:Path {
            startX: 10
            startY: 50
            PathAttribute {name: "iconScale"; value: 0.5}
            PathQuad {x: 200; y:150; controlX: 50; controlY: 200}
            PathAttribute {name: "iconScale"; value: 1.0}
            PathQuad {x: 390; y:50; controlX: 350; controlY: 200}
            PathAttribute{name: "iconScale"; value: 0.5}
        }

        onCurrentIndexChanged: {
            pathcurrentChoice = appModel.get(currentIndex).name
            console.log(appModel.get(currentIndex).name)
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
