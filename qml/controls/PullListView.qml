import QtQuick 2.4
import "../toolsbox/color.js" as ColorUtl
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/tools.js" as Tools

ListView {
    id:root
    property bool loading: false //是否正处于加载中
    property bool hasMore: true //是否还有更多
    property bool isFooter: false
    property int timeout : 30000;   //超时定时
    property double pullProgress: 0 //下拉进度
    signal reload //重新加载
    signal loadmore //加载更多
    property real maxDragdownDistance: Utl.dp(120)  //最大下拉距离
    property bool loadFinish: false //加载完成

    property real oldTopMargin: -1

    property var pullItem: null
    property bool isDraged: false   //是否正在拽着
    property bool freshRun: false   //刷新动画--保证动画的完整性，与root.loading分开

    signal timeOuted()

    // 开始刷新时调用
    // @param animated 是否使用动画过渡
    function startLoading(animated){
        if(loading)
            return
        loading = true
        timer.start()
        if(!pullItem){
            return
        }
        _doStartAction(animated)
    }

    // 加载完成时调用
    // @param animated 是否使用动画过渡
    function stopLoading(animated){
        if(!loading)
            return
        if(!pullItem){
            return
        }
        if(animated) {  //要动画，多等一哈，
            delay_stop.start()
        } else {
            _doStopAction(animated)
            loading = false
        }
        timer.stop()
    }

    //执行加载操作，将加载元素显示出来
    function _doStartAction(animated){
        if(startAnimation.running)
            startAnimation.stop()
        if(oldTopMargin == -1){
            oldTopMargin = root.topMargin
        }
        if(animated){
            startAnimation.start()
        } else {
            root.topMargin = oldTopMargin + pullItem.height
        }
    }

    //停止加载操作，将加载元素隐藏
    function _doStopAction(animated){
        if(stopAnimation.running){
            stopAnimation.stop()
        }
        if(animated){
            stopAnimation.start()
        }else {
            root.topMargin = oldTopMargin
        }
    }

    onOldTopMarginChanged: {
        if(pullItem){
            pullItem.y = -(pullItem.height + root.oldTopMargin)
        }
    }

    Component.onCompleted:  {
        pullItem = pullComponent.createObject(root.contentItem)
        pullItem.y = -(pullItem.height + root.topMargin)
        //if(loading){
        //    _doStartAction(true)
        //}
    }

    onLoadingChanged: {
        if(loading) { //开始加载
            if(contentHeight > 0 && root.height > 0 && contentHeight < root.height) //出现负数
                isFooter = false
        } else {    //结束加载
            if(contentHeight > 0 && root.height > 0 && contentHeight > root.height) //出现负数
                isFooter = true
            else
                isFooter = false
        }
    }

    Timer{
        id:timer
        running: false;
        repeat: false;
        interval: timeout
        onTriggered: {
            console.log("获取数据超时")
            stopLoading(true)
            loading = false
            timeOuted()
            Tools.hidenBusy()
        }
    }

    Component{
        id:pullComponent
        Rectangle{
            width: parent.width
            height: Utl.dp(60)
            color: ColorUtl.Clear

            Image{
                id:refreshImg; source: "qrc:/res/refresh_0.png"
                width: Utl.dp(16); height: Utl.dp(13); anchors.centerIn: parent
                NumberAnimation{
                    id:rotationPlay
                    target:refreshImg;
                    property:"rotation";
                    from: 0;
                    to: 360;
                    loops: -1
                    duration: 800
                }
            }
            Text {
                id:refreshText; horizontalAlignment: Text.AlignHCenter; color:ColorUtl.DarkGray
                text:{
                    if(root.freshRun){
                        rotationPlay.start()
                        refreshImg.source = "qrc:/res/refresh.png"
                    } else if(root.pullProgress >= 0.6){    //旋转
                        rotationPlay.stop()
                        refreshImg.source = "qrc:/res/refresh_0.png"
                        if(root.pullProgress <= 1.0)
                            refreshImg.rotation = ((root.pullProgress-0.6)/0.4) * 180
                        else
                            refreshImg.rotation = 180
                    } else {
                        rotationPlay.stop()
                        refreshImg.rotation = 0;
                        refreshImg.source = "qrc:/res/refresh_0.png"
                    }

                    if(loadFinish)
                        return qsTr("加载完成")
                    if(root.freshRun){
                        return qsTr("加载中")
                    }
                    if(root.pullProgress >= 1){
                        return qsTr("释放刷新")
                    }
                    return qsTr("下拉刷新")
                }

                font.pointSize: FontUtl.FontSizeSmallB
                anchors.top: refreshImg.bottom; anchors.topMargin: Utl.dp(5); anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Component{
        id:moreComponent
        Rectangle{
            property alias label: _label
            width: parent.width
            height: Utl.dp(30)
            visible: root.isFooter
            color: ColorUtl.Clear

            Text {
                id:_label
                text: {
                    if(root.loading){
                        return qsTr("正在加载更多...")
                    } else if (root.hasMore){
                        return qsTr("加载更多")
                    }
                    return qsTr("全部加载完毕")
                }
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeSmallB
            }
        }
    }
    footer: moreComponent

    onContentYChanged: {//在滚动过程中计算滚动值，更新加载元素的状态
        //下拉距离限定
        if(loading && pullItem) {
            if(contentY + root.topMargin - pullItem.height < -maxDragdownDistance && isDraged) {  //下拉距离限定--isDraged防止拽拉释放卡在这里
                contentY = -maxDragdownDistance - root.topMargin + pullItem.height
            }
        } else {
            if(contentY + root.topMargin < -maxDragdownDistance && isDraged) {  //下拉距离限定
                contentY = -maxDragdownDistance - root.topMargin
            }
        }

        if(loading)
            return
        var cur = -root.contentY - root.topMargin
        if(cur > 0){
            root.pullProgress = cur/pullItem.height
        }
        if(root.hasMore && root.contentHeight > root.height){
            if(root.contentY - root.originY >= (root.contentHeight - root.footerItem.height/2)-root.height){//加载更多
                loading = true
                loadmore()
            }
        }
    }
    onDragStarted: {
        isDraged = true
    }

    onDragEnded: {
        isDraged = false
        if(loading)
            return
        if (root.contentY <= -(pullItem.height + root.topMargin)){
            root.freshRun = true
            startLoading(false)
            reload()
        }
    }

    Timer { //动画要显示全
        id: delay_stop
        interval: 900
        running: false
        repeat: false
        onTriggered: {
            root.freshRun = false
            _doStopAction(true)
            loading = false
        }
    }

    NumberAnimation on contentY/*topMargin*/ {  //显示出刷新栏--topMargin,加载数据后动画执行到一半就挺了，
        id: startAnimation
        running: false
        from: root.contentY //root.topMargin
        to: root.contentY - pullItem.height //oldTopMargin + pullItem.height + root.originY
        onStopped: {
            root.freshRun = true
        }
    }

    NumberAnimation on contentY/*topMargin*/ {  //隐藏刷新栏
        id: stopAnimation
        running: false
        from: root.contentY //root.topMargin
        to: -oldTopMargin
        onStarted: {
            loadFinish = true
        }
        onStopped: {
            loadFinish = false
            if(!loading){
                root.contentY = -oldTopMargin
                root.topMargin = oldTopMargin
            }
        }
    }
}

