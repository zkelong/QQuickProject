import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"

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
                    root.navigationView.push(ts)
                    break;
                case 1:
                    root.navigationView.push(sector)
                    break;                    
                case 2:
                    root.navigationView.push(picT)
                    break;
                case 3:
                    root.navigationView.push(memory)
                    break;                    
                case 4:
                    root.navigationView.push(belief)
                    break;
                default:
                    break;
            }
        }
    }

    ListModel {
        id: listModel
        ListElement{itemName: qsTr("侧边栏模仿实验--滑动显示有问题"); itemId: 0}  //MouseArea信号
        ListElement{itemName: qsTr("不规则点击面"); itemId: 1}  //PathView
        ListElement{itemName: qsTr("图片显示类型"); itemId: 2}  //PathView        
        ListElement{itemName: "Memory"; itemId: 3}  //记忆
        ListElement{itemName: "Belief"; itemId: 4}
    }

    Component {
        id: belief
        Belief{}
    }

    Component {
        id: memory
        Memory{}
    }
    Component {
        id: ts
         TestSidebar{}
    }

    Component {
        id: sector
        SectorMouse{}
    }

    Component {
        id: picT
        ImageShowType{}
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
