import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"
import "../net"

View {
    id: root

    ListView {
        id: listView1
        anchors.fill: parent
        snapMode: ListView.SnapOneItem  //listView停止位置
        highlightRangeMode: ListView.StrictlyEnforceRange //滑动到item中，自动滑动
        highlightMoveDuration: 250
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds //弹动效果

        model: listModel1
        delegate: listDelegate1
    }

    ListView {
        id: listView2
        anchors.fill: parent
        orientation: ListView.Vertical
        model: listModel1
        delegate: listDelegate
        spacing: 20
    }

    ListModel {
        id: listModel1
        ListElement {
            showColor: "green";
            itemId: 1
        }
        ListElement {
            showColor: "blue";
            itemId: 2
        }
    }

    Component {
        id: listDelegate1
        Rectangle {
            width: root.width; height: root.height
            color: showColor
            MouseArea {
                anchors.fill: parent
                onClicked: console.log("itemId: ", itemId)
            }
        }
    }

    Component {
        id: listDelegate
        Rectangle {
            width: root.width; height: root.height
            color: showColor
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
