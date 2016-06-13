import QtQuick 2.0
import "../toolsbox/color.js" as Color

//调节进度，返回数字

Item {
    id: root
    height: Utl.dp(8)

    property alias barHeight: rect_bg.height    //条的高度
    property alias button: rect_btn     //按钮

    MouseArea {
        height: parent.height
        width: parent.width
        onClicked: {
            if(mouse.x >= parent.width - rect_btn.width) {
                rect_btn.x = parent.width - rect_btn.width
            } else {
                rect_btn.x = mouse.x
            }
        }
    }

    //背景
    Rectangle {
        id: rect_bg
        height: parent.height - Utl.dp(3)
        radius: height/2
        anchors.verticalCenter: parent.verticalCenter
        color: "#d2d2d2"
    }

    //进度
    Rectangle {
        height: rect_bg.height
        width: rect_btn.x
        color: "#666666"
    }

    //按钮
    Rectangle {
        id: rect_btn
        x: 0
        height: root.height
        width: height
        radius: width/2
        border.color: Color.LineGray
        onXChanged: {
            console.log("x.........", x, x/(root.width-parent.width))
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent;
            drag.axis: "XAxis"
            drag.minimumX: 0
            drag.maximumX: root.width - parent.width
            drag.filterChildren: true
        }
    }
}

