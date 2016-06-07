import QtQuick 2.4
import QtMultimedia 5.4
import QKit 1.0

Rectangle {
    id:root
    width: parent.width
    height: parent.height
    color:"#000000"

    signal pickerClicked();

    property var delegate: null
    property bool capturing: false
    property bool showPickerBtn: false //是否显示相册按钮
    property bool editable: false //是否可编辑

    //http://doc.qt.io/qt-5/qml-qtmultimedia-cameracapture.html
    property alias imageCapture: camera.imageCapture

    function editDone(isCancel, path, requestId) {
        if(!isCancel){
            if(delegate && delegate.imageSaved){
                delegate.imageSaved(requestId, path)
            }
        }
    }

    VideoOutput {
        id:output
        source: camera
        focus : visible
        width: parent.width
        height: parent.height
        fillMode: VideoOutput.PreserveAspectCrop

        orientation: {
            if(Qt.platform.os === "ios" && camera.position === Camera.FrontFace){
                return 90;
            }

            return -90;
        }

        Camera {
            id: camera
            captureMode: Camera.CaptureStillImage
            imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
            exposure {
                exposureCompensation: -1.0
                exposureMode: Camera.ExposurePortrait
            }

            flash.mode: Camera.FlashOff

            imageCapture {
                onCaptureFailed: {
                    root.capturing = false;
                    if(delegate && delegate.captureFailed){
                        delegate.captureFailed(requestId, message)
                    }
                }
                onImageCaptured: {
                    root.capturing = false;
//                    if(delegate && delegate.imageCaptured){
//                        if(Qt.platform.os === "ios"){
//                            preview = FileTools.rotateImage(preview, 90);
//                        }
//                        delegate.imageCaptured(requestId, preview)
//                    }
                }
                onImageSaved: {
                    root.capturing = false;
                    if(Qt.platform.os === "ios"){
                        path = FileTools.rotateImage(path, 90);
                    }

                    if(!editable) {
                        if(delegate && delegate.imageSaved){
                            delegate.imageCaptured(requestId, "file:///" + path)
                            delegate.imageSaved(requestId, path)
                        }
                    } else {
                        var editor = editorCmp.createObject(root);
                        editor.requestId = requestId;
                        editor.imageUrl = "file:///" + path;
                        editor.done.connect(editDone);
                    }
                }
            }
        }
    }

    Component {
        id:editorCmp
        ImageEditor{

        }
    }

    Rectangle{
        id:bottomGroup
        width: parent.width
        height: K.dp(80)
        anchors.bottom: parent.bottom
        color: "#61000000"

        BaseButton{
            id:cancelBtn
            width: K.dp(60)
            height: K.dp(30)
            label.color: "#ffffff"
            label.text: qsTr("取消")
            label.font.pointSize: 13
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; anchors.leftMargin: K.dp(10)

            onClicked: {
                camera.imageCapture.cancelCapture()
                if(delegate && delegate.captureCanceled){
                    delegate.captureCanceled()
                }                
            }
        }

        BaseButton{
            id:actionBtn
            width: K.dp(60)
            height: actionBtn.width
            anchors.centerIn: parent
            radius: actionBtn.width/2
            color: actionBtn.pressed? "#cccccc":"#ffffff"

            border.color:"#88777777"
            border.width: K.dp(5)

            onClicked: {
                if(root.capturing)
                    return;
                root.capturing = true;
                camera.imageCapture.capture()
            }
        }

        BaseButton{
            id:pickerBtn
            width: K.dp(60)
            height: K.dp(30)
            visible: root.showPickerBtn
            label.color: "#ffffff"
            label.text: qsTr("相册")
            label.font.pointSize: 13
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: K.dp(10)

            onClicked: {
                root.pickerClicked();
            }
        }
    }

    ImageButton{//摄像头前后旋转
        id:cameraRotate
        width: K.dp(27)
        height: K.dp(27)
        imageSource: "./drawable-xxhdpi/camera_rotate.png"

        anchors.top: parent.top; anchors.topMargin: K.isTranslucentStatusBar()? K.dp(30) : K.dp(10)
        anchors.right: parent.right; anchors.rightMargin: K.dp(10)

        onClicked: {
            if (camera.position === Camera.FrontFace){
                camera.position = Camera.BackFace
            } else {
                camera.position = Camera.FrontFace;
            }
        }
    }

}

