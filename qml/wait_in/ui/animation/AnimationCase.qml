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
/*
    Transition - 状态改变的过度动画
    SequentialAnimation - 串行执行动画
    ParallelAnimation - 并行执行动画
    Behavior - 为属性变化指定默认动画
    PropertyAction - 动画中设置立即改变的属性值（Sets immediate property changes during animation）
    PauseAnimation - 在动画中引入暂停
    SmoothedAnimation - 运行属性平滑的过度到一个新的值
    SpringAnimation - 以弹跳式的方式给属性设置一个新值
    ScriptAction - 动画中执行脚本

动画属性元素的数据类型

    PropertyAnimation - 属性改变动画
    NumberAnimation - qreal类型属性改变动画
    Vector3dAnimation - QVector3d类型属性改变动画
    ColorAnimation - 颜色改变动画
    RotationAnimation -旋转动画
    ParentAnimation - parent更改动画
    AnchorAnimation - 描点改变动画
*/
