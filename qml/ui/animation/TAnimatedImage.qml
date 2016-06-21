import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "AnimatedImage(Sprite)"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Text {
        anchors.bottom: _aiOne.top
        anchors.bottomMargin: Utl.dp(5)
        anchors.right: _aiOne.left
        text: "AnimatedImage: "
    }

    AnimatedImage {
        id: _aiOne
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: Utl.dp(20)
        source: "qrc:/res/emoji/emoji3.gif"
    }

    Text {
        anchors.bottom: _aiT.top
        anchors.bottomMargin: Utl.dp(5)
        anchors.right: _aiOne.left
        text: "AnimatedImage: "
    }

    AnimatedSprite {
        id: _aiT
        running: true
        width: Utl.dp(176)
        height: Utl.dp(95)
        anchors.top: parent.verticalCenter
        anchors.topMargin: Utl.dp(35)
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/res/microphonePic.png";
        frameDuration:400;
        frameCount: 4;
        frameX: 0;
        frameY: 0;
    }
}

