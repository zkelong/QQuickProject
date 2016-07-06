import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property int itemHeight: root.height/4

    NavigationBar {
        id: navbar
        title: "NumberAnimation"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: _col.height + Utl.dp(20)
        clip: true

        Column {
            id: _col
            width: parent.width
            height: childrenRect.height
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            spacing: Utl.dp(10)

            Item {
                id: item0
                width: parent.width
                height: itemHeight
                Rectangle {         //属性动画
                    id: flashingblob
                    width: root.width; height: cellHeight
                    color: "green"

                    Rectangle {
                        id: rectbg
                        x: 0
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height/2
                        width: height
                        color: "red"
                        opacity: 1.0
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            animateOpacity.start()
                        }
                    }

                    NumberAnimation {
                        id: animateOpacity
                        target: rectbg
                        properties: "x"
                        from: rectbg.width + Utl.dp(45)
                        to: parent.width - rectbg.width -Utl.dp(45)
                        duration: 2000
                        loops: Animation.Infinite   //不停
                        easing {type: Easing.OutBack;   //动画模式
                            overshoot: 20}    //超过程度
                    }
                }
            }
            Item {
                id: item1
                width: parent.width
                height: itemHeight
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
                }

            }
        }
    }
}

/*
Easing:
easing group
easing.type : enumeration
easing.amplitude : real
easing.overshoot : real
easing.period : real
easing.bezierCurve : list<real>
**/

