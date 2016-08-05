import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true
    color: "black"

    property int cellHight: Utl.dp(100)

    NavigationBar {
        id: navbar
        title: "TextShow"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
    ShineText {
        anchors.centerIn: parent
    }
}

