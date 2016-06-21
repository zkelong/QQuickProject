import QtQuick 2.4

import "../../controls"
import "."

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
                root.navigationView.push(modelChange)
                break;
            case 1:
                root.navigationView.push(highLight)
                break;
            case 2:
                root.navigationView.push(highLightM)
                break;
            case 3:
                root.navigationView.push(style)
                break;
            case 4:
                root.navigationView.push(animation)
                break;
            case 5:
                root.navigationView.push(load)
                break;
            case 6:
                root.navigationView.push(loadx)
                break;
            default:
                break;
            }
        }
    }

    ListModel {
        id: listModel
        ListElement {itemName: "Model Change"; itemId: 0}
        ListElement {itemName: qsTr("HighLight-默认动画"); itemId: 1}
        ListElement {itemName: qsTr("HighLight-自定义动画"); itemId: 2}
        ListElement {itemName: qsTr("ListView样式"); itemId: 3}
        ListElement {itemName: qsTr("ListView动画"); itemId: 4}
        ListElement {itemName: qsTr("listView加载"); itemId: 5}
        ListElement {itemName: qsTr("listView加载左右"); itemId: 6}
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }

    Component {  //数据源有改变，并伴随动画
        id: modelChange
        ListViewModelChange{}
    }

    Component {  //HighLight-默认动画
        id: highLight
        ListViewHighLight{}
    }

    Component {  //HighLight-自定义动画
        id: highLightM
        ListViewHighLightM{}
    }

    Component {  //显示样式
        id: style
        ListViewStyle{}
    }

    Component {  //ListView动画
        id: animation
        ListViewAnimation{}
    }

    Component {  //ListView加载
        id: load
        ListViewLoad{}
    }

    Component {  //ListView加载左右
        id: loadx
        ListViewLoadLR{}
    }
}



