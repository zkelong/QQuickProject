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
        title: "FastBlur"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Text {
        anchors.centerIn: img
        font.pointSize: 12
        text: "正在加载..xx."
    }

    Image {
        id: img
        width: parent.width * .68
        height: width * 1.5
        anchors.centerIn: parent
        source: Config.wallpaperUrl[5]
    }

    FastBlur {
        id: fbl
        width: img.width/3
        height: img.height/3
        anchors.left: img.left
        anchors.top: img.top
        source: img
        radius: 0
    }
    ProgressBar{
        id: progressx
        width: parent.width - Utl.dp(40)
        anchors.top: img.bottom
        anchors.topMargin: Utl.dp(18)
        anchors.horizontalCenter: parent.horizontalCenter
        onProgressChanged: {
            fbl.radius = 100 * progress
        }
    }
    Text {
        anchors.left: img.left
        anchors.top: progressx.bottom
        anchors.topMargin: Utl.dp(10)
        font.pointSize: 12
        text: "FastBlur-radus: " + fbl.radius
    }

    FuzzyPanel{
        width: img.width/3
        height: width
        x: img.x + 100
        y: img.y + 100
        target: img
        radius: fbl.radius  //设置为0，将遮挡的地方显示出来
    }
}

