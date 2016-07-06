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
        title: "ColorAnimation"
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
                    height: parent.height/2
                    width: height
                    anchors.centerIn: parent
                    color: "red"

                    ColorAnimation on color { to: "yellow"; duration: 1000 }
                }
            }
            Item {
                id: item1
                width: parent.width
                height: itemHeight

                Rectangle {
                    id: rect1
                    height: parent.height/2
                    width: height
                    anchors.centerIn: parent
                    color: "red"

                    states: State {
                        name: "xx"
                        PropertyChanges { target: rect1; color: "purple"
                        }
                    }
                    transitions: Transition{
                        ColorAnimation{from: "yellow"; duration: 2000}
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: rect1.state = "xx"
                    }
                }
            }
        }
    }
}

