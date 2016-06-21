import QtQuick 2.4

import "../../controls"

View {
    id: root

    property int cellHeight: 200//(parent.height - titleBar.hight - 20) / 3

    Flickable {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentHeight: childrenRect.height

        Column{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height
            spacing: 10

            Rectangle {         //属性动画
                id: flashingblob
                width: root.width; height: cellHeight
                color: "black"

                Rectangle {
                    id: rectbg
                    anchors.centerIn: parent
                    width: parent.width/2; height: parent.height/2
                    color: "blue"
                    opacity: 1.0
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        animateColor.start()
                        animateOpacity.start()
                    }
                }

                PropertyAnimation {
                    id: animateColor;
                    target: rectbg;
                    properties: "color";
                    to:"green"
                    duration: 2000
                    onStopped: {
                        rectbg.color = "blue"
                    }
                }

                NumberAnimation {
                    id: animateOpacity
                    target: rectbg
                    properties: "opacity"
                    from: 0.45
                    to: 1.0
                    duration: 2000
                    //                     loops: Animation.Infinite
                    //                     easing {type: Easing.OutBack; overshoot: 2000}
                }
            }

            Rectangle {         //状态动画的过渡
                id: button
                width: root.width; height: cellHeight
                state: "RELEASED"

                MouseArea {
                    anchors.fill: parent
                    onPressed: button.state = "PRESSED"
                    onReleased: button.state = "RELEASED"
                }

                states: [
                    State {
                        name: "PRESSED"
                        PropertyChanges { target: button; color: "purple"}
                    },
                    State {
                        name: "RELEASED"
                        PropertyChanges { target: button; color: "lightsteelblue"}
                    }
                ]

                transitions: [
                    Transition {
                        from: "PRESSED"
                        to: "RELEASED"
                        ColorAnimation { target: button; duration: 1000}
                    },
                    Transition {
                        from: "RELEASED"
                        to: "PRESSED"
                        ColorAnimation { target: button; duration: 1000}
                    }
                ]
            }

            Rectangle {         //默认动画
                width: root.width; height: cellHeight
                //箭头
                Image{
                    id:refreshImg; source: "qrc:/res/refresh.png"
                    width: 32; height: 26; anchors.centerIn: parent
                    RotationAnimator on rotation {
                        running: true
                        loops: 1000
                        from: 0;
                        to: 360;
                        duration: 800
                    }
                }

                //球
                Rectangle {
                    id: ball
                    width: 45; height: 45; radius: width
                    color: "salmon"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(ball.x != 100 && ball.y != 100) {
                                ball.x = 100; ball.y = 100
                            } else {
                                ball.x = 0; ball.y = 0;
                            }
                        }
                    }

                    Behavior on x {
                        NumberAnimation {
                            id: bouncebehavior
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1.0
                                period: 0.5
                            }
                        }
                    }
                    Behavior on y {
                        animation: bouncebehavior
                    }
                    Behavior {
                        ColorAnimation { target: ball; duration: 5000 }
                    }
                }
            }

            Rectangle {         //串行或并行执行动画
                id: banner
               width: root.width; height: cellHeight
               border.color: "black"

                Column {
                    anchors.centerIn: parent
                    Text {
                        id: code
                        text: "Code less."
                        opacity: 0.01
                    }
                    Text {
                        id: create
                        text: "Create more."
                        opacity: 0.01
                    }
                    Text {
                        id: deploy
                        text: "Deploy everywhere."
                        opacity: 0.01
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: playbanner.start()
                    onDoubleClicked: play.start()
                }
                //一旦有动画被放在了SequentialAnimation 或 ParallelAnimation中, 他们就不会再独立的启动或停止.串行或并行动画必须作为一个组合来启动或停止.
                SequentialAnimation {  //串行动画
                    id: playbanner
                    running: false
                    NumberAnimation { target: code; property: "opacity"; to: 1.0; duration: 2000}
                    NumberAnimation { target: create; property: "opacity"; to: 1.0; duration: 2000}
                    NumberAnimation { target: deploy; property: "opacity"; to: 1.0; duration: 2000}
                }

                ParallelAnimation {  //并行动画
                    id: play
                    running: false
                    NumberAnimation { target: code; property: "opacity"; to: 1.0; duration: 2000}
                    NumberAnimation { target: create; property: "opacity"; to: 1.0; duration: 2000}
                    NumberAnimation { target: deploy; property: "opacity"; to: 1.0; duration: 2000}
                }
            }
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

