import QtQuick 2.0
import "../toolsbox/color.js" as Color

Rectangle {
    id: bar_bg
    height: Utl.dp(10)
    radius: height/2
    border.color: "black"
    color: "#545454"

    property string pColor: Color.GreenTheme
    property real progress: 0

    MouseArea {
        height: parent.height > Utl.dp(9) ? parent.height : Utl.dp(10)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        onClicked: {
            progress = mouseX / bar_bg.width
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
        x: progress * bar_bg.width - _rect.width / 2
        height: parent.height * 2
        width: height
        anchors.verticalCenter: parent.verticalCenter
        radius: height/2
        color: "white"
        onXChanged: {
            progress = (x + width/2) / bar_bg.width
        }
        MouseArea {
            anchors.fill: parent
            anchors.margins: -Utl.dp(4)
            drag.target: _rect
            drag.axis: Drag.XAxis
            drag.minimumX: -_rect.width / 2
            drag.maximumX: bar_bg.width - _rect.width / 2
        }
    }
}
