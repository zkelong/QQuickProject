import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

Rectangle{
    id:root
    width: parent.width
    height: parent.height

    signal  done(var isCancel, var imagePath);
    property string imageUrl: ""
    property string requestId: ""

    onImageUrlChanged: {
        console.log("******************" + imageUrl);
        flick.contentWidth = flick.width;
        flick.contentHeight = flick.height;
        canvas.loadImage(imageUrl);
    }


    Flickable {
        id:flick
        anchors.fill: parent
        property real imageScale: 1.0

        Canvas {
            id:canvas
            scale: pinch.scale * flick.imageScale
            anchors.centerIn: parent


            onImageLoaded: {
                console.log("******************* image loaded!")

                var ctx = getContext("2d");
                var img = ctx.createImageData(imageUrl);
                var w = /*Qt.platform.os === "ios" ? img.height : */img.width;
                var h = /*Qt.platform.os === "ios" ? img.width : */img.height;
                canvas.width = w;
                canvas.height = h;
                flick.imageScale = Math.min(flick.width/w, flick.height/h)

                canvas.requestPaint();
            }

            onPaint: {
                var ctx = getContext("2d");
                if (canvas.isImageLoaded(imageUrl)){
//                    if(Qt.platform.os === "ios"){
//                        ctx.fillStyle = "red"
//                        ctx.fillRect(0,0,canvas.width, canvas.height)
//                        ctx.save();
//                        ctx.rotate(Math.PI/2)
//                        ctx.drawImage(imageUrl, 0,-(canvas.width) )
//                        ctx.restore();
//                    } else
                    {
                        ctx.drawImage(imageUrl,0,0)
                    }

                }
            }
        }



        PinchArea {
            id:pinch
            anchors.fill: parent

            onPinchUpdated: {
                console.log("scale = " + pinch.scale)
                flick.contentX += pinch.previousCenter.x - pinch.center.x
                flick.contentY += pinch.previousCenter.y - pinch.center.y

                //flick.resizeContent(flick.width * pinch.scale, flick.height * pinch.scale, pinch.center)
            }
        }
    }

    Rectangle {
        id:layer
        anchors.fill: parent
        color:"#66000000"
    }

//    Rectangle {
//        id: box
//        anchors.centerIn: parent
//        width: parent.width * 0.8
//        height: box.width
//        border.width: K.dp(1)
//        border.color: "#ffffff"
//    }

//    ThresholdMask {
//        anchors.fill: layer
//        source: layer
//        maskSource: box
//        threshold: 0.4
//        spread: 0.2
//    }

    BaseButton{
        id:cancelBtn
        width: K.dp(60)
        height: K.dp(30)
        label.color: "#ffffff"
        label.text: qsTr("取消")
        label.font.pointSize: 13
        anchors.bottom: parent.bottom; anchors.bottomMargin: K.dp(40)
        anchors.left: parent.left; anchors.leftMargin: K.dp(10)

        onClicked: {
            done(true,"", requestId);
            root.destroy();
        }
    }

    BaseButton{
        id:doneBtn
        width: K.dp(60)
        height: K.dp(30)
        label.color: "#ffffff"
        label.text: qsTr("使用")
        label.font.pointSize: 13
        anchors.bottom: parent.bottom; anchors.bottomMargin: K.dp(40)
        anchors.right: parent.right; anchors.rightMargin: K.dp(10)

        onClicked: {
            var path = K.runTimeCachePath() + "/pic.jpg";
            console.log("**************" + canvas.save(path) );
            done(false, path, requestId)
        }
    }
}



