import QtQuick 2.0

import "../../controls"

View {
    id: root

    property string pathcurrentChoice;

    PathView {
        id: view
        anchors.centerIn: parent
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

    ListModel {
        id: appModel
        ListElement {name: "PIC-1"; icon: "qrc:/res/11.jpg"}
        ListElement {name: "PIC-2"; icon: "qrc:/res/2.jpg"}
        ListElement {name: "PIC-3"; icon: "qrc:/res/3.jpg"}
        ListElement {name: "PIC-4"; icon: "qrc:/res/4.jpg"}
        ListElement {name: "PIC-5"; icon: "qrc:/res/5.jpg"}
        ListElement {name: "PIC-6"; icon: "qrc:/res/6.jpg"}
        ListElement {name: "PIC-7"; icon: "qrc:/res/7.jpg"}
        ListElement {name: "PIC-8"; icon: "qrc:/res/8.jpg"}
        ListElement {name: "PIC-9"; icon: "qrc:/res/9.jpg"}
        ListElement {name: "PIC-10"; icon: "qrc:/res/10.jpg"}
        ListElement {name: "PIC-11"; icon: "qrc:/res/12.jpg"}
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



    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}

