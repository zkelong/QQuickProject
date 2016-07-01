import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"

View {
    id: root

    ClassMain {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        listModel: listModel
        onClicked: {
            switch(itemId) {
                case 0:
                    root.navigationView.push(direct)
                    break;
                case 1:
                    root.navigationView.push(transt)
                    break;
                default:
                    break;
            }
        }
    }

    ListModel {
        id: listModel
        ListElement{itemName: qsTr("触发动画(颜色/显示/大小/位置/透明度)"); itemId: 0}  //触发动画
        ListElement{itemName: qsTr("过度动画"); itemId: 1}  //PathView
    }

    Component {  //listView
        id: direct
        DirectPropertyAnimation{}
    }

    Component {  //过渡动画
        id: transt
        TransAnimation{}
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}

