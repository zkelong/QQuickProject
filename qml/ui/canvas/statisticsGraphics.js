.pragma library
.import "basicGraphics.js" as BasicGraphics

var data;

/** 绘制背景，包括x,y轴，网格
  * @param ctx 画笔
  * @param originx 原点x坐标
  * @param originy 原点y坐标
  * @param width 宽度
  * @param height 高度
  */
function drawBackGround(ctx, originx, originy, width, height)
{
    if(data) {
        try{
            BasicGraphics.getSingleLinePathByLength(ctx, originx, originy, width, 0);
            BasicGraphics.getSingleLinePathByLength(ctx, originx, originy, height, -Math.PI/2);
//            ctx.strokeStyle = data.xyColor;
            ctx.stroke();
        } catch(e) {
            console.log(e);
        }
    }
    ctx.beginPath();
    drawGradding(ctx, originx, originy, width, height, width/12, height/10);
}

/** 画网格线
  * @param ctx 画笔
  * @param originx 原点x坐标
  * @param originy 原点y坐标
  * @param width 网格宽度
  * @param height 网格高度
  * @param xStep 网格x方向间隔
  * @param yStep 网格y方向间隔
  * @param xLeft 往x轴负方向绘制
  * @param yDown 往y轴负方向绘制
  */
function drawGradding(ctx, originx, originy, width, height, xStep, yStep, xLeft, yDown)
{
    try
    {
        var yPos = originy;
        var xPos = originx;
        while(Math.abs(yPos-originy) <= height) //网格横线
        {
            if(xLeft)
            {
                BasicGraphics.getSingleLinePathByLength(ctx, originx, yPos, width, Math.PI);
            } else {
                BasicGraphics.getSingleLinePathByLength(ctx, originx, yPos, width, 0);
            }
            if(yDown)
            {
                yPos += yStep;
            } else {
                yPos -= yStep;
            }
            console.log(Math.abs(yPos-originy), height)
        }
        while(Math.abs(xPos-originx) <= width) //网格竖线
        {
            console.log(Math.abs(xPos-originx), width)
            if(yDown)
            {
                BasicGraphics.getSingleLinePathByLength(ctx, xPos, originy, height, Math.PI/2);
            } else {
                BasicGraphics.getSingleLinePathByLength(ctx, xPos, originy, height, -Math.PI/2);
            }
            if(xLeft)
            {
                xPos -= xStep;
            } else {
                xPos += xStep;
            }
        }
        ctx.lineWidth = 3;
        ctx.strokeStyle = data.xyColor//"rgba(255,0,0,0.1)"
        ctx.stroke();
    } catch(e) {
        console.log(e)
    }
}

/** 绘制饼图
  *
  */
function drawPie(ctx, originx, originy, radius)
{
    var pieData = [
                {value: 30,color:"#F38630"},
                {value: 50,color: "#E0E4CC"},
                {value: 100,color: "#69D2E7"},
                {value: 80,color: "#123456"},
                //只需要在这儿添加数据即可，要求value大于0
                //{value: 40,color: "#654321"}
            ];
    var data = pieData;

    var width = ctx.canvas.width;
    var height = ctx.canvas.height;
    var config = {
        segmentShowStroke : true,
        segmentStrokeColor : "#fff",
        segmentStrokeWidth : 2,
    };
    var segmentTotal = 0;
    var pieRadius = Math.min.apply(Math, [height/2, width/2]) - 5;
    for (var k=0; k<data.length; ++k)
    {
        segmentTotal += data[k].value;
    }
    var cumulativeAngle = -Math.PI/2;
    var scaleAnimation = 1;
    var rotateAnimation = 1;
    for (var i=0; i<data.length; ++i)
    {
        var segmentAngle = rotateAnimation*((data[i].value/segmentTotal)*(Math.PI*2));
        ctx.beginPath();
        ctx.arc(width/2, height/2, scaleAnimation * pieRadius,
                cumulativeAngle, cumulativeAngle + segmentAngle);
        ctx.lineTo(width/2, height/2);
        ctx.closePath();
        ctx.fillStyle = data[i].color;
        ctx.fill();
        if(config.segmentShowStroke)
        {
            ctx.lineWidth = config.segmentStrokeWidth;
            ctx.strokeStyle = config.segmentStrokeColor;
            ctx.stroke();
        }
        cumulativeAngle += segmentAngle;
    }
}
