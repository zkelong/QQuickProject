import QtQuick 2.0
import QtGraphicalEffects 1.0
import ACamera 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

//图像处理HueSaturation
View {
    id: root
    hidenTabbarWhenPush: true

    property real itemHeight: root.height/3


    NavigationBar {
        id: navbar
        title: "Camera"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Column {
        id: _col
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        Item {
            id: _item0
            width: parent.width
            height: itemHeight
            Button {
                width: Utl.dp(140)
                height: width*.6
                radius: Utl.dp(5)
                anchors.centerIn: parent
                label.text: qsTr("Android系统的")
                color: Color.ButtonColor
                onClicked: {
                    console.log("Android.....")
                    acamera.takePhoto()
                }
            }
        }

        Item {
            id: _item1
            width: parent.width
            height: itemHeight

            Button {
                width: Utl.dp(140)
                height: width*.6
                radius: Utl.dp(5)
                anchors.centerIn: parent
                label.text: qsTr("Qt库的")
                color: Color.ButtonColor
                onClicked: {
                    console.log("Qt.....")
                }
            }
        }

        Item {
            id: _item2
            width: parent.width
            height: itemHeight

            Button {
                width: Utl.dp(140)
                height: width*.6
                radius: Utl.dp(5)
                anchors.centerIn: parent
                label.text: qsTr("Qml的")
                color: Color.ButtonColor
                onClicked: {
                    console.log("Qml.....")
                }
            }
        }
    }

    ACameraCall {
        id: acamera
        onCanceled: {

        }
        onErrored: {
        }
        onSucceed: {
            txt.text = path
            img.source = path
            img.visible = true
        }
    }

    Text {
        id: txt
        width: parent.width
        wrapMode: Text.WrapAnywhere
    }

    Image {
        id: img
        visible: false
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        MouseArea {
            anchors.fill: parent
            onClicked: {
                img.visible = false
            }
        }
    }
}

