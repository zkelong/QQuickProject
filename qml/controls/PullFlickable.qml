import QtQuick 2.4
import "../toolsbox/color.js" as ColorUtl
import "../toolsbox/font.js" as FontUtl

/**
* 可刷新的Flickable
*/

Flickable {
    id:root
    contentHeight: childrenRect.height

    property bool loading: false //是否正处于加载中
    signal reload() //加载信号

    property var pullItem: null     //顶部加载动画部分
    property double pullProgress: 0     //下拉进度

    Component.onCompleted:  {
        pullItem = pullComponent.createObject(root.contentItem)
        pullItem.y = -(pullItem.height + root.topMargin + Utl.dp(10))
        if(loading){
            _doStartAction(true)
        }
    }

    onContentYChanged: {//在滚动过程中计算滚动值，更新加载元素的状态
        if(loading)
            return
        var cur = -root.contentY - root.topMargin
        if(cur > 0){
            pullProgress = cur/pullItem.height
        }
    }

    onDragEnded: {
        if (root.contentY <= -(pullItem.height + root.topMargin)){
            startLoading(false)
            reload()
        }
    }

    NumberAnimation on topMargin {
        id:animation
        running: false
        onStopped: {
            if(!loading)
                root.contentY = -_p.oldTopMargin
        }
    }

    QtObject{
        id:_p
        property real oldTopMargin: 0
    }

    Component{  //加载动画部分
        id: pullComponent
        Rectangle{
            width: parent.width
            height: Utl.dp(60)
            color: ColorUtl.Clear

            Image{  //刷新图片
                id:refreshImg; source: "qrc:/res/refresh_0.png"
                width: Utl.dp(16); height: Utl.dp(13); anchors.centerIn: parent
                RotationAnimator on rotation {
                    running: root.loading
                    loops: 1000
                    from: 0;
                    to: 360;
                    duration: 800
                }
            }
            Text {  //文字提示
                id:refreshText; horizontalAlignment: Text.AlignHCenter; color:ColorUtl.DarkGray
                text:{
                    if(root.loading || root.pullProgress >= 1){
                        refreshImg.source = "qrc:/res/refresh.png"
                    } else {
                        refreshImg.rotation = 0;
                        refreshImg.source = "qrc:/res/refresh_0.png"
                    }

                    if(root.loading){
                        return qsTr("加载中")
                    }
                    if(root.pullProgress >= 1){
                        return qsTr("释放刷新")
                    }
                    return qsTr("下拉刷新")
                }

                font.pointSize: FontUtl.FontSizeSmallA
                anchors.top: refreshImg.bottom; anchors.topMargin: Utl.dp(5); anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }


    // 开始刷新时调用
    // @param animated 是否使用动画过渡
    function startLoading(animated){
        if(loading)
            return
        loading = true
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
        loading = false
        if(!pullItem){
            return
        }
        _doStopAction(animated)
    }

    //执行加载操作，将加载元素显示出来
    function _doStartAction(animated){
        if(animation.running)
            animation.stop()
        _p.oldTopMargin = root.topMargin
        if(animated){
            animation.from = root.topMargin
            animation.to = _p.oldTopMargin + pullItem.height
            animation.start()
        } else {
            root.topMargin = _p.oldTopMargin + pullItem.height
        }
    }

    //停止加载操作，将加载元素隐藏
    function _doStopAction(animated){
        if(animation.running){
            animation.stop()
        }
        if(animated){
            animation.from = root.topMargin
            animation.to = _p.oldTopMargin
            animation.start()
        } else {
            root.topMargin = _p.oldTopMargin
        }
    }
}

