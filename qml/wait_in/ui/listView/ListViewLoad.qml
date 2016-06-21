import QtQuick 2.4
import "../../controls"

View {
    id: root

    property bool loading: false //是否正处于加载中
    property bool hasMore: true //是否还有更多
    property double pullProgress: 0 //下拉进度
    signal reload //重新加载
    signal loadmore //加载更多

    property var pullItem: null

    //重新加载
    function reLoad() {
        if(listModel.count > 0)
            listModel.clear()
        hasMore = true
        for(var i = 0; i < 5; i++) {
            sleep(1000)
            var item = {name: i + "-name000", number: "reloadaaaaaaaaa"}
            listModel.append(item)
        }
    }

    //加载更多
    function loadMore(page) {
        for(var i = 0; i < 5; i++) {
            sleep(1000)
            var item = {name: i + "-name000", number: "loadMore++++++++"}
            listModel.append(item)
        }
        if(page == 3) {  //加载次数
            hasMore = false
        }
    }

    ListView {
        id:listv
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        property real oldTopMargin: -1

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

            if(!pullItem){
                return
            }
            _doStopAction(animated)
            loading = false
        }

        //执行加载操作，将加载元素显示出来
        function _doStartAction(animated){
            if(startAnimation.running)
                startAnimation.stop()
            if(oldTopMargin == -1){
                oldTopMargin = listv.topMargin
            }

            if(animated){
                startAnimation.start()
            } else {
                listv.topMargin = listv.oldTopMargin + pullItem.height
            }
        }

        //停止加载操作，将加载元素隐藏
        function _doStopAction(animated){
            //if(listv.topMargin == _p.oldTopMargin)
            //     return

            if(stopAnimation.running){
                stopAnimation.stop()
            }
            if(animated){
                stopAnimation.start()
            } else {
                listv.topMargin = oldTopMargin
            }
        }

        onOldTopMarginChanged: {
            if(pullItem){
                pullItem.y = -(pullItem.height + listv.oldTopMargin)
            }
        }

        Component.onCompleted:  {
            pullItem = pullComponent.createObject(listv.contentItem)
            pullItem.y = -(pullItem.height + listv.topMargin)
            if(loading){
                _doStartAction(true)
            }
        }

        footer:moreComponent

        onContentYChanged: {//在滚动过程中计算滚动值，更新加载元素的状态
            if(loading)
                return

            var cur = -listv.contentY - listv.topMargin
            if(cur > 0){
                pullProgress = cur/pullItem.height
            }

            if(listv.hasMore && listv.contentHeight > listv.height){
                if(listv.contentY + listv.height >= (listv.contentHeight - listv.footerItem.height/2)){//加载更多
                    loading = true
                    loadmore()
                }
            }
        }


        onDragEnded: {
            if(loading)
                return

            if (listv.contentY <= -(pullItem.height + listv.topMargin)){
                startLoading(false)
                reload()
            }
        }

        NumberAnimation on topMargin {
            id: startAnimation
            running: false
            from: listv.topMargin
            to: listv.oldTopMargin + pullItem.height
            onStopped: {

            }
        }

        NumberAnimation on topMargin {
            id: stopAnimation
            running: false
            from: listv.topMargin
            to: listv.oldTopMargin
            onStopped: {
                if(!loading){
                    listv.contentY = -listv.oldTopMargin
                    listv.topMargin = listv.oldTopMargin
                }
            }
        }
    }


    Component{
        id:pullComponent
        Rectangle{
            width: parent.width
            height: 120
            color: "transparent"

            Image{
                id:refreshImg; source: "qrc:/res/refresh_0.png"
                width: 32; height: 26; anchors.centerIn: parent
                RotationAnimator on rotation {
                    running: loading
                    loops: 1000
                    from: 0;
                    to: 360;
                    duration: 800
                }
            }
            Text {
                id:refreshText; horizontalAlignment: Text.AlignHCenter; color: "#222"
                text:{
                    if(listv.loading || listv.pullProgress >= 1){
                        refreshImg.source = "qrc:/res/refresh.png"
                    } else {
                        refreshImg.rotation = 0;
                        refreshImg.source = "qrc:/res/refresh_0.png"
                    }

                    if(listv.loading){
                        return qsTr("加载中")
                    }
                    if(listv.pullProgress >= 1){
                        return qsTr("释放刷新")
                    }

                    return qsTr("下拉刷新")
                }

                font.pointSize: 14
                anchors.top: refreshImg.bottom; anchors.topMargin: 10; anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Component{
        id:moreComponent
        Rectangle{
            property alias label: _label
            width: parent.width
            height: 60
            visible: listv.count
            color: "transparent"

            Text {
                id:_label
                text: {
                    if(listv.loading){
                        return qsTr("正在加载更多...")
                    } else if (listv.hasMore){
                        return qsTr("加载更多")
                    }
                    return qsTr("全部加载完毕")
                }

                anchors.centerIn: parent
                font.pointSize: 14
            }
        }
    }

    //样式1
    Component { //加载动画: 滑动-小变大
        id: normalDelegate
        Rectangle {
            id: rect
            width: root.width; height: listViewHeight * 0.8
            color: "skyBlue"
            border.color: "black"
            radius: 3
            scale: 0.6   //缩放动画
            property int currentIndex: 0

            Component.onCompleted: {
                sa.start()
            }
            Column {
                Text {
                    text: '<b>Name:</b> ' + name
                    color: currentIndex == index ? "red" : "black"
                }
                Text { text: '<b>Number:</b> ' + number }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentIndex = index
                }
            }

            NumberAnimation {
                id:sa
                target: rect
                property: "scale"
                duration: 800
                to:1
                easing.type: Easing.InOutQuad
            }
        }
    }

    ListModel {
        id: listModel
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
