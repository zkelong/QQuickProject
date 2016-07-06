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
        title: "S/PlAnimation"
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

            Rectangle {
                id: item0
                width: parent.width
                height: itemHeight * 3
                color: "#5500ff00"

                Rectangle {
                    id: rect0
                    width: Utl.dp(50)
                    height: width
                    color: "red"

                    Behavior on x {
                         SpringAnimation { spring: 2; damping: 0.2 }
                    }
                    Behavior on y {
                        SpringAnimation { spring: 3; damping: 0.2 }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rect0.x = mouse.x
                        rect0.y = mouseY
                    }
                }
            }
        }
    }
}

