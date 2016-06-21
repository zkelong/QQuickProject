import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"

View {
    id: root

    Rectangle {  //位置变化
        id: rect0
        x: 100; y:300
        color: "orange"
        width: 100; height: 80
        border.width: 3
        radius: 4
    }

    MouseArea {  //位置变化
        anchors.fill: parent
        onClicked: {
            rect0.x = mouseX
            rect0.y = mouseY
        }
    }

    Rectangle {
        id: rect
        width: parent.width / 5; height: parent.width
        anchors.centerIn: parent
        border.width: 2
        color: "greenyellow"
        rotation: 0 //旋转

        MouseArea {
            anchors.fill: parent
            onClicked: {
                rect.rotation += 20
            }
        }
    }

    Rectangle {  //颜色变化
        id: rect1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: titleBar.bottom; anchors.topMargin: 20
        color: "#000"
        width: 100; height: 80
        border.width: 3
        radius: 4

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(rect1.color == "#000000") //颜色比较用六位数
                    rect1.color = "#ff0000"
                else if(rect1.color == "#ff0000")
                    rect1.color = "#00ff00"
                else if(rect1.color == "#00ff00")
                    rect1.color = "#0000ff"
                else
                    rect1.color = "#00000"
            }
        }
    }

    Rectangle {
        id: recta
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        width: 100; height: 80
        color: "#0da"
    }

    Rectangle { //消失-显示、透明度动画
        id: rectb
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.horizontalCenter
        width: 100; height: 80
        color: "#4d0"
        border.color: "black"
        opacity: 1.0  //透明度0.0~1.0

        property bool isDarker: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(recta.visible)
                    recta.visible = false
                else
                    recta.visible = true
                if(rectb.isDarker)
                    rectb.opacity += 0.1
                else
                    rectb.opacity -= 0.1
                if(rectb.opacity > 0.95)
                    rectb.isDarker = false
                if(rectb.opacity < 0.5)
                    rectb.isDarker = true
            }
        }
    }

    Rectangle {  //大小变化
        id: rect2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: 100; height: width
        color: "purple"

        property bool isBigger: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(rect2.isBigger)
                    rect2.width += 20
                else
                    rect2.width -= 20
                console.log(rect2.width)
                if(rect2.width == 300)
                    rect2.isBigger = false
                if(rect2.width == 100)
                    rect2.isBigger = true
            }
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
