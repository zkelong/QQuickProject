import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"

View {
    id: root

    Flickable {
        width: parent.width
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        contentHeight: childrenRect.height

        Column {
            width: parent.width
            height: childrenRect.height

//            Image.Stretch - the image is scaled to fit
//            Image.PreserveAspectFit - the image is scaled uniformly to fit without cropping
//            Image.PreserveAspectCrop - the image is scaled uniformly to fill, cropping if necessary
//            Image.Tile - the image is duplicated horizontally and vertically
//            Image.TileVertically - the image is stretched horizontally and tiled vertically
//            Image.TileHorizontally - the image is stretched vertically and tiled horizontally
//            Image.Pad - the image is not transformed

            Image {
                width: 200
                source: "qrc:/res/refresh.png"
                fillMode: Image.Stretch
            }

            Image {
                id: img
                onStatusChanged: {
                        if(img.status == Image.Ready){  //加载成功，绘制到Canvas上
                            canvas1.width = img.width
                            canvas1.height = img.height
                            console.log("pic in ximgae read", img.source,canvas1.width,img.width,canvas1.height,img.height)
                            canvas1.requestPaint();
                        } else if(img.status == Image.Error){   //加载失败
                            root.picSaved("")   //加载失败，给个信号
                        }
                    }
                width: 200
                source: "qrc:/res/refresh.png"
                fillMode: Image.PreserveAspectFit
            }
            Image {
                width: 200
                source: "qrc:/res/refresh.png"
                fillMode: Image.PreserveAspectCrop
            }
            Image {
                width: 200
                source: "qrc:/res/refresh.png"
                fillMode: Image.Tile
            }
            Image {
                width: 200
                source: "qrc:/res/refresh.png"
                fillMode: Image.TileVertically
            }
            Image {
                width: 200
                source: "qrc:/res/refresh.png"
                fillMode: Image.TileHorizontally
            }
            Image {
                width: 200
                source: "qrc:/res/refresh.png"
                fillMode: Image.Pad
            }
        }
    }

    Canvas {
        id: canvas1
        anchors.bottom: parent.bottom

        onPaint: {
            var ctx = canvas1.getContext("2d"); //目前只有2d画笔，画笔是唯一的，需要画不同的颜色需要重新赋值颜色
            ctx.fillStyle="#00000000";
            ctx.fillRect(0, 0, img.width, img.height);
            context.drawImage(img, 0, 0, img.width+1, img.height+1);    //绘制图片到Canvas上；莫名黑边，高宽+1
        }
    }


    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
