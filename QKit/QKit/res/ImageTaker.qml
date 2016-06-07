import QtQuick 2.0

Rectangle {
    id:root
    color:"black"
    width: parent.width
    height: parent.height

    /*
      selectedItems 选中的照相信息数组(失败或取消返回空数组),其元素包含以下属性
      preview: 预览图id
      path: 原图路径
    */
    signal doneSelected(var selectedItems)

    property bool multipleSelected: false //是否支持多选
    property Component pickerComponent: pickerCmp
    property ImagePicker picker: null
    property ImageCapture capturer: null

    ImageCaptureDelegate{
        id:cDelegate
        property string tempPreview: ""
        onCaptureCanceled: {
            root.doneSelected([]);
        }

        onCaptureFailed: {
            root.doneSelected([]);
        }

        onImageCaptured:{
            tempPreview = preview;
        }

        onImageSaved: {
            root.doneSelected( [ {preview:tempPreview, path:path} ] );
        }
    }

    Component.onCompleted: {
        var obj = pickerComponent.createObject(flip);
        flip.front = obj;
        root.picker = obj;
        obj.cameraClicked.connect(flip.showBack)
        obj.doneSelected.connect(root.doneSelected)
    }

    Flipable{
        id:flip
        property bool isFront: true

        anchors.fill: parent

        function showFront() {
            rot.angle=0;
            isFront = true;
        }

        function showBack() {
            if(!root.capturer){
                var obj = capturerCmp.createObject(flip);
                flip.back = obj;
                root.capturer = obj;
            }

            rot.angle=180;
            isFront = false;
        }

        transform: Rotation {
            id: rot
            origin.x: root.width/2;
            origin.y:100;
            axis.x:0; axis.y:1; axis.z:0
            angle:0

            Behavior on angle { PropertyAnimation{} }
        }
    }

    Component{
        id:pickerCmp
        ImagePicker{
            anchors.fill: parent
            showCameraBtn: true
            visible: flip.isFront
            multipleSelected:root.multipleSelected
        }
    }

    Component{
        id:capturerCmp
        ImageCapture{
            anchors.fill: parent
            delegate: cDelegate
            visible: !flip.isFront
            showPickerBtn: true
            onPickerClicked: {
                flip.showFront();
            }
        }
    }
}

