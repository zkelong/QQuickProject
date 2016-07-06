import QtQuick 2.4
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
        title: "RotationAnimator/tion"
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
            }
            Item {
                id: item1
                width: parent.width
                height: itemHeight

                Rectangle {
                        id: rect
                        width: 150; height: 100; anchors.centerIn: parent
                        color: "red"
                        antialiasing: true

                        states: State {
                                name: "rotated"
                                PropertyChanges { target: rect; rotation: 180 }
                            }

                        transitions: Transition {
                            RotationAnimation { duration: 1000; direction: RotationAnimation.Counterclockwise }
                        }
                    }

                    MouseArea { anchors.fill: parent; onClicked: rect.state = rect.state == "rotated" ? "" : "rotated"}
            }
        }
    }
}

