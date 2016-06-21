import QtQuick 2.0

import "../controls"
import "../toolsbox/config.js" as Config

View {
    id: root

    property string pathcurrentChoice;

    Component.onCompleted: {
        for(var i = 0; i < 10; i++) {
            var item = {
                name: "PIC-" + i
                ,icon: Config.testPicUrl[i]
                ,title: "测试字符串"+i
            }
            appModel.append(item)
        }
    }

    PathView {
        id: view
        anchors.centerIn: parent
        highlight: appHighlight
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: appModel
        delegate: appDelegate
        pathItemCount:4
        //Path由一个或者多个路径组成，可用的路径包括PathLine、PathQuad和PathCubic
        path:Path {
            id: pathx
            startX: 10; startY: 50  //开始位置
            PathAttribute {name: "iconScale"; value: 1}
            PathLine {x: 10; y: 300}
            PathAttribute {name: "iconScale"; value: 1}
            PathLine {x: 300; y: 300}
            PathAttribute {name: "iconScale"; value: 1}
            PathLine {x: 300; y: 50}

            //            PathQuad {x: 200; y:150; controlX: 50; controlY: 200}
//            PathAttribute {name: "iconScale"; value: 1.0}
//            PathQuad {x: 390; y:50; controlX: 350; controlY: 200}
//            PathAttribute{name: "iconScale"; value: 1}
        }

        onCurrentIndexChanged: {
            pathcurrentChoice = appModel.get(currentIndex).name
            console.log(appModel.get(currentIndex).name) //如果是当前是1，点击翻到5，1~5都将在此处打印
        }
        onDragEnded: {
            console.log("dragend..", currentIndex)
        }
        onMovementEnded: {
            console.log("move...", currentIndex)
        }
    }

    ListModel {
        id: appModel
    }

    Component {
        id: appDelegate
        Item {
            id: test
            width: 100; height: 100
            scale: PathView.iconScale //放大缩小倍数
            Image {
                id: myIcon
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
                width: 55
                height: 55
                source: icon
                smooth: true
            }
            Text {
                id: txt
                anchors{
                    top: myIcon.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                text: name
                smooth: true
                color: test.PathView.isCurrentItem ? "red" : "black"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index;
                    console.log(pathx.closed)
                }
            }
        }
    }

    Component {
        id: appHighlight
        Rectangle {width: 80; height: 80; color: "lightsteelblue"}
    }
}

/**Path
属性：
  1.closed: bool read_only //起点终点是否相同，闭合？？
  2.startX : real
    startY : real  //起始位置
  3.pathElements : list<PathElement>
    a.PathLine  //直线路径
      属性：
        &.x : real; y : real //直线的结束位置
        &.relativeX : real; relativeY : real //相对结束位置；以相对于起点的相对坐标的形式来指定终点
    b.PathQuad  //二次Bezier曲线
      属性：
        &.x : real; y : real    //曲线结束位置
        &.relativeX : real relativeY : real //相对位置；以相对于起点的相对坐标的形式来指定终点
        &.controlX : real; controlY : real  //控制曲线方向和程度
        &.relativeControlX : real; relativeControlY : real  //相对控制；相对于起点
    c.PathCubic //三次Bezier曲线
      属性：
        &.x: real; y: real  //线终点位置
        &.relativeX: real; relativeY: real
        &.control1X: real; control1Y: real  //控制点1
        &.relativeControl1X: real; relativeControl1Y: real
        &.control2X: real; control2Y: real  //控制点2
        &.relativeControl2X: real; relativeControl2Y: real
    d.PathArc   //弧线
      属性：
        &.x: real; y: real  //结束位置
        &.relativeX: real; relativeY: real  //相对位置
        &.useLargeArc: bool //是否使用大弧，defalut:false
            //定义起点终点的时候，是否使用大弧
        &.direction: enumeration    //弧形方向，上下/里外
            o.PathArc.Clockwise (default)
            o.PathArc.Counterclockwise
        &.radiusX: real; radiusY: real  //弧线弧度
    e.PathSvg //用SVG path data定义路径
        属性：
          &.path: string //SVG path data定义路径
        PATH十种指令：
        括号内为相应参数，详细解释见后文。
        M = moveto(M X,Y)
        L = lineto(L X,Y)
        H = horizontal lineto(H X)
        V = vertical lineto(V Y)
        C = curveto(C X1,Y1,X2,Y2,ENDX,ENDY)
        S = smooth curveto(S X2,Y2,ENDX,ENDY)
        Q = quadratic Belzier curve(Q X,Y,ENDX,ENDY)
        T = smooth quadratic Belzier curveto(T ENDX,ENDY)
        A = elliptical Arc(A RX,RY,XROTATION,FLAG1,FLAG2,X,Y)
        Z = closepath()
        注释：
        　　坐标轴为以(0,0)为中心，X轴水平向右，Y轴水平向下。
        　　所有指令大小写均可。大写绝对定位，参照全局坐标系；小写相对定位，参照父容器坐标系
        　　对于S,T指令，其X1,Y1为前一条曲线的X2,Y2的反射
        　　指令和数据间的空格可以省略
        　　同一指令出现多次可以只用一个
        L H V指令
        　M起点X，起点YL（直线）终点X，终点YH（水平线）终点XV（垂直线）终点Y
        　如M10,20,L80,50,M10,20,V50,M10,20,H90
        C指令——三次贝塞曲线
        　C第一控制点X，第一控制点Y 第二控制点X，第二控制点Y曲线结束点X，曲线结束点Y
        S指令
        　S第二控制点X，第二控制点Y 结束点X，结束点Y
        Q指令——二次贝塞曲线
        　Q控制点X，控制点Y 曲线结束点X，曲线结束点Y
        如M0,25,Q12.5,37.5,25,25,M25,25,Q37.5,12.5,50,25
        T指令——映射
        　T映射前面路径后的终点X，映射前面路径后的终点Y
        A指令
        　Elliptical Arc，允许不闭合。可以想像成是椭圆的某一段，共七个参数。
        　RX,RY指所在椭圆的半轴大小
        　XROTATION指椭圆的X轴与水平方向顺时针方向夹角，可以想像成一个水平的椭圆绕中心点顺时针旋转XROTATION的角度。
        　FLAG1只有两个值，1表示大角度弧线，0为小角度弧线。
        　FLAG2只有两个值，确定从起点至终点的方向，1为顺时针，0为逆时针
        　X,Y为终点坐标
        　如M0,25,A12.5,12.5,0,1,1,0,25.01Z表示一个圆心在(12.5,25)，半径为12.5的圆。其中起点和终点几乎重合，用Z指令将它们闭合，注意终点不能填(0,25)，那样A指令是无法被解析的。
        由以上介绍可以看出，手工绘制SVG路径是相当复杂的。对于简单的SVG图形，一般只使用M,L,Q,A,Z五种指令完成。更复杂的图形则必须要靠软件来帮助完成，比如ADOBE ILLUSTRATOR。
    f.PathCurve //路径，定义点，依次串联为曲线
        属性：
          &.x: real; y: real
          &.relativeX: real; relativeY: real
    g.PathAttribute //路径中给定位置的属性
        属性：
          &.name: string    //属性名字
          &.value: real     //属性值
    h.PathPercent //定义路径上项目分部的比例
        属性：
          &.value: real //所占比例
  */

