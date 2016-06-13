import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl

View {
    id: root

    NavigationBar {
        id: navbar
        title: "TestStatusImage"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Column {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.topMargin: Utl.dp(20)
        anchors.bottom: parent.bottom
        spacing: Utl.dp(10)

        RoundImage {
            id: _ri1
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/res/a2.jpg"
        }

        RoundImage {
            id: _ri2
            radius: Utl.dp(10)
            border.color: "red"
            border.width: Utl.dp(3)
            borderScape: Utl.dp(3)
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/res/a4.jpg"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    _ri2.selected = !_ri2.selected
                }
            }
        }
    }
}

