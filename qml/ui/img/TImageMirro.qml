import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "TestHurSturation"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
    Image {
        id: img
        height: (parent.height - navbar.height)*.85
        width: height/1.5
        source: Config.wallpaperUrl[0]
        anchors.centerIn: parent
    }

    Button {
        id: btn
        width: Utl.dp(120)
        height: Utl.dp(45)
        radius: Utl.dp(5)
        color: "white"
        label.text: "mirro=false"
        border.color: "blue"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Utl.dp(15)
        onClicked: {
            if(img.mirror) {
                img.mirror = false
                btn.label.text = "mirro=false"
            } else {
                img.mirror = true
                btn.label.text = "mirro=true"
            }
        }
    }
}

