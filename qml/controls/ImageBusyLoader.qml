import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QKit 1.0
import "../toolsbox/color.js" as Color

/**
* 图片-加载器，显示加载中的busy图标
*/

Rectangle {
    id:root
    color: Color.Clear

    property string erroSource: "qrc:/res/loadFailure.png"  //默认图片
    property string source: "" //要加载的图片地址
    property alias cache: img.cache    //缓存--默认为true
    property alias image: img

    property bool picReady: false   //图片加载完成


    onSourceChanged: {
        if(root.source.indexOf("http") == 0){
            downloader.stop();
            downloader.url = root.source;
            downloader.start();
        } else {
            img.source = root.source;
        }
    }

    FileDownloader{     //图片缓存qkit里边实现的
        id:downloader
        onFinished: {
            console.log("savePath = " + savePath)
            img.source = "file:///" + savePath;
        }

        onError: {
            console.log("errorMsg = " + errorMsg)
        }
    }

    Image{  //图片
        id:img
        asynchronous: true
        anchors.centerIn: parent
        onStatusChanged: {
            if(img.status === Image.Ready){ //还有两状态：Image.Loading；Image.Error
                busy.running = false
                picReady = true
            }
        }
    }

    BusyIndicator {
        id:busy
        width: Utl.dp(40)
        height: Utl.dp(40)
        anchors.centerIn: parent
        running: true
        visible: running
        style: BusyIndicatorStyle {
            indicator: Image {
                source: "qrc:/res/loading.png"
                RotationAnimator on rotation {
                    running: true
                    loops: Animation.Infinite
                    duration: 1000
                    from: 0 ; to: 360
                }
            }
        }
    }
}

