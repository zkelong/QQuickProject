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

    Component {
        id: pa
        TPropertyAnimation{}
    }

    Component {
        id: na
        TNumberAnimation{}
    }
    Component {
        id: ra
        TRotationAnimator{}
    }

    Component {
        id: ca
        TColorAnimation{}
    }
    Component{
        id: tsa
        TSequentialAnimation{}
    }
    Component{
        id: tpa
        TPauseAnimation{}
    }
    Component{
        id: tpac
        TPropertyAction{}
    }
    Component{
        id: sa
        TSpringAnimation{}
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
        ListElement {
            lid: 4
            strName: "PropertyAnimation"
        }
        ListElement {
            lid: 5
            strName: "NumberAnimation"
        }
        ListElement {
            lid: 6
            strName: "RotationAnimator(tion)"
        }
        ListElement {
            lid: 7
            strName: "ColorAnimation"
        }
        ListElement {
            lid: 8
            strName: "Sequential/ParallelAnimation"
        }
        ListElement {
            lid: 9
            strName: "PauseAnimation"
        }
        ListElement {
            lid: 10
            strName: "PropertyAction"
        }
        ListElement {
            lid: 11
            strName: "SpringAnimation"
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
        case 4:
            root.navigationView.push(pa)
            break;
        case 5:
            root.navigationView.push(na)
            break;
        case 6:
            root.navigationView.push(ra)
            break;
        case 7:
            root.navigationView.push(ca)
            break;
        case 8:
            root.navigationView.push(tsa)
            break;
        case 9:
            root.navigationView.push(tpa)
            break;
        case 10:
            root.navigationView.push(tpac)
            break;
        case 11:
            root.navigationView.push(sa)
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
/*
所有的动画元素都是从Animation元素继承的;这些元素为动画元素提供了必要的属性和方法.
动画元素具有start(),stop(),resume(),pause()和complete()方法--这些方法控制了动画的执行.

Easing曲线定义动画如何在起始值和终止值见产生插值.
不同的easing曲线定义了一系列的插值.easing曲线简化了创建动画的效果--如弹跳效果, 加速, 减速, 和周期动画.
QML对象中可能对每个属性动画都设置了不同的easing曲线.同时也有不同的参数用于控制曲线,有些是特除曲线独有的.更多信息见easing 文档.

此外,QML提供了几个对动画有用的其他元素:
    PauseAnimation: 允许停止动画
    ScriptAction: 允许在动画期间执行JavaScript,可与StateChangeScript配合来重用已存在的脚本.
    PropertyAction: 在动画期间直接修改属性,而不会产生属性变化动画

下面是针对不同属性类型的特殊动画元素
    SmoothedAnimation: 特殊的NumberAnimation,当目标值发生改变时提供平滑的动画效果
    SpringAnimation: 指定mass, damping 和epsilon等特殊属性来提供一个弹簧效果的动画
    ParentAnimation: 用在parent变化时的动画(见ParentChange)
    AnchorAnimation: 用在描点变化时的动画(见AnchorChanges)
*/
