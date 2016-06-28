import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    Component.onCompleted: {
        picAni.start()
    }

    NavigationBar {
        id: navbar
        title: "AnimatedImage(Sprite)"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable {
       width: parent.width
       anchors.top: navbar.bottom
       anchors.bottom: parent.bottom
       contentHeight: _col.height
       clip: true

       Column {
           id: _col
           width: parent.width
           //height: childrenRect.height
           Item {
               width: parent.width
               height: root.height/3

               RoundImage{
                   id: _img
                   height: parent.height - Utl.dp(20)
                   width: height
                   anchors.centerIn: parent
                   source: "qrc:/res/a2.jpg"
               }
           }
       }
    }

    SequentialAnimation {
        id: picAni
        running: false
        loops: Animation.Infinite
        NumberAnimation { target: _img; property: "scale";from: 1;to: 0; duration: 1300;}
        NumberAnimation { target: _img; property: "scale";from: 0;to: 0; duration: 300;}
        NumberAnimation { target: _img; property: "scale";from: 0;to: 1; duration: 1300;}
    }
}

