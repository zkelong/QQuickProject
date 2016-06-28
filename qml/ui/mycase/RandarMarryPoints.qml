import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

//随机的点
Rectangle {
    id: root
    color: "#11ff0000"

    //距离中心小距离
    property real sR: width/4
    //图片大小
    property real imgWidth: width/8
    //距离中心大距离
    property real bR: width/5

    onWidthChanged: {
        if(width > 0) {
            sR = width/4
            imgWidth = width/8
        }
    }

    //小圈
    Item {
        id: _item0
        anchors.fill: parent
        ScaleAnimationImage {
            id: img00
            width: imgWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: sR
        }
        ScaleAnimationImage {
            id: img01
            width: imgWidth
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: sR
        }
        ScaleAnimationImage {
            id: img02
            width: imgWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: sR
        }
        ScaleAnimationImage {
            id: img03
            width: imgWidth
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: sR
        }
    }

    Item {
        id: _item1
        anchors.fill: parent
        rotation: 45
        ScaleAnimationImage {
            id: img10
            rotation: -45
            width: imgWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: sR
        }
        ScaleAnimationImage {
            id: img11
            rotation: -45
            width: imgWidth
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: sR
        }
        ScaleAnimationImage {
            id: img12
            rotation: -45
            width: imgWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: sR
        }
        ScaleAnimationImage {
            id: img13
            rotation: -45
            width: imgWidth
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: sR
        }
    }
    //大圈
    property real rota: 45/2  //旋转角度
    Item {
        id: _item2
        anchors.fill: parent
        rotation: rota
        ScaleAnimationImage {
            id: img20
            rotation: -rota
            width: imgWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: bR
        }
        ScaleAnimationImage {
            id: img21
            rotation: -rota
            width: imgWidth
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: bR
        }
        ScaleAnimationImage {
            id: img22
            rotation: -rota
            width: imgWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: bR
        }
        ScaleAnimationImage {
            id: img23
            rotation: -rota
            width: imgWidth
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: bR
        }
    }
    property real rota1: (45/2)-45  //旋转角度
    Item {
        id: _item3
        anchors.fill: parent
        rotation: rota1
        ScaleAnimationImage {
            id: img30
            rotation: -rota1
            width: imgWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: bR
        }
        ScaleAnimationImage {
            id: img31
            rotation: -rota1
            width: imgWidth
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: bR
        }
        ScaleAnimationImage {
            id: img32
            rotation: -rota1
            width: imgWidth
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: bR
        }
        ScaleAnimationImage {
            id: img33
            rotation: -rota1
            width: imgWidth
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: bR
        }
    }

    Rectangle {
        id: rectC
        width: Utl.dp(20)
        height: Utl.dp(20)
        radius: width/2
        color: "red"
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("center...", rectC.x, rectC.y)
            }
        }
    }

}

