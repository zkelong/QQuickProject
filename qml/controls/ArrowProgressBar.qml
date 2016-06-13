import QtQuick 2.4
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl

/**
  *有指示箭头的进度条，有数字显示
  */

Rectangle {
    height: progress.height + text.height + Utl.dp(5)
    property double maximumValue: 100 //最大值, 将会取value/maximumValue的结果做为百分比
    property double minimumValue: 0 //最小值,如果value小于此值，那么使用此值做为计算标准
    property double value: 0 //当前值
    property double percent: Math.max(value,minimumValue)/maximumValue //当前值和最大值的比值

    color: Color.Clear

    Rectangle{  //进度度条背景
        id:background
        height: Utl.dp(8)
        anchors.left: parent.left
        anchors.leftMargin: Utl.dp(5)
        anchors.right: parent.right
        anchors.rightMargin: Utl.dp(5)
        anchors.bottom: parent.bottom
        color: Color.DarkGray
        radius: Utl.dp(4)
    }

    Rectangle{  //进度部分
        id:progress
        width: {
            var w = Math.ceil( (parent.width - Utl.dp(10)) * (percent>1?1:percent));
             if(w > 1 && w < Utl.dp(8)){
                w = Utl.dp(8)
            }

            var wd = canvas.width;
            if(w + text.width + wd > background.width){
                text.x = w - text.width - Utl.dp(4)
            } else {
                text.x = w + wd
            }
            return w;
        }
        height: Utl.dp(8)
        x:background.x
        y:background.y
        color: Color.LightBlue
        radius: Utl.dp(4)
    }

    Text{   //百分比显示数字
        id:text
        x:Utl.dp(10)
        anchors.bottom: canvas.bottom
        font.pointSize: 12
        text: Math.ceil( parseInt(percent * 1000)/10) + "%"
    }

    Item{
        id:canvas
        height: text.height
        width: text.height*0.8
        x:progress.width
        anchors.bottom: progress.top
        anchors.bottomMargin: Utl.dp(2)
        Canvas {
          anchors.centerIn: parent
          height: parent.height * 2
          width: parent.width * 2
          smooth: true
          antialiasing: true
          scale: .5

          onPaint:{
             var ctx = this.getContext('2d');
              ctx.save();
              ctx.fillStyle = Color.LightBlue;
              ctx.beginPath();

              var width = this.width
              var height = this.height

              var halfWidth = width/2
              var halfHeight = height/2

              ctx.moveTo(0,0)
              ctx.lineTo(halfWidth,height)
              ctx.lineTo(width,0)
              ctx.lineTo(halfWidth,height/3)
              ctx.lineTo(0,0)
              ctx.closePath()
              ctx.fill()

              ctx.restore();
          }
        }
    }


}

