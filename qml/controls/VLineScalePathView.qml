import QtQuick 2.0

PathView {
    id: pathview;
    //anchors.fill: parent
    interactive: true; //可以滑动
    pathItemCount: 5;  //显示项数
    //保证居中显示
    preferredHighlightBegin: 0.5;
    preferredHighlightEnd: 0.5;
    highlightRangeMode: PathView.StrictlyEnforceRange;
    flickDeceleration:1000 //速度
    dragMargin:100;  //可拖动范围
    focus:true
    path:Path { //路径
        //开始位置
        startX: 130
        startY: 20
        //路径属性
        PathAttribute { name: "zOrder"; value: 0 }
        PathAttribute { name: "itemScale"; value: 0.6 }
        //路径结尾位置
        PathLine {
            x: 130
            y: 180
        }
        PathAttribute { name: "zOrder"; value: 10 }
        PathAttribute { name: "itemScale"; value: 1.0 }
        //相对胡结尾位置
        PathLine {
            relativeX: 0
            relativeY: 150
        }
        PathAttribute { name: "zOrder"; value: 0 }
        PathAttribute { name: "itemScale"; value: 0.6 }
    }
}

