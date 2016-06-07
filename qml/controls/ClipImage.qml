import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1
import QKit 1.0
import "../controls"
import "../controls/color.js" as Color
import "../controls/font.js" as FontUtl

/**
*图片截图的***
*/

Rectangle {
    id:root
    z:10    //保证图层在最上边
    anchors.fill: parent
    color: Color.Black;

    property var source;    //资源
    property alias image: img
    property bool screenshot: true
    property var path
    property int i: 0
    signal isSaved(var picPath)


    onSourceChanged: {
        img.source=source
    }

    Image {
        id: img;
        anchors.fill: parent;
        fillMode: Image.PreserveAspectFit;
        visible: false;
        asynchronous: true; //一步加载图片
        onStatusChanged: {
            if(status == Image.Ready){
                console.log("image loaded");
                console.log("image source: "+source);
                if(screenshot){
                    mask.recalc();
                }else{
                    if(sourceSize.width< width && sourceSize.height < height){
                        fillMode=Image.Pad
                    }
                    img.visible=true
                }
            }
        }
    }

    FileDialog {
        id: fileDialog;
        title: "Please choose an Image File";
        nameFilters: ["Image Files (*.jpg *.png *.gif)"];
        onAccepted: {
            img.source = fileDialog.fileUrl;
        }
    }


    Canvas {
        id: forSaveCanvas;
        width: 300;
        height: 300;
        contextType: "2d";
        visible: false;
        z: 2;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.margins: 4;

        property var imageData: null;
        onPaint: {
            var ctx = getContext("2d");
            ctx.fillStyle="#000000";
            ctx.fillRect(0, 0, width,height);
            if(imageData != null){
                context.drawImage(imageData,0,0,width+1,height+1);
            }
        }

        function setImageData(data){
            imageData = data;
            requestPaint();
        }
    }

    Canvas {
        id: mask;
        anchors.fill: parent;
        z: 1;
        property real w: width;
        property real h: height;
        property real dx: 0;
        property real dy: 0;
        property real dw: 0;
        property real dh: 0;
        //        property real frameX:aaaa.x //66;
        //        property real frameY:aaaa.y //66;

        function calc(){
            var sw = img.sourceSize.width;
            var sh = img.sourceSize.height;
            if(sw > 0 && sh > 0){
                if(sw <= w && sh <=h){
                    dw = sw;
                    dh = sh;
                }else{
                    var sRatio = sw / sh;
                    dw = sRatio * h;
                    if(dw > w){
                        dh = w / sRatio;
                        dw = w;
                    }else{
                        dh = h;
                    }
                }
                dx = (w - dw)/2;
                dy = (h - dh)/2;
            }
        }

        function recalc(){
            console.log("recalc")
            calc();
            requestPaint();
        }

        function getImageData(){
            return context.getImageData(selection.x,selection.y,
                                        selection.width,selection.height);
        }

        onPaint: {
            var ctx = getContext("2d");
            if(dw < 1 || dh < 1) {
                return;
            }
            ctx.clearRect(0, 0, width, height);
            ctx.drawImage(img, dx, dy, dw, dh);
            selection.visible=true
            var xStart =selection.x
            var yStart =selection.y
            ctx.save();
            ctx.fillStyle = "#a0000000";
            ctx.fillRect(0, 0, w, yStart);
            var yOffset = yStart + selection.height;
            ctx.fillRect(0, yOffset, w, h - yOffset);
            ctx.fillRect(0, yStart, xStart, selection.height);
            var xOffset = xStart + selection.width;
            ctx.fillRect(xOffset,yStart, w - xOffset,selection.height);
            ctx.beginPath();
            ctx.fill();
            ctx.stroke();
            ctx.closePath ();
            ctx.restore();
            forSaveCanvas.setImageData(mask.getImageData());
        }
    }
    Rectangle{
        id:selection
        width: parent.width
        height: width
        color:"#00000000"
        visible:false
        border.color:Color.White
        z:10
        anchors.centerIn: parent
    }
    MultiPointTouchArea {
        anchors.fill: parent;
        minimumTouchPoints: 1;
        maximumTouchPoints: 2;
        property var px;
        property var py;
        property var distance1
        property var distance2
        touchPoints:[
            TouchPoint{
                id: point1;
            },
            TouchPoint{
                id: point2;
            }
        ]
        onUpdated: {
            if(point2.pressed){
                distance2=Math.abs(point1.x-point2.x)*Math.abs(point1.y-point2.y)
                if((distance2-distance1)>200){
                    mask.dx=mask.dx-25
                    mask.dy=mask.dy-25
                    mask.dw=mask.dw+50
                    mask.dh=mask.dh+50
                }else if(mask.dw-50>=selection.width && mask.dh-50>=selection.height){
                    mask.dx=mask.dx+25
                    mask.dy=mask.dy+25
                    mask.dw=mask.dw-50
                    mask.dh=mask.dh-50
                }
            }else{
                if(mask.dx+(point1.x-px)<selection.x && (mask.dx+(point1.x-px)+mask.dw)>(selection.x+selection.width)){
                    mask.dx=mask.dx+(point1.x-px);
                }
                if(mask.dy+(point1.y-py)<selection.y && (mask.dy+(point1.y-py)+mask.dh)>(selection.y+selection.height)){
                    mask.dy=mask.dy+(point1.y-py);
                }
                px=point1.x
                py=point1.y
            }
            mask.requestPaint();
        }
        onReleased: {
            if(screenshot)
                actionPanel.visible = true;
        }
        onPressed: {
            px=point1.x
            py=point1.y
            distance1=Math.abs(point1.x-point2.x)*Math.abs(point1.y-point2.y)
            if(screenshot)
                actionPanel.visible = false;
        }
    }

    Rectangle {
        id: actionPanel;
        width: parent.width
        height: Utl.dp(72.5)
        anchors.bottom: parent.bottom;
        color:Color.TransBlack
        z: 5;
        Button {
            id:saveBtn
            width: Utl.dp(40)
            height: Utl.dp(40)
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin:Utl.dp(15)
            scaleOnPressed:false
            font.pointSize:FontUtl.FontSizeMidE
            container.anchors.centerIn:saveBtn
            label.text: screenshot?qsTr("确定"):qsTr("发送")
            onClicked: {
                if(screenshot){
                    path = K.runTimeCachePath()+"/selected"+(i++)+".png"
                    forSaveCanvas.save(path)
                }
                isSaved(path)
            }
        }
        //Button {
        //    width: Utl.dp(40)
        //    height: Utl.dp(40)
        //    anchors.horizontalCenter: parent.horizontalCenter
        //    anchors.verticalCenter: parent.verticalCenter
        //    scaleOnPressed:false
        //    font.pointSize: FontUtl.FontSizeMidE
        //    label.text: qsTr("打开")
        //    onClicked: fileDialog.open();
        //}
        Button {
            id:cancelBtn
            width: Utl.dp(40)
            height: Utl.dp(40)
            anchors.left: parent.left
            anchors.leftMargin:Utl.dp(15)
            anchors.verticalCenter: parent.verticalCenter
            scaleOnPressed:false
            font.pointSize: FontUtl.FontSizeMidE
            container.anchors.centerIn:cancelBtn
            label.text: qsTr("取消")
            onClicked:{
                root.visible=false
            }
        }
    }
}
