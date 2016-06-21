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
                root.navigationView.push(line)
                break;
            case 1:
                root.navigationView.push(rectangle)
                break;
            case 2:
                root.navigationView.push(arc)
                break;
            case 3:
                root.navigationView.push(circular)
                break;
            case 4:
                root.navigationView.push(timepicker)
                break;
            case 5:
                root.navigationView.push(ad)
                break;
            default:
                break;
            }
        }
    }

    ListModel {
        id: listModel
        ListElement{itemName: qsTr("直线路径"); itemId: 0}  //直线路径
        ListElement{itemName: qsTr("矩形路径"); itemId: 1}  //矩形路径
        ListElement{itemName: qsTr("弧线路径"); itemId: 2}  //弧线路径
        ListElement{itemName: qsTr("圆形路径"); itemId: 3}  //圆形路径        
        ListElement{itemName: qsTr("时间选择"); itemId: 4}  //时间选择(循环)
        ListElement{itemName: qsTr("广告栏"); itemId:5}    //
    }

    Component {  //直线路径
        id: line
        PathViewLine{}
    }
    Component {  //矩形路径
        id: rectangle
        PathViewRectangle{}
    }
    Component {  //弧线路径
        id: arc
        PathViewArc{}
    }
    Component {  //圆形路径
        id: circular
        PathViewCircular{}
    }
    Component {  //时间选择(循环)
        id: timepicker
        TimePicker{}
    }
    Component {
        id: ad
        PathViewAd{}
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
