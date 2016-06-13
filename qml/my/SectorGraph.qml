import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../ui/canvas/basicGraphics.js" as BG

Rectangle {
    id: root
    width: 50
    height: 50
//    color: "transparent"

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = canvas.getContext("2d")
            BG.getsectorPath(ctx, parent.width/2, parent.height/2, parent.width/2, 0, -Math.PI * 2 / 5, true);
            ctx.fillStyle = 'purple';
            ctx.fill();
        }
        visible: false
    }

    Rectangle {
        id: rect
        visible: false
        color: "blue"
        anchors.fill: parent
        MouseArea {
            id: mouseA
            anchors.fill: parent
            onClicked: {
                console.log("sector......in")
            }
        }

    }



    OpacityMask {
        anchors.fill: canvas
        source: rect
        maskSource: canvas

    }
}

