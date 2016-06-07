import QtQuick 2.0
import "../controls/color.js" as Color

/**
* 选择按钮
*/

Rectangle {
    id: root
    width: Utl.dp(34)
    height: Utl.dp(20)
    radius: height/2
    color: select ? Color.GreenTheme : "#a0a0a0"

    property bool select: false
    property alias circleWidth: circle.width
    property bool changeable: true

    Component.onCompleted: {
        if(select) {
            circle.x = root.width - circle.width - Utl.dp(2)
        } else {
            circle.x = Utl.dp(2)
        }
    }

    Rectangle {
        id: circle
        width: parent.height - Utl.dp(4)
        height: width
        radius: height/2
        anchors.verticalCenter: parent.verticalCenter
        color: Color.White
    }
    MouseArea {
        id: mouseA
        anchors.fill: parent
        visible: changeable
        onClicked: {
            changeSelect()
        }
    }

    PropertyAnimation {
        id: animation
        target: circle
        properties: "x"
        duration: 200
        from: circle.x
        to: select ? Utl.dp(2) : root.width - circle.width - Utl.dp(2)
        onStarted: mouseA.enabled = false
        onStopped: {
            mouseA.enabled = true
            select = !select
        }
    }
    function changeSelect() {
        animation.start()
    }
}

