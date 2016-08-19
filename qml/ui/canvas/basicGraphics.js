/**获取一条直线路径
  * @param x 起点x坐标
  * @param y 起点y坐标
  * @param length 线长度
  * @param angle 倾斜角度，缺省为0
  */
function getSingleLinePathByLength(ctx, x, y, length, angle)
{
    try
    {
        //ctx.beginPath();
        ctx.moveTo(x, y);
        if(angle)
        {
            ctx.lineTo(x+length*Math.cos(angle), y+length*Math.sin(angle));  //Math.cos(), Math.sin()-正
        } else {
            ctx.lineTo(x+length, y);
        }
    } catch(e) {
        console.log(e);
    }
}

/** 根据坐标点画出连续的线段
  * @param data 线条坐标数组[{x,y}, ...]
  */
function getMultitermLines(ctx, data)
{
    try
    {
        if(data.length < 2) {
            return
        }
        //ctx.beginPath();
        ctx.moveTo(data[0].x, data[0].y)
        for(var i = 1; i < data.length; i++)
        {
            ctx.lineTo(data[i].x, data[i].y)
        }
    } catch(e) {
        console.log(e)
    }
}

/** 获得折线
 * @param x 折线原点x坐标
 * @param y 折线原点y坐标
 * @param data 数据 ｛width:折线的x方向间距, dataArr:[value, ...](折线相对原点的高度)｝
 */
function getBrokenLine(ctx, x, y, data)
{
    try
    {
        if(data.dataArr.leghth < 2)
        {
            return
        }
        //ctx.beginPath();
        ctx.moveTo(x, y-data.dataArr[0]);
        for(var i = 1; i < data.dataArr[i]; i++)
        {
            ctx.lineTo(x+data.width*i, y-data.dataArr[i]);
        }
    } catch(e) {
        console.log(e);
    }
}

/**矩形
  * @param x 左上角的x坐标
  * @param y 左上角的y坐标
  * @param width 矩形宽度
  * @param height 矩形高度
  * @param r 圆角半径/平角宽度
  * @param flatAngle 是否为平角矩形
  * 注：没有旋转角度，没有判断参数大小对比（画出的可能不是矩形）
  */
function getRectPath(ctx, x, y, width, height, r, flatAngle)
{
    try
    {
        //ctx.beginPath();
        if(flatAngle)  //平角矩形
        {
            ctx.moveTo(x+r, y);
            ctx.lineTo(x+width-r, y);
            ctx.lineTo(x+width, y+r);
            ctx.lineTo(x+width, y+height-r);
            ctx.lineTo(x+width-r, y+height);
            ctx.lineTo(x+r, y+height);
            ctx.lineTo(x, y+height-r);
            ctx.lineTo(x, y+r);
            ctx.closePath();
            return;
        }
        if(r) //圆角矩形
        {
            ctx.moveTo(x+r, y);
            ctx.lineTo(x+width-r, y);
            ctx.arcTo(x+width, y, x+width, y+r, r);
            ctx.arcTo(x+width, y+height, x+width-r, y+height, r);
            ctx.lineTo(x+r, y+height);
            ctx.arcTo(x, y+height, x, y+height-r, r);
            ctx.arcTo(x, y, x+r, y, r);
            ctx.closePath();
        } else { //直角矩形
            ctx.rect(x, y, width, height);
        }
    } catch(e) {
        console.log(e);
    }
}

/** 点/圆
  * @param x 圆心x坐标
  * @param y 圆心y坐标
  * @param r 圆半径
  */
