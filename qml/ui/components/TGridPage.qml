import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true
    //color: "white"

    Component.onCompleted: {
        for(var i = 0; i < 125; i++) {
            var item = {showText: "X" + i}
            gp.model.append(item)
        }
    }

    GridPage {
        id: gp
        width: parent.width
        height: width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Utl.dp(25)
        delegate: Rectangle {
            width: gp.cellWidth
            height: gp.cellHeight
            color: "white"
            Rectangle {
                anchors.fill: parent
                anchors.margins: Utl.dp(10)
                color: "#1a7809"
                Text {
                    anchors.centerIn: parent
                    font.pointSize: FontUtl.FontSizeSmallA
                    color: Color.White
                    text: showText
                }
            }
        }
    }

    NavigationBar {
        id: navbar
        title: "GridPage"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
}

