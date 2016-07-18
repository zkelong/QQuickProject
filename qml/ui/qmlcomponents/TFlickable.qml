import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    Rectangle {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        color: "#4400ffff"

        Line {
            id: line1
            y: Utl.dp(50)
            color: "purple"
        }
        Line {
            id: line2
            y: Utl.dp(100)
            color: "purple"
        }
        Line {
            id: line3
            y: Utl.dp(140)
            color: "purple"
        }
        Line {
            id: lin4
            y: Utl.dp(180)
            color: "purple"
        }
        Line {
            id: lin5
            y: Utl.dp(240)
            color: "purple"
        }
    }

    Flickable {
        id: flick
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: childrenRect.height

        Rectangle {
            width: parent.width
            height: root.height - navbar.height
            border.width: Utl.dp(2)
            color: "#11ff00ff"
        }

        onContentYChanged: {
            if(contentY < -Utl.dp(100))
                console.log("contentYChange...", Utl.dp(100), " ", contentY)
            else
                console.log("contentYChange...xxxxxxxxxxxxxxxxxx", contentY)
            if(contentY < -Utl.dp(100))
                contentY = -Utl.dp(100)

        }
//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                flick(200, 200)
//            }
//        }
    }


    NavigationBar {
        id: navbar
        title: "Flickable下拉高度"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
}

