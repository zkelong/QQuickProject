import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1
import QKit 1.0
import "../controls"
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl

//截图
Rectangle{
    id:root
    anchors.fill: parent
    color: Color.Black;
    property var source;
    property alias image:img
    property var path
    property int i:0
    signal isSave()
    property real imgWidth;
    property real imgHeight;
    z:10
    onSourceChanged: {
        img.source=source
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth:img.width+(root.width-selection.width)
        contentHeight:img.height+(root.height-selection.height)
        contentX:Math.max((contentWidth-root.width)/2,0)
        contentY:Math.max((contentHeight-root.height)/2,0)
        PinchArea {
            id:pinch
            width: Math.max(flick.contentWidth, flick.width)
            height: Math.max(flick.contentHeight, flick.height)

            property real initialWidth
            property real initialHeight
            pinch.maximumScale: 5;
            pinch.minimumScale: 0.1;
            onPinchStarted: {
                initialWidth = img.width
                initialHeight = img.height
                pinch.accepted = true;
            }

            onPinchUpdated: {
                console.log("scale = " + pinch.scale)
                if(pinch.scale>1) {
                    if((img.width+Utl.dp(10)*pinch.scale)/flick.width >= 3)
                        return
                    img.width+= Utl.dp(10)*pinch.scale
                    img.height+= Utl.dp(10)*pinch.scale
                }else{
                    if((img.width-Utl.dp(10)/pinch.scale)<flick.width)
                        return
                    img.width-= Utl.dp(10)/pinch.scale
                    img.height-= Utl.dp(10)/pinch.scale
                }
            }

            onPinchFinished: {
                // Move its content within bounds.
                flick.returnToBounds()
            }

            Image {
                id: img;
                width: root.width
                height: img.sourceSize.height*(root.width/image.sourceSize.width)
                anchors.centerIn: parent
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        flick.returnToBounds()
                        console.log(flick.contentWidth)
                        console.log(flick.contentHeight)
                    }

                    onDoubleClicked: {
                        if(img.width/flick.width >= 3) {
                            img.width=root.width
                            img.height=img.sourceSize.height*(root.width/image.sourceSize.width)
                        } else {
                            img.width*=1.5
                            img.height*=1.5
                        }
                        center()
                    }
                }

            }
        }
    }

    function center(){
        flick.contentX=(flick.contentWidth-root.width)/2
        flick.contentY=(flick.contentHeight-root.height)/2
    }

    Rectangle{
        id:selection
        width: parent.width
        height: width
        color:"#00000000"
        visible:true
        border.color:Color.White
        z:10
        anchors.centerIn: parent
    }
    Rectangle{
        width: parent.width
        anchors.top:parent.top
        anchors.bottom: selection.top
        color:Color.TransBlack
    }
    Rectangle{
        width: parent.width
        anchors.top:selection.bottom
        anchors.bottom: actionPanel.top
        color:Color.TransBlack
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
            font.pointSize:FontUtl.FontSizeMidE
            container.anchors.centerIn:saveBtn
            label.text:qsTr("确定")
            onClicked: {
                path = K.runTimeCachePath() + "/selected" + (i++) + ".png"

                var scale = Math.min(img.width/img.sourceSize.width, img.height/img.sourceSize.height);
                var offsetX = 0;
                var offsetY = 0;
                if(selection.height > img.height) {
                    offsetY = (selection.height-img.height)/2
                }else if(selection.width > img.width){
                    offsetX = (selection.width-img.width)/2
                }
                var x = (flick.contentX - offsetX)/scale;
                var y = (flick.contentY - offsetY)/scale;
                var w = selection.width/scale;
                var h = selection.height/scale;

                console.log("scale=" + scale + " x=" + x + " y=" + y + " w=" + w + " h=" + h)

                FileTools.clipImageAndSave(img,x,y,w,h, path);
                isSave()
            }
        }


        Button {
            id:cancelBtn
            width: Utl.dp(40)
            height: Utl.dp(40)
            anchors.left: parent.left
            anchors.leftMargin:Utl.dp(15)
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: FontUtl.FontSizeMidE
            container.anchors.centerIn:cancelBtn
            label.text: qsTr("取消")
            onClicked:{
                root.visible=false
            }
        }
    }
}
