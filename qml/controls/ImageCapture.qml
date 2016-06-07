import QtQuick 2.4
import QtMultimedia 5.4

/**
*拍照
*/

View {
    id:root
    width: parent.width
    height: parent.height
    color:"#000000"
    hidenTabbarWhenPush: true

    property var delegate: null

    //http://doc.qt.io/qt-5/qml-qtmultimedia-cameracapture.html
    property alias imageCapture: camera.imageCapture

    VideoOutput {
        source: camera
        focus : visible
        width: parent.width
        height: parent.height
        fillMode: VideoOutput.PreserveAspectCrop
        orientation: camera.position == Camera.BackFace ?-90:90

        Camera {
            id: camera

            imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
            exposure {
                exposureCompensation: -1.0
                exposureMode: Camera.ExposurePortrait
            }
//            flash.mode: Camera.FlashRedEyeReduction
            flash.mode: Camera.FlashOff

            imageCapture {
                onCaptureFailed: {
                    if(delegate && delegate.captureFailed){
                        delegate.captureFailed(requestId, message)
                    }
                }
                onImageCaptured: {
                    if(delegate && delegate.imageCaptured){
                        delegate.imageCaptured(requestId, preview)
                    }
                }
                onImageSaved: {
                    if(delegate && delegate.imageSaved){
                        delegate.imageSaved(requestId, path)
                    }
                }
            }
        }
    }

    Rectangle{
        id:bottomGroup
        width: parent.width
        height: Utl.dp(60)
        anchors.bottom: parent.bottom
        color: "#88000000"

        Button{
            id:cancelBtn
            width: Utl.dp(60)
            height: Utl.dp(30)
            label.color: "#ffffff"
            label.text: qsTr("取消")
            label.font.pointSize: 14
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; anchors.leftMargin: Utl.dp(10)

            onClicked: {
                camera.imageCapture.cancelCapture()
                if(delegate && delegate.captureCanceled){
                    delegate.captureCanceled()
                }
                if(root.navigationView){
                    root.navigationView.pop()
                }
            }
        }

        Button{
            id:actionBtn
            width: Utl.dp(40)
            height: actionBtn.width
            anchors.centerIn: parent
            radius: actionBtn.width/2
            color: actionBtn.holding? "#fefefe":"#ffffff"

            border.color: actionBtn.holding? "#88007700" :"#88777777"
            border.width: Utl.dp(5)

            onClicked: {
                camera.imageCapture.capture()
            }
        }
    }

    Button{//摄像头前后旋转
        id:cameraRotate
        width: Utl.dp(27)
        height: Utl.dp(27)
        icon.normalSource: "qrc:/res/camera_rotate.png"
        icon.width: Utl.dp(27); icon.height: Utl.dp(27)

        anchors.top: parent.top; anchors.topMargin: Utl.dp(10)
        anchors.right: parent.right; anchors.rightMargin: Utl.dp(10)

        onClicked: {
            if (camera.position == Camera.FrontFace){
                camera.position = Camera.BackFace
            } else {
                camera.position = Camera.FrontFace;
            }
        }
    }

}

