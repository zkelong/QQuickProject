import QtQuick 2.4
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property int listViewHeight: root.height/2.5
    property int listCellHight: Utl.dp(40)

    NavigationBar {
        id: navbar
        title: "Header/Footer"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    //    Flickable {
    //        id: flick
    //        anchors.top: navbar.bottom
    //        anchors.left: parent.left
    //        anchors.right: parent.right
    //        anchors.bottom: parent.bottom
    //        contentHeight: childrenRect.height

    Column {
        id: _column
        width: parent.width
        height: childrenRect.height
        anchors.centerIn: parent
        spacing: 10

        Rectangle {  //页眉，页脚
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height

            Text {
                id: txt3
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pointSize: 16
                font.bold: true
                text: qsTr("页眉，页脚：")
            }
            ListView {
                anchors.top: txt3.bottom
                anchors.topMargin: 5
                width: parent.width
                height: listViewHeight
                clip: true
                model: listModel
                delegate: normalDelegate

                //QtQuick 2.4/ListView.InlineHeader(默认)；ListView.OverlayHeader(滑动时页眉不动，在list下方)；ListView.PullBackHeader(向上滑跟着动，向下画，不向下弹动)
                headerPositioning: ListView.PullBackHeader
                header: Rectangle{
                    height: listCellHight*2; width: root.width; color: "#ddff00"
                    Text{anchors.centerIn: parent; text: qsTr("页眉")}
                }
                //footerPositioning: //ListView.InlineFooter(default) ；ListView.OverlayFooter；ListView.PullBackFooter
                footer: Rectangle{
                    height: listCellHight*2; width: root.width; color: "#ddff00"
                    Text{anchors.centerIn: parent; text: qsTr("页脚")}
                }
            }
        }
    }
    //    }

    //样式
    Component {
        id: normalDelegate
        Rectangle {
            width: root.width; height: listCellHight
            color: "skyBlue"
            border.color: "black"
            radius: 3
            property int currentIndex: 0
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

}

