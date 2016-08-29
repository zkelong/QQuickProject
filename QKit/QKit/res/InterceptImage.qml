import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1

Rectangle{
    id:root
    anchors.fill: parent
    color: "black";
    property var source;
    property alias image:img
    property var path
    property int i:0
    signal isSave()
    property real picWHRatio: 0 //图片宽高比例
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

            pinch.maximumScale: 5;
            pinch.minimumScale: 0.1;

            onPinchUpdated: {
                console.log("scale = " + pinch.scale)
                if(pinch.scale>1) {
                    if((img.width+Utl.dp(10)*pinch.scale)/flick.width >= 3)
                        return
                    img.width+= Utl.dp(10)*pinch.scale
                    img.height = img.width / picWHRatio
                }else{
                    if((img.width-Utl.dp(10)/pinch.scale)<flick.width)
                        return
                    img.width-= Utl.dp(10)/pinch.scale
                    img.height = img.width / picWHRatio
                }
            }

            onPinchFinished: {

                flick.returnToBounds()
//                  center()
            }

            Image {
                id: img;

                anchors.centerIn: parent
                onStatusChanged: {
                    if(status === Image.Ready){
                        imgResize.start();
                    }

                }

                Timer {
                    id:imgResize
                    interval: 200
                    repeat: false
                    running: false
                    onTriggered: {
                        var w1 = root.width;
                        var h1 = img.sourceSize.height*(root.width/img.sourceSize.width);

                        if(h1 < selection.height){
                            w1 *= (selection.height/h1);
                            h1 = selection.height;
                        }

                        img.width = w1;
                        img.height = h1;                        
                        picWHRatio = w1/h1
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        flick.returnToBounds()
                        console.log(flick.contentWidth)
                        console.log(flick.contentHeight)
                    }

                    onDoubleClicked: {
                        if(img.width/img.sourceSize.width >= 3) {
                            img.width=root.width
                            img.height = img.width / picWHRatio
                        } else {
                            img.width*=1.5
                            img.height = img.width / picWHRatio
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
        border.color: "white"
        z:10
        anchors.centerIn: parent
    }
    Rectangle{
        width: parent.width
        anchors.top:parent.top
        anchors.bottom: selection.top
        color: "#80000000"
    }
    Rectangle{
        width: parent.width
        anchors.top:selection.bottom
        anchors.bottom: actionPanel.top
        color: "#80000000"
    }


    Timer {
        id:saveLater
        interval: 100
        repeat: false
        running: false
        onTriggered: {
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
            busy.running = false;
            busy.visible = false;
        }
    }
    Rectangle {
        id: actionPanel;
        width: parent.width
        height: Utl.dp(72.5)
        anchors.bottom: parent.bottom;
        color: "#80000000"
        z: 5;
        BaseButton {
            id:saveBtn
            width: Utl.dp(40)
            height: Utl.dp(40)
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin:Utl.dp(15)
            label.font.pointSize: 18
            label.text:qsTr("确定")
            label.color: "white"
            onClicked: {
                busy.visible = true;
                busy.running = true;
                saveLater.start();
            }
        }


        BaseButton {
            id:cancelBtn
            width: Utl.dp(40)
            height: Utl.dp(40)
            anchors.left: parent.left
            anchors.leftMargin:Utl.dp(15)
            anchors.verticalCenter: parent.verticalCenter
            label.text: qsTr("取消")
            label.font.pointSize: 18
            label.color: "white"
            onClicked:{
                root.visible=false
            }
        }
    }

    BusyIndicator {
        id:busy
        width: Utl.dp(40)
        height: Utl.dp(40)
        anchors.centerIn: parent
        running: false
        visible:false
        style: BusyIndicatorStyle {
                indicator: Image {
                    source: "./drawable-xxhdpi/loading.png"
                    RotationAnimator on rotation {
                        running:true
                        loops: Animation.Infinite
                        duration: 1000
                        from: 0 ; to: 360
                    }
                }
            }
    }
}
