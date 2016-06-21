import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"
import "basicGraphics.js" as Bg

View {
    id: root

    Rectangle {
        id: rect1
        anchors.top: titleBar.bottom
        width: parent.width; height: parent.height / 5
        Canvas {
            id: canvas0
            anchors.fill: parent
            onPaint: {
                var ctx = canvas0.getContext("2d"); //目前只有2d画笔，画笔是唯一的，需要画不同的颜色需要重新赋值颜色
                Bg.getSingleLinePathByLength(ctx, 10, 20, 100, Math.PI / 4);
                ctx.lineWidth = 10;
                ctx.strokeStyle='rgba(255, 0, 0, 0.5)'  //rgb颜色，透明度0~1
                ctx.stroke();
            }
        }
    }

    Rectangle {
        id: rect2
        anchors.top: rect1.bottom
        width: parent.width; height: parent.height / 3

        Canvas {
            id: canvas1
            anchors.fill: parent
            onPaint: {
                var ctx = canvas1.getContext("2d"); //目前只有2d画笔，画笔是唯一的，需要画不同的颜色需要重新赋值颜色
                Bg.getCircularPath(ctx, 150, 150, 150);
                ctx.fillStyle='#ff0000';
                ctx.fill();
                ctx.beginPath();
                Bg.getEllipsePath(ctx, 150, 150, 150, 100);
                ctx.fillStyle='#0000ff';
                ctx.fill();
                ctx.beginPath();
                Bg.getsectorPath(ctx, 150, 150, 100, 0, Math.PI / 4);
                ctx.fillStyle='#00ff00';
                ctx.fill();
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

/*
canvas默认是透明的，没有背景色
Canvas画图是通过javascript来做的

1.画笔
  a.得到画笔
  var ctx = canvas.getContext("2d"); //目前只有2d画笔
  画笔是唯一的，需要画不同的颜色需要重新赋值颜色
  b.移动画笔
  ctx.moveTo(x, y)；
  c.开启新路径
   ctx.beginPath()
   开始一条路径，或重置当前的路径。
   如果前面有定义路径且没有执行ctx.stroke()，前面的路径不会绘制。
   如果有改变strokeStyle，没有ctx.beginPath()会导致样式混乱。因为canvas在第二次给路径上色时，是把之前的所有路径轨迹合在一起来上色的。
2.画笔属性设置
  a.设置画笔宽度
    ctx.lineWidth=10;
  b.画笔转折样式
    lineJoin = 'miter' //尖角default
             //'bevel' 斜角
             //'round' 圆角
  c.lineCap = 'butt' //平default
             //'round' //圆，冒出一截，线的宽度

             //'square' //方，冒出一截，线的宽度
  d.画笔描边样式/颜色
    ctx.strokeStyle='rgba(255, 0, 0, 0.5)'  //rgb颜色，透明度0~1

3.画直线
  ctx.moveTo(0, 0) //起点
  ctx.lineTo(100, 100)  //线(到终点)
  ctx.stroke() //描边，把线画出来
  a.可以连续定义多条线再描边
  b.画笔有宽度，可能出现缺的情况
    ctx.moveTo(100,100);
    ctx.lineTo(200,100);
    ctx.moveTo(200,100); //注意这里，画笔有个中线，有缺口
    ctx.lineTo(200,200);
    ctx.lineTo(100,200); //没有提起画笔，所以没有缺口
    ctx.lineTo(100,100);
    ctx.lineWidth = 10;
    ctx.strokeStyle = 'rgba(255,0,0,0.5)';
    ctx.stroke();
    可以用ctx.closePath(); //闭合路径，填掉缺口，如果画的线没有闭合，自动补充一条直线从终点到上一个moveTo的点
   c.宽度为1像素的线
     模糊不清，不像一个像素：canvas划线是从中线向两侧延伸，划线是占相邻两个像素的一半，但计算机不允许小于1px的图形，所以占了两个像素
     解决：以.5来定位
     ctx.moveTo(100.5,100.5);
     ctx.lineTo(200.5,100.5);
  注：canvas的绘图过程（即填充与描边）是非常消耗资源的，如果想节省系统资源提高效率，最好是绘制好所有路径，再一次性填充或描边图形

4.绘图的两种方式
  a.描边：
    ctx.stroke()
    1)描边样式/颜色
      ctx.strokeStyle='rgba(255, 0, 0, 0.5)'  //rgb颜色，透明度0~1
  b.填充：
    ctx.fill()
    1)填充颜色/样式
       ctx.fillStyle='颜色' //默认的填充样式是不透明的黑色
    2)未闭合的路径的填充
      Canvas会从你当前路径的终点直接连接到起点，然后填充。
    3)填充渐变颜色，渐变颜色分为两种：线性渐变和径向渐变
      1>线性渐变
      var linear = ctx.createLinearGradient(x1,x2,x3,x4); //起点和终点,定义渐变线
      linear.addColorStop(0, '#fff');  //给渐变线添加颜色
      linear.addColorStop(0.5, '#f0f'); //addColorStop(0-1<可以是两位小数表示百分比>)
      linear.addColorStop(1, '#333');
      ctx.fillStyle = linear; //把渐变色赋值为填充样式
      ctx.fillRect(100,100,100,100);
      ctx.stroke(); //fillRect与strokeRect画出的都是独立路径，不会把刚画出的矩形描边
      2>径向渐变(圆形渐变)
      createRadialGradient(x1,y1,r1,x2,y2,r2) //起点终点都是圆//起点圆可以看成比较大的原点
      var radial = ctx.createRadialGradient(55,55,10,55,55,55); //重合的圆心坐标
      radial.addColorStop(0,'#fff');
      radial.addColorStop(0.5,'#ff0');
      radial.addColorStop(0.9,'#555');
      radial.addColorStop(1,'#f00');
      渐变可以赋值给fillStyle和strokeStyle。
      注：如果大圆不包含小圆，效果会有问题。

5.矩形
  填充矩形：
    ctx.fillRect(x,y,width,height); //x,y指左上角的点
  描边矩形：
    ctx.strokeRect(x,y,width,height)
  类似的：

    fillText, strokeText

 定义矩形路径，在填充：

  ctx.rect(300,100,50,40);
  ctx.stroke()
  ctx.fill();

6.画曲线
  有4个函数：arc, arcTo, quadratcCurveTo, bezierCurveTo
  a.arc(正圆)：context.arc(x, y, radius, startAngle, endAngle, anticlockwise) //是否逆时针
    ctx.arc(100, 100, 50, 0, Math.PI*2);
    ctx.fill();  //填充
    ctx.stroke(); //描边
    注：arc的0度就是数学上常用的0度，但是角度默认是顺时针张开的，与数学模型相反（跟坐标有关，因为canvas坐标也与数学坐标相反）
  b.arcTo(正圆弧)
    ctx.moveTo(x0, y0)
    ctx.arcTo(x1,y1,x2,y2,radius) //点1，点2，圆弧半径
    ctx.strock();
    (x0, y0)、(x1, y1)与(x2, y2)组成夹角，半径为radius的圆与该夹角相切，得到一个圆弧，(x0,y0)与第一条线的切点得到一条线段。
  c.quadraticCurveTo(二次弧线)
    ctx.moveTo(x0, y0); //起点
    ctx.quadraticCurveTo(x1,y1,x,y); //(x1,y1)-控制点；(x,y)-终点
    控制点：控制弧线弧度方向。
  d.bezierCurveTo(贝赛尔曲线/贝兹曲线/贝济埃曲线-应用于二维图形应用程序的数学曲线)
    ctx.moveTo(x0,y0) //起点
    ctx.bezierCurveTo(x1,y1,x2,y2,x,y); //（x1,y1）即控制点1的坐标，（x2,y2）是控制点2的坐标，(x,y)是他的终点坐标。弧线为起点到终点，中间弧线偏向控制点。
*/
