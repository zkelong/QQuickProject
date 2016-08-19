import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"
import "basicGraphics.js" as Bg

View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "ClipImage"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Rectangle {
        id: rect1
        anchors.top: navbar.bottom
        width: parent.width; height: parent.height / 3.3

        Canvas {
            id: canvas1
            visible: false

            property var imageData: null
            property bool loadReady: false  //加载完成
            property string savePath: ""    //保存地址

            onPaint: {
                var ctx = canvas1.getContext("2d"); //目前只有2d画笔，画笔是唯一的，需要画不同的颜色需要重新赋值颜色
                ctx.fillStyle="#000000";
                ctx.fillRect(0, 0, width,height);
                if(imageData != null){
                    context.drawImage(img,0,0,width,height);
                }
            }
            onImageDataChanged: {   //绘制
                if(imageData != null) {
                    console.log("开始绘制xxx", new Date().getTime())
                    requestPaint();
                }
            }
            onImageLoaded: {    //绘制图片
                console.log("绘制完成。1111。。")
                if(imageData != null) {
                    var path = "e:/"+new Date().getTime()+".png"
                    console.log("path...", path)
                    //root.save(path)
                }
            }
            onPainted: {    //绘制完成保存
                console.log("绘制完成。。。")
                if(imageData != null) {
                    savePath = "e:/"+new Date().getTime()+".png"
                    loadReady = true
                }
            }
            onLoadReadyChanged: {
                if(loadReady) {
                    console.log("path...", savePath)
                    //canvas1.save(savePath)
                    loadReady = false
                }
            }
        }
    }

    Image {
        id: img
        width: 280
        visible: false
        fillMode: Image.PreserveAspectFit
        source: "qrc:/res/a4.jpg"
        onStatusChanged: {
            if(img.status == Image.Ready){
                canvas1.width = img.width
                canvas1.height = img.height
                canvas1.imageData = img
                //canvas1.requestPaint()
            }
        }
    }

    Image {
        id: img2
        width: 280
        anchors.top: rect1.bottom
        fillMode: Image.PreserveAspectFit
        source: "qrc:/res/a2.jpg"
    }

    Rectangle {
        id: rect2
        anchors.top: img2.bottom
        width: parent.width; height: parent.height / 3
        color: "blue"

        Canvas {
            id: canvas12
            width: 200; height: 300

            property var imageData: null
            property bool loadReady: false  //加载完成
            property string savePath: ""    //保存地址

            Component.onCompleted: {
                loadImage("http://img2.3lian.com/2014/f2/144/d/59.jpg")
            }

            onPaint: {
//                var ctx = canvas12.getContext("2d"); //目前只有2d画笔，画笔是唯一的，需要画不同的颜色需要重新赋值颜色
//                ctx.fillStyle="#000000";
//                ctx.fillRect(0, 0, width,height);
//                ctx.drawImage("http://img2.3lian.com/2014/f2/144/d/59.jpg",0,0,width,height);
                var ctx = getContext("2d")

                // 绘制图像
                ctx.drawImage('http://img2.3lian.com/2014/f2/144/d/59.jpg', 10, 10)

                // 保存当前状态
                ctx.save()
                // 平移坐标系
                ctx.translate(100,0)
                ctx.strokeStyle = 'red'
                // 创建裁剪范围
                ctx.beginPath()
                ctx.moveTo(10,10)
                ctx.lineTo(55,10)
                ctx.lineTo(35,55)
                ctx.closePath()
                ctx.clip()  // 根据路径裁剪
                // 绘制图像并应用裁剪
                ctx.drawImage('http://img2.3lian.com/2014/f2/144/d/59.jpg', 10, 10)
                // 绘制路径
                ctx.stroke()
                // 恢复状态
                ctx.restore()
            }
//            onPainted: {
//                console.log("huizhi wan cheng ...")
//                loadReady = true
//            }
//            onLoadReadyChanged: {
//                if(loadReady)
//                    canvas12.save("e:/test.png")
//            }
        }
    }
}
