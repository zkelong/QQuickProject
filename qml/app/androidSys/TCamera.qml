import QtQuick 2.0
import QtGraphicalEffects 1.0
import ACameraCall 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

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
                width: Utl.dp(120)
                height: width*.6
                radius: Utl.dp(5)
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: Utl.dp(8)
                anchors.verticalCenter: parent.verticalCenter
                label.text: qsTr("Android系统1")
                color: Color.ButtonColor
                onClicked: {
                    console.log("Android.....")
                    capture()
                }
            }
            Button {
                width: Utl.dp(120)
                height: width*.6
                radius: Utl.dp(5)
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: Utl.dp(8)
                anchors.verticalCenter: parent.verticalCenter
                label.text: qsTr("Android系统2")
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
            console.log("Only Run Android")
        }
        onSucceed: {
            txt.text = path
            img.source = "file://" + path
            img.visible = true
        }
    }


    Button {
        width: Utl.dp(40)
        height: Utl.dp(30)
        radius: Utl.dp(6)
        anchors.left: parent.left
        anchors.leftMargin: Utl.dp(10)
        anchors.top: navbar.bottom
        anchors.topMargin: Utl.dp(10)
        border.color: Color.GreenTheme
        border.width: Utl.dp(2)
        label.text: "show"
        onClicked: {
            img.visible = true
        }
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
        Text {
            id: txt
            width: parent.width
            anchors.bottom: parent.bottom
            wrapMode: Text.WrapAnywhere
            color: "red"
        }
    }

    function capture() {
        try {
            CallNativeCamera.ready.connect(function(path){
                CallNativeCamera.ready.disconnect(arguments.callee);
                console.log(path);
                txt.text = path
                img.source = path
                img.visible = true
            });
            CallNativeCamera.error.connect(function(error, errorString){
                CallNativeCamera.error.disconnect(arguments.callee);
                console.log("errorCode:", error);
                console.log("errorString:", errorString);
            });
            CallNativeCamera.capture();
        } catch(e) {
            console.log(e)
        }
    }
}

