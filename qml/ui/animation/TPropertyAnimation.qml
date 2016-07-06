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
        title: "PropertyAnimation"
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
                }
            }
        }
    }
}

