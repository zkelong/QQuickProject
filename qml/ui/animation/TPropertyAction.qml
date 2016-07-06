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
                height: itemHeight * 3

                Image {
                    id: img
                    width: parent.width/2
                    height: width
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectCrop
                    source: "qrc:/res/h1.jpg"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("image.....", img.height, img.width)
                            sa.start()
                        }
                    }
                }
                SequentialAnimation {
                    id: sa
                    running: false
                    PropertyAction { target: img; property: "opacity"; value: .5 }//作用与ScriptAction一样
                    NumberAnimation { target: img; property: "width"; to: img.width == item0.width/2 ? img.height*2 : item0.width/2; duration: 1000 }
                    ScriptAction{script: {img.opacity = 1}} //PropertyAction { target: img; property: "opacity"; value: 1 }
                }
            }
        }
    }
}

