import QtQuick 2.0
import QtQuick.Controls 1.3

/**
* 相片查看类似
* 展示图片组
*/
Rectangle {
    id: root
    color: "#000000"
    visible: false
    scale: 0.6
    enabled: scale == 1

    property ListModel picsData: null   //待展示的图片 {picUrl: ""}
    property alias currentIndex: _listView.currentIndex //显示第几张

    property bool _operateShow: true    //true-显示操作; false-隐藏操作

    onPicsDataChanged: {
        if(picsData && picsData.count > 0) {
            loadedPics.clear()
            for(var i = 0; i < picsData.count; i++) {   //listvie位置留位置
                loadedPics.append({picUrl: "", loaded: false, picShow: false})
            }
        }
    }

    ListView {
        id: _listView
        width: parent.width
        height: parent.height
        snapMode: ListView.SnapOneItem      //ListView.nosnap(默认)；ListView.SnapOneItem(一次滑动一页)；ListView.snaptoitem(一页显示多个Item，间隔)
        orientation: ListView.Horizontal    //横向
        layoutDirection: Qt.LeftToRight     //横向-顺序是从左到右
        delegate: delegeate
        model: loadedPics
        currentIndex: 0
        clip: true
        onFlickEnded: { //滑动结束
            //计算滑动到第几张，加载显示第几张图片
            currentIndex = contentX / root.width
            showNearbyPic(currentIndex)
            if(loadedPics.get(currentIndex).loaded === false) {
                loadedPics.get(currentIndex).picUrl = picsData.get(currentIndex).picUrl
                loadedPics.get(currentIndex).loaded = true
            }
        }
    }

    ListModel { //显示到listView的图片
        id: loadedPics
    }

    Component {     //图片显示
        id: delegeate
        Rectangle {
            width: root.width
            height: root.height
            color: "#000000"
            onFocusChanged: {
                if(!focus)
                    img.resetNormalSize()
            }

            FlickableImage{
                id: img
                minWidth: root.width - Utl.dp(10)
                minHeight: root.height - Utl.dp(10)
                width: root.width - Utl.dp(10)
                height: root.height - Utl.dp(10)
                anchors.centerIn: parent
                image.visible: picShow   //节约内存
                imageUrl: picUrl
                onClicked: {
                    resetNormalSize()
                    hide()
                }
            }
        }
    }

    PropertyAnimation { //显示动画
        id: anim
        target: root
        properties: "scale"
        from: root.scale
        duration: 300
        to: {
            if(_operateShow)  //显示操作
                return 1.0
            else
                return 0.6
        }
        onStarted: {
            if(_operateShow)
                root.visible = true
        }
        onStopped: {
            if(!_operateShow)
                root.visible = false
        }
    }

    //显示
    function show(index) {
        if(anim.running)
            return
        _listView.currentIndex = index  //显示第index张
        if(loadedPics.get(currentIndex).loaded === false) {
            loadedPics.get(currentIndex).picUrl = picsData.get(currentIndex).picUrl
            loadedPics.get(currentIndex).loaded = true
        }
        showNearbyPic(index)

        _operateShow = true
        _listView.contentX = root.width * _listView.currentIndex
        anim.start()
    }

    function showNearbyPic(index) { //为节约内存只显示靠近3张图片--3张不够
        //当前三张显示出来
        loadedPics.get(index).picShow = true
        if(index > 0) {
            loadedPics.get(index-1).picShow = true
        }
        if(index < loadedPics.count - 2) {
            loadedPics.get(index+1).picShow = true
        }
        if(index > 3) { //--切换快了，显示不出来--可见的整多点（7）
            loadedPics.get(index-4).picShow = false
        }
        if(index < loadedPics.count - 5) {
            loadedPics.get(index+4).picShow = false
        }
    }

    //隐藏
    function hide() {
        if(anim.running)
            return
        _operateShow = false
        anim.start()
    }
}

