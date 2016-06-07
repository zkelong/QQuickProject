import QtQuick 2.4
import QtQuick.Controls 1.3
import QKit 1.0
import QKit.style 1.0

ApplicationWindow {
    title: qsTr("QKit")
    width: 480
    height: 640
    visible: true

    FileDownloader{
        id:downloader
        url: "http://192.168.2.76:3000/2015_06_11/aw7yv244yauw_QQAAAAAAAA.png"
        onFinished: {
            console.log("savePath = " + savePath)
            img.source = "file:///" + savePath;
        }

        onError: {
            console.log("errorMsg = " + errorMsg)
        }
    }

    Image{
        id:img
        asynchronous: true
//        source: "image://cache/http://192.168.2.76:3000/2015_06_11/aw7yv244yauw_QQAAAAAAAA.png"
        width: 80; height: 80
        Component.onCompleted: downloader.start()
    }


/*
    ImageTaker{
        id:taker
        anchors.fill: parent
        multipleSelected:true
        onDoneSelected:{
            console.log("selected:" + selectedItems)
        }
    }

    Drawable{
        id:cl
        //source:"#ff00ff"
        anchors.fill: parent
        MouseArea{
            anchors.fill: parent
            onClicked: {
//                av.open()
                picker.visible = true;
            }
        }
    }

    AlertView{
        id:av
        message:"test message test messagetest messagetest messagetest "
        buttons: ["取消"]
    }

    ImagePicker{
        id:picker
        anchors.fill: parent
        visible:false

        onDoneSelected:{
            picker.visible = false;
            console.log("#######" + selectedItems)
        }
    }

*/

}
