import QtQuick 2.0
import "../toolsbox/color.js" as Color

//调节进度，返回数字

Rectangle {
    id: bar_bg
    height: Utl.dp(8)
    radius: height/2
    border.color: "black"
    color: "#545454"

    property string pColor: Color.GreenTheme

    property real progress: 0

    MouseArea {
        height: parent.height > Utl.dp(9) ? parent.height : Utl.dp(10)
        width: parent.width
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        onClicked: {
            progress = (mouseX - bar_bg.width/2) / (bar_bg.width/2)
        }
    }

    Rectangle {
        height: parent.height
        width: _rect.x + _rect.width / 2
        radius: parent.radius
        anchors.verticalCenter: parent.verticalCenter
        x: 0
        color: pColor
    }

    Rectangle {
        id: _rect
        x: (progress * bar_bg.width/2 + bar_bg.width/2) - _rect.width/2
        height: parent.height * 2
        width: height
        anchors.verticalCenter: parent.verticalCenter
        radius: height/2
        color: "white"
        onXChanged: {
            bar_bg.progress = (x + width/2 - bar_bg.width/2) / (bar_bg.width/2)
        }
        MouseArea {
            anchors.fill: parent
            anchors.margins: -Utl.dp(4)
            drag.target: _rect
            drag.axis: Drag.XAxis
            drag.minimumX: -_rect.width / 2
            drag.maximumX: bar_bg.width - _rect.width / 2
            onDoubleClicked: {
                bar_bg.progress = 0
            }
        }
    }
}

