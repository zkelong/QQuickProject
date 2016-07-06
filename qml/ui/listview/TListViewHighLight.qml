import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "ListAnimation"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    ListView {      //默认高亮动画
        id: listView
        anchors.top: navbar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: Utl.dp(5)
        clip: true
        spacing: Utl.dp(10)
        focus: true
        model: listModel //数据源
        delegate: normalDelegate  //普通样式
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
    }

    Line {
        anchors.verticalCenter: parent.verticalCenter
        height: Utl.dp(3)
        color: "red"
    }

    ListView {
        id: listView1
        anchors.top: parent.verticalCenter
        anchors.topMargin: Utl.dp(5)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        spacing: 10
        focus: true
        model: listModel
        delegate: normalDelegate1
        highlight: highlightBar  //高亮行显示样式（背景）
        highlightFollowsCurrentItem: false //高亮背景移动动画，如果highlight里定义了动画，此处设置为false，以免冲突
    }

    Component { //高亮行的样式
        id: highlightBar
        Rectangle {
            width: parent.width; height: 40
            color: "#FFFF88"
            y: listView1.currentItem.y;
            //动画
            Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
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

    //样式
    Component {
        id: normalDelegate
        Rectangle {
            width: parent.width; height: 40
            color:"transparent"

            Column {
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: '<b>Name:</b> ' + name
                    color: listView.currentIndex == index ? "red" : "black"
                }
                Text { text: '<b>Number:</b> ' + number }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index
                }
            }
        }
    }
    //样式
    Component {
        id: normalDelegate1
        Rectangle {
            width: parent.width; height: 40
            color:"transparent"

            Column {
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: '<b>Name:</b> ' + name
                    color: listView1.currentIndex == index ? "red" : "black"
                }
                Text { text: '<b>Number:</b> ' + number }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView1.currentIndex = index
                }
            }
        }
    }
}

