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

            Item {
                id: item0
                width: parent.width
                height: itemHeight

                Rectangle {
                    id: rect1
                    width: 100
                    height: width
                    x: 0
                    anchors.verticalCenter: parent.verticalCenter
                    color: "red"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            sa.start()
                        }
                    }
                }
                SequentialAnimation {
                    id: sa
                    running: false
                    NumberAnimation {target: rect1; properties: "x"; from: 0; to: item0.width-rect1.width; duration: 2000 }
                    PauseAnimation { duration: 800 }
                    NumberAnimation {target: rect1; properties: "x"; to: 0; duration: 200 }
                }
            }
        }
    }
}

