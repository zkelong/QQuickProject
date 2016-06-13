import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QKit 1.0
import "../controls"
import "../api"
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color
import "../toolsbox/tools.js" as Tools
Flickable {
    id: flick
    contentWidth: flick.width
    contentHeight: flick.height
    boundsBehavior: Flickable.StopAtBounds

    property alias image: img.image
    property alias imageUrl: img.source
    property alias flickInteractive: flick.interactive

    property double minScale: 1
    property double maxScale: 2
    property real minWidth: flick.width  //最小宽度
    property real minHeight: flick.height   //最小高度

    //图片初始尺寸
    property real imgInitialWidth: 0
    property real imgInitialHeight: 0
    property real imgWidth: 0
    property real imgHeight: 0

    signal clicked()  //单击

    ImageBusyLoader {
        id: img
        width: imgWidth > flick.width ? imgWidth + Utl.dp(10) : flick.width
        height: imgHeight > flick.height ? imgHeight + Utl.dp(10) : flick.height
        anchors.centerIn: parent
        image.fillMode: Image.PreserveAspectFit
        image.sourceSize.width: 1280    //不要太大
        image.sourceSize.height: 1280
        source: imageUrl
        onPicReadyChanged: {
            if(picReady) {
                pinchA.enabled = true
                var whRate = image.width/image.height
                if(image.height > flick.height - Utl.dp(10)) {
                    image.height =  flick.height - Utl.dp(10)
                    image.width = image.height * whRate
                }
                if(image.width > flick.width - Utl.dp(10)) {
                    image.width = flick.width - Utl.dp(10)
                    image.height = image.width / whRate
                }
                imgInitialWidth = imgWidth = image.width
                imgInitialHeight = imgHeight = image.height
            }
        }
    }

    PinchArea {
        id: pinchA
        enabled: false
        width: Math.max(flick.contentWidth, flick.width)
        height: Math.max(flick.contentHeight, flick.height)

        property real initialWidth
        property real initialHeight

        pinch.dragAxis: Pinch.XAndYAxis//Pinch.NoDrag

        onPinchStarted: {
            initialWidth = imgWidth
            initialHeight = imgHeight
        }

        onPinchUpdated: {   //变化
            if(initialWidth * pinch.scale < imgInitialWidth * maxScale) {
                if(initialWidth * pinch.scale > imgInitialWidth * minScale) {
                    console.log("onPich...")
                    imgWidth = initialWidth * pinch.scale
                    imgHeight = initialHeight * pinch.scale
                    img.image.width = imgWidth
                    img.image.height = imgHeight
                    flick.resizeContent(imgWidth + Utl.dp(10), imgHeight + Utl.dp(10), flick.center)
                    img.anchors.centerIn = pinchA
                }
            }
        }
        onPinchFinished: {
            // Move its content within bounds.
            flick.returnToBounds()
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                clickTime.start()
            }
            onDoubleClicked: {
                clickTime.stop()
                if(!img.picReady)
                    return
                if(imgWidth != imgInitialWidth) { //拉伸状态
                    resetNormalSize()
                } else {
                    imgWidth = imgInitialWidth * maxScale
                    imgHeight = imgInitialHeight * maxScale
                    img.image.width = imgWidth
                    img.image.height = imgHeight
                    flick.resizeContent(imgWidth + Utl.dp(10), imgHeight + Utl.dp(10), flick.center)
                    flick.returnToBounds()
                    img.anchors.centerIn = parent
                }
            }
        }
    }

    Timer{
        id: clickTime
        interval: 350
        running: false
        repeat: false
        onTriggered: {
            flick.clicked()
        }
    }

    //变回到初始的尺寸
    function resetNormalSize() {
        if(!img.picReady)
            return
        if(imgWidth != imgInitialWidth) { //拉伸状态
            imgWidth = imgInitialWidth
            imgHeight = imgInitialHeight
            img.image.width = imgWidth
            img.image.height = imgHeight
            flick.resizeContent(flick.width, flick.height, flick.center)
            flick.returnToBounds()
        }
    }
}
