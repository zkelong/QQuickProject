import QtQuick 2.0
import "../../controls"

View {
    id: root

    property int listViewHeight: parent.height / 2
    property int listCellHight: 40

    Flickable {
        id: flick
        anchors.top: titleBar.bottom; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        contentHeight: _column.y + _column.height

        Column {
            id: _column
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height
            spacing: 10

            Rectangle {  //滑动动画: 滑动-小变大
                anchors.left: parent.left
                anchors.right: parent.right
                height: childrenRect.height

                Text {
                    id: txt1
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                    font.bold: true
                    text: qsTr("滑动-小变大")
                }
                ListView {
                    anchors.top: txt1.bottom
                    anchors.topMargin: 5
                    width: parent.width
                    height: listViewHeight
                    clip: true
                    model: listModel
                    delegate: normalDelegate
                }
            }

            Rectangle {  //滑动动画: 滑动-左到右
                anchors.left: parent.left
                anchors.right: parent.right
                height: childrenRect.height

                Text {
                    id: txt2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                    font.bold: true
                    text: qsTr("滑动-左到右")
                }
                ListView {
                    anchors.top: txt2.bottom
                    anchors.topMargin: 5
                    width: parent.width
                    height: listViewHeight
                    clip: true
                    model: listModel
                    delegate: normalDelegate1
                }
            }
        }
    }

    //样式1
    Component { //加载动画: 滑动-小变大
        id: normalDelegate
        Rectangle {
            id: rect
            width: root.width; height: listViewHeight * 0.8
            color: "skyBlue"
            border.color: "black"
            radius: 3
            scale: 0.6   //缩放动画
            property int currentIndex: 0

            Component.onCompleted: {
                sa.start()
            }
            Column {
                Text {
                    text: '<b>Name:</b> ' + name
                    color: currentIndex == index ? "red" : "black"
                }
                Text { text: '<b>Number:</b> ' + number }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentIndex = index
                }
            }

            NumberAnimation {
                id:sa
                target: rect
                property: "scale"
                duration: 800
                to:1
                easing.type: Easing.InOutQuad
            }
        }
    }

    //样式2
    Component { //加载动画: 滑动-小变大
        id: normalDelegate1
        Rectangle {
            id: rect
            width: root.width; height: listViewHeight * 0.8
            x: root.width  //x位置动画
            color: "skyBlue"
            border.color: "black"
            radius: 3
            property int currentIndex: 0

            Component.onCompleted: {
                sa.start()
            }
            Column {
                Text {
                    text: '<b>Name:</b> ' + name
                    color: currentIndex == index ? "red" : "black"
                }
                Text { text: '<b>Number:</b> ' + number }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentIndex = index
                }
            }

            NumberAnimation {
                id:sa
                target: rect
                property: "x"
                duration: 800
                to:0
                easing.type: Easing.InOutQuad
            }
        }
    }

    //数据源
    ListModel {
        id:listModel
        ListElement {
            name: "111Bill Smith"
            number: "555 3264"
        }
        ListElement {
            name: "222John Brown"
            number: "555 8426"
        }
        ListElement {
            name: "333Sam Wise"
            number: "555 0473"
        }
        ListElement {
            name: "444Sam Wise"
            number: "555 0473"
        }
        ListElement {
            name: "555Sam Wise"
            number: "111 0473"
        }
        ListElement {
            name: "666Sam Wise"
            number: "222 0473"
        }
        ListElement {
            name: "777Sam Wise"
            number: "333 0473"
        }
        ListElement {
            name: "888Sam Wise"
            number: "444 0473"
        }
        ListElement {
            name: "999Sam Wise"
            number: "555 0473"
        }
        ListElement {
            name: "000Sam Wise"
            number: "666 0473"
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
