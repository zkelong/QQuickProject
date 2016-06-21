import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"
import "../net"

View {
    id: root

    Column {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10

        Rectangle { //section1
            anchors.left: parent.left
            anchors.right: parent.right
            height: (parent.height - 20 - titleBar.height) / 3            

            Image {
                anchors.top: parent.top
                anchors.fill: parent;
                fillMode: Image.PreserveAspectFit;
                source: "qrc:/res/1.jpg"
            }

            Text {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 14
                text: qsTr("资源图片:")
            }
        }

        Rectangle { //section2
            anchors.left: parent.left
            anchors.right: parent.right
            height: (parent.height - 20 - titleBar.height) / 3

            Image {
                anchors.top: parent.top
                anchors.fill: parent;
                fillMode: Image.Pad;
                source: "file:///E:/QtSpace/QtQml/QtQuick/res/10.jpg"
            }

            Text {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 14
                text: qsTr("本地图片:")
            }
        }
        Rectangle { //section3
            anchors.left: parent.left
            anchors.right: parent.right
            height: (parent.height - 20 - titleBar.height) / 3

            Image {
                id: img
                anchors.top: parent.top
                width: parent.width
                fillMode: Image.PreserveAspectFit
                source: "http://img2.3lian.com/2014/f2/144/d/59.jpg"
            }

            Text {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 14
                text: qsTr("网络图片-瀑布流") + "width: " + img.width + " height: " + img.height
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.navigationView.push(waterfall)
            }

        }
    }

    Component {
        id: waterfall
        PicWaterfall{}
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}

/*
Image fillMode:
Image.Stretch - the image is scaled to fit 默认平铺
Image.PreserveAspectFit - the image is scaled uniformly to fit without cropping 缩放均匀，无裁剪
Image.PreserveAspectCrop - the image is scaled uniformly to fill, cropping if necessary 均匀缩放填充，裁剪
Image.Tile - the image is duplicated horizontally and vertically  水平，垂直重复
Image.TileVertically - the image is stretched horizontally and tiled vertically 水平拉伸、垂直平铺
Image.TileHorizontally - the image is stretched vertically and tiled horizontally  垂直拉伸、水平平铺
Image.Pad - the image is not transformed  图片不改变
*/
