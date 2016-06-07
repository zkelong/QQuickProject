import QtQuick 2.0
import "font.js" as FontUtl

/**
* 饼图：传入每分的颜色值和占比
*/

Rectangle {
    id: root
    width: parent.width; height: Utl.dp(120)

    property alias canvas: canvas
    property double beginAngle: -Math.PI * 3 / 4
    property double endAngle: 0
    property string strokeColor: "white"

    function draw(pieData) {
        var str = JSON.stringify(pieData)
        console.log("str..........xx.", str)
        if(pieData == null || pieData.lenght < 1)
            return
        for(var i = 0; i < pieData.length; i++) {
            listModel.append(pieData[i])
        }
        canvas.requestPaint();
    }

    Canvas {
        id: canvas
        width: parent.height * 2; height: width
        anchors.right: parent.horizontalCenter; anchors.rightMargin: -parent.height/2 + Utl.dp(16)
        anchors.verticalCenter: parent.verticalCenter
        smooth: true
        antialiasing: true
        scale: 0.5
        onPaint: {
            var ctx = canvas.getContext("2d");
            ctx.ineWidth = 8;
            if(listModel.count < 1)
                return
            var drawedAngle = 0
            for(var i = 0; i < listModel.count; i++) {
                console.log("draw................",listModel.get(i).value)
                ctx.beginPath();
                if(i == listModel.count - 1) {
                    root.endAngle = root.beginAngle + Math.PI * 2 - drawedAngle
                } else {
                    root.endAngle = root.beginAngle + Math.PI * 2 * listModel.get(i).value
                    drawedAngle += Math.PI * 2 * listModel.get(i).value
                }
                getSectorPath(context, canvas.width/2, canvas.width/2, canvas.height/2, root.beginAngle, root.endAngle, false);
                ctx.strokeStyle = strokeColor
                ctx.fillStyle = listModel.get(i).xcolor

                ctx.fill();
                ctx.stroke();
                root.beginAngle = root.endAngle
            }
        }
    }

    ListView {
        id: list
        anchors.left: parent.horizontalCenter; anchors.leftMargin: Utl.dp(8) //-parent.height/2 + Utl.dp(10)
        anchors.top: parent.top;
        clip: true
        height: parent.height; width: parent.width - parent.height
        model: listModel
        delegate: listDelegate
    }

    ListModel {
        id: listModel
    }

    Component {
        id: listDelegate
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height + Utl.dp(5)

            Rectangle {
                id: rect
                anchors.top: parent.top; anchors.topMargin: Utl.dp(5)
                anchors.left: parent.left;
                width: Utl.dp(15); height: Utl.dp(15)
                color: xcolor
            }
            Text {
                anchors.left: rect.right; anchors.leftMargin: Utl.dp(5)
                anchors.verticalCenter: rect.verticalCenter
                font.pointSize: FontUtl.FontSizeSmallA
                maximumLineCount: 2
                elide: Text.ElideRight
                wrapMode:Text.WrapAnywhere
                color: "#6a6a6a"
                text: name + " " + valueText
            }
        }
    }

    /** 扇形
          * @param x 扇形圆心x左标
          * @param y 扇形圆心y坐标
          * @param r 扇形半径
          * @param angleBegin 扇形开始角度
          * @param angleEnd 扇形结束角度
          * @param ifAnticlockwise 是否是逆时针
          */
    function getSectorPath(ctx, x, y, r, angleBegin, angelEnd, ifAnticlockwise){
        try
        {
            console.log(x, y, r, angleBegin, angelEnd, ifAnticlockwise)
            ctx.arc(x, y, r, angleBegin, angelEnd, ifAnticlockwise);
            ctx.lineTo(x,y);
            ctx.closePath();
        } catch(e) {
            console.log(e)
        }
    }

}