function getCircularPath(ctx, x, y, r)
{
    try
    {
        //ctx.beginPath();
        //arc(圆心x,圆心y,半径,开始的角度,结束的角度,是否逆时针)
        ctx.arc(x, y, r, 0, Math.PI*2);
    } catch(e) {
        console.log(e);
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
function getsectorPath(ctx, x, y, r, angleBegin, angelEnd, ifAnticlockwise)
{
    try
    {
        ctx.arc(x, y, r, angleBegin, angelEnd, ifAnticlockwise);
        ctx.lineTo(x,y);
        ctx.closePath();
    } catch(e) {
        console.log(e)
    }
}

/** 椭圆 椭圆（Ellipse）是平面内到定点F1、F2的距离之和等于常数（大于|F1F2|）的动点P的轨迹，F1、F2称为椭圆的两个焦点。
  * 其数学表达式为：|PF1|+|PF2|=2a（2a>|F1F2|）
  * 椭圆截与两焦点连线重合的直线所得的弦为长轴，长为2a
  * 椭圆截垂直平分两焦点连线的直线所得弦为短轴，长为2b
  * @param x 中点x坐标
  * @param y 中点y坐标
  * @param a 长轴的一半
  * @param b 短轴的一半
  */
function getEllipsePath(ctx, xp, yp, a, b)
{
    //ctx.beginPath();
    //lineTo的画法,循环次数多，耗资源
    /*var xPos = xp + a;
    var yPos = yp;
    ctx.moveTo(xPos, yPos);
    for(var i=0; i<=360; i++)
    {
        var angle = i * Math.PI / 180;
        //参数方程：x=acosθ ， y=bsinθ
        xPos = xp + a*Math.cos(angle);
        yPos = yp - b*Math.sin(angle);
        ctx.lineTo(xPos, yPos);
    }
    */


    /*//圆缩放成椭圆，不精确，画笔有宽度时变形
    ctx.save(); //先保存，之前画的图形不变动
    ctx.scale(a/b, 1); //缩放函数, 圆的中点坐标会改变
    ctx.arc(xp*b/a, yp, b, 0, 2 * Math.PI, false);
    ctx.stroke()
    // restore to original state
    ctx.restore() //将画布置回原来的状态，即不拉伸
    */

    //*****用四条贝赛尔曲线画出来，起点坐标为椭圆对应矩形的左上角点。****/
    /*var kappa = 0.5522848; //取值，来路不明？？
    var ox = a * kappa, // control point offset horizontal
    oy = b * kappa, // control point offset vertical
    xe = xp + 2*a, // x-end
    ye = yp + 2*b, // y-end
    xm = xp + a, // x-middle
    ym = yp + b; // y-middle
    ctx.moveTo(xp, ym);
    ctx.bezierCurveTo(xp, ym - oy, xm - ox, yp, xm, yp);
    ctx.bezierCurveTo(xm + ox, yp, xe, ym - oy, xe, ym);
    ctx.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
    ctx.bezierCurveTo(xm - ox, ye, xp, ym + oy, xp, ym);
    //ctx.closePath();
    */

    //用四条贝赛尔曲线画出来，起点坐标为椭圆中点
    /*var kappa = 1 - 0.5522848; //取值，来路不明？？
    var ox = a * kappa, // control point offset horizontal
    oy = b * kappa, // control point offset vertical
    xe = xp + 2*a, // x-end
    ye = yp + 2*b, // y-end
    xm = xp + a, // x-middle
    ym = yp + b; // y-middle
    ctx.moveTo(xp-a, yp);
    ctx.bezierCurveTo(xp-a, yp-oy, xp-ox, yp-b, xp, yp-b);
    ctx.bezierCurveTo(xp+ox, yp-b, xp+a, xp-oy, xp+a, yp);
    ctx.bezierCurveTo(xp+a, yp+oy, xp+ox, xp+b, xp, yp+b);
    ctx.bezierCurveTo(xp-ox, yp+b, xp-a, yp+oy, xp-a, yp);
    //ctx.closePath();
    */


    //用两条贝塞尔曲线画出来
    var k = (2*a/0.75)/2,
            w = a,
            h = b;
    ctx.moveTo(xp, yp-h);
    ctx.bezierCurveTo(xp+k, yp-h, xp+k, yp+h, xp, yp+h);
    ctx.bezierCurveTo(xp-k, yp+h, xp-k, yp-h, xp, yp-h);
    //ctx.closePath();
}

