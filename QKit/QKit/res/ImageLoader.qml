import QtQuick 2.0
import QKit 1.0

Rectangle {
    id:root
    property string defaultSource: ""  //默认图片
    property string source: "" //要加载的图片地址
    property alias cache: img2.cache
    property alias image: img2


    onSourceChanged: {
        img.visible = true;
        if(root.source.indexOf("http") == 0){
            downloader.stop();
            downloader.url = root.source;
            downloader.start();
        } else {
            img2.source = root.source;
        }        
    }

    FileDownloader{
        id:downloader
        onFinished: {
            if(savePath && savePath.length){
                img2.source = "file:///" + savePath;
            }
        }

        onError: {
            console.log("errorMsg = " + errorMsg)
        }
    }

    color: "transparent"

    Image{
        id:img
        anchors.fill: parent
        source: defaultSource
    }

    Image{
        id:img2
        asynchronous: true
        anchors.fill: parent
        onStatusChanged: {
            if(img2.status === Image.Ready){
                img.visible = false;
            }
        }
    }

}

