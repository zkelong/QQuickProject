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
                    root.navigationView.push(bgView)
                    break;
                case 1:
                    root.navigationView.push(clip)
                    break;
                default:
                    break;
            }
        }
    }

    ListModel {
        id: listModel
        ListElement{itemName: qsTr("基础图形"); itemId: 0}  //基础图形
        ListElement{itemName: qsTr("裁剪图片"); itemId: 1}
    }

    Component {   //基础图形
        id: bgView
        BasicGraphical {}
    }

    Component {
        id: clip
        ClipImage {}
    }


    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
