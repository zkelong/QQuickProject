import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl

View {
    id: root
    hidenTabbarWhenPush: true

    property int cellHeight: Utl.dp(50)

    NavigationBar {
        id: navbar
        title: "Animation"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    ListView {
        id: _listView
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        model: _model
        delegate: _delegate
        clip: true
        spacing: Utl.dp(5)
    }

    Component {
        id: _delegate
        Rectangle {
            width: _listView.width
            height: cellHeight

            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: FontUtl.FontSizeSmallC
                text: strName
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    toNext(lid)
                }
            }
            Line {
                anchors.top: parent.top
            }
            Line {
                anchors.bottom: parent.bottom
            }
        }
    }

    Component {
        id: tai
        TAnimatedImage{}
    }
    Component {
        id: ts
        TScaleAnimation{}
    }
    Component {
        id: tt
        TTransition{}
    }

    ListModel {
        id: _model
        ListElement {
            lid: 1
            strName: "AnimatedImage/AnimatedSprite"
        }
        ListElement {
            lid: 2
            strName: "ScaleAnimation"
        }
        ListElement {
            lid: 3
            strName: "Transition"
        }
    }

    function toNext(id) {
        switch(id) {
        case 1:
            root.navigationView.push(tai)
            break;
        case 2:
            root.navigationView.push(ts)
            break;
        case 3:
            root.navigationView.push(tt)
            break;
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
