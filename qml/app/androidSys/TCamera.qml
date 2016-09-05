import QtQuick 2.0
import QtGraphicalEffects 1.0
import ACameraCall 1.0
import QtMultimedia 5.6
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property real itemHeight: root.height/3
    property var cameraItem: null


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
                    if(cameraItem) {
                        cameraItem.visible = true
                    } else {
                        cameraItem = com_camera.createObject(root)
                    }
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
            });
            CallNativeCamera.capture();
        } catch(e) {
            console.log(e)
        }
    }

    Component {
        id: com_camera
        Rectangle {
            width: root.width
            height: root.height
            color: "black"
            Camera {
                id: _camera
                onError: {
                    console.log("error....", errorCode, errorString)
                }
                flash.mode: Camera.FlashOff
                exposure {
                    exposureCompensation: -1.0
                    exposureMode: Camera.ExposurePortrait
                }
                imageCapture {
                    onImageSaved: { //自动保存到临时目录
                        console.log("ImageSaved....", requestId, path)
                    }
                    onImageCaptured: {
                        console.log("Captured...", requestId, preview)
                        img.source = preview
                        img.visible = true
                        cameraItem.visible = false
                    }
                    onCaptureFailed: {
                        console.log("faild...",requestId, message)
                    }
                }

            }
            VideoOutput{
                id: vot
                anchors.fill: parent
                source: _camera
                focus: visible
                orientation: {
                    if(Qt.platform.os === "ios" && camera.position === Camera.FrontFace){
                        return 90;
                    }
                    return -90;
                }
            }
            Rectangle {
                width: root.width
                height: Utl.dp(50)
                anchors.bottom: parent.bottom
                color: "black"
                opacity: 0.8

                Button {
                    width: Utl.dp(45)
                    height: Utl.dp(30)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Utl.dp(25)
                    label.color: "white"
                    label.text: qsTr("取消")
                    onClicked: {
                        cameraItem.visible = false
                    }
                }

                Button {
                    width: Utl.dp(40)
                    height: Utl.dp(40)
                    radius: width / 2
                    anchors.centerIn: parent
                    color: "white"
                    onClicked: {
                        _camera.imageCapture.capture();
                    }
                }
            }
        }
    }
}

