import QtQuick 2.0

//广告栏--循环播放
Item {
    id: root

    property int currentIndex: 0 //当前页索引
    property bool autoScroll: true //是否自动滚动
    property bool userPress: false

    property ListModel listModel: null
    property alias delegate: pathView.delegate
    property alias pathView: pathView

    onListModelChanged: {
        if(listModel && listModel.count > 0) {
            clearCircles()
            for(var i = 0; i < listModel.count; i++) {
                var c = circle.createObject(circles);
                if(listModel.count === 1) c.color = "red"
            }
        }
        pathView.currentIndex = 0
        var chs = circles.children
        chs[pathView.currentIndex].color = "red"
    }

    PathView{
        id: pathView
        interactive: listModel && listModel.count > 0
        anchors.fill: parent
        highlightRangeMode: PathView.StrictlyEnforceRange;
        snapMode: PathView.SnapOneItem
        clip: true
        pathItemCount: 3
        preferredHighlightBegin: 0.5;   //显示位置
        preferredHighlightEnd: 0.5;
        flickDeceleration: 500  //切换速度--默认100
        offset: 0
        model: listModel
        path:Path {
            startX: -root.width
            startY: root.height/2
            PathLine {
                x: root.width*2
                y: root.height/2
            }
        }
        onCurrentIndexChanged: {
            var chs = circles.children
            for(var i = 0; i < chs.length; ++i){
                chs[i].color = "white"
            }
            chs[pathView.currentIndex].color = "red"
        }
    }

    Row {
        id: circles
        spacing: Utl.dp(8)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom; anchors.bottomMargin: Utl.dp(10)
    }

    Component { //圆点
        id:circle
        Rectangle{
            width: Utl.dp(8); height: width
            radius: width/2
            color:"white"
        }
    }

    Timer {
        id: timer
        running: autoScroll && root.visible && !root.userPress
        interval: 2500; repeat: true
        onTriggered: root.doNext()
    }

    function clearCircles() {
        var chs = circles.children
        for(var i = 0; i < chs.length; ++i){
            chs[i].destroy();
        }
    }

    function doNext() {
        if(pathView.currentIndex < listModel.count-1)
            pathView.currentIndex++
        else
            pathView.currentIndex = 0
    }

}

