import QtQuick 2.0

import QtQuick 2.0

import "../../controls"

View {
    id: root

    property string pathcurrentChoice;

    PathView{
        id: recommendList
        height: 200
        width: parent.width
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        highlightRangeMode: PathView.StrictlyEnforceRange;
        model: appModel
        delegate: appDelegate
        pathItemCount: 3
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        flickDeceleration: 500
        path:Path {
            startX: 0
            startY: Utl.dp(45);
            PathLine {
                x: recommendList.width
                y: Utl.dp(45);
            }
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
            width: (recommendList.width - 10) / 3
            height: recommendList.height
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: icon
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("appModel....", name)
                }
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

