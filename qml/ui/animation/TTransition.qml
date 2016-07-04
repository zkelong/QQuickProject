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
        title: "Transition"
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
                Rectangle {
                    id: rect0
                    width: 100; height: 100
                    color: "purple"
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                    }
                    states: State {
                        name: "moved"; when: mouseArea.pressed  //when触发状态变化
                        PropertyChanges {target: rect0; x: item0.width-rect0.width; y: item0.height-rect0.height}
                    }
                    transitions: Transition {   //属性变化时的动画--没有定义State时，这个动画不执行
                        NumberAnimation {properties: "x,y"; easing.type: Easing.InOutQuad}
                    }
                }
            }

            Item {
                id: item1
                width: parent.width
                height: itemHeight
                Rectangle {
                    id: rect1
                    width: 100; height: 100
                    color: "purple"
                    MouseArea {
                        id: mouseArea1
                        anchors.fill: parent
                    }
                    states: State {
                        name: "st1"; when: mouseArea1.pressed  //when触发状态变化
                        AnchorChanges {
                            target: rect1;
                            anchors.right: item1.right
                        }
                        PropertyChanges {
                            target: rect1;
                            x: item1.width-rect1.width;
                            y: item1.height-rect1.height
                        }
                        PropertyChanges {
                            target: rect1
                            scale: 1.2
                        }
                    }
                    transitions: Transition {   //属性变化时的动画--没有定义State时，这个动画不执行
                        NumberAnimation {properties: "x,y"; easing.type: Easing.InOutQuad}
                        AnchorAnimation {
                            easing.type: Easing.OutBounce;
                            duration: 1000
                        }
                    }
                }
            }


        }
    }
}

