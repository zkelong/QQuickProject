import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property int page: 0

    Component.onCompleted: {
        loadData()
    }

    WaterfallView {
        id: _waterfall
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        delegate: _delegate
        onReload: {
            page = 0
            loadData()
        }
        onLoadmore: {
            page++
            loadData()
        }
    }

    NavigationBar {
        id: navbar
        title: "WaterfallView"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Component {
        id: _delegate
        Rectangle {
            width: (root.width - 30)/2
            height: childrenRect.height > 0 ? childrenRect.height : width
            Image {
                anchors.top: parent.top
                width: parent.width
                fillMode: Image.PreserveAspectFit
                source: picUrl
            }
        }
    }

    Timer {
        id: _timer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            getData()
        }
    }

    function loadData() {   //加载数据
        _waterfall.startLoading(page===0)
        _timer.start()
    }

    function getData() {
        _waterfall.stopLoading()
        var data = []
        if(page === 0) {
            _waterfall.data = []
            var pic = ["http://img2.3lian.com/2014/f2/144/d/59.jpg",
                    "http://pic3.nipic.com/20090529/2711368_174536043_2.jpg",
                    "http://p9.qhimg.com/t013d4a160e61ec8a80.jpg",
                    "http://pic31.nipic.com/20130702/6858319_221908434119_2.jpg",
                    "http://cdn.duitang.com/uploads/item/201409/18/20140918053430_3jBHJ.thumb.700_0.jpeg",
                    "http://www.myjy.com/upload/experience/20120915/20120915111642174.jpg",
                    "http://img2.duitang.com/uploads/item/201302/19/20130219115924_ZLNnS.thumb.600_0.jpeg",
                    "http://img4.duitang.com/uploads/item/201204/06/20120406170408_JdUyx.thumb.600_0.jpeg"]
            for(var i = 0; i < pic.length; i++) {
                var item = {}
                item.picUrl = pic[i]
                data.push(item)
            }
            _waterfall.hasMore = true
        } else {
            var pics = ["http://www.52tq.net/d/file/a/remenhuati/remenhuati/2015-11-24/ba76e390bc598de9ea708ae966bc1465.jpg",
                    "http://img.ifeng.com/res/201001/0125_909092.jpg",
                    "http://s2.img.766.com/155/120331/0921/239192.jpg",
                    "http://k.zol-img.com.cn/gamebbs/46/a45085_s.jpg",
                    "http://images2.china.com/game/zh_cn/onlinegame/jiong/11083938/20120331/2012033109545784886400.jpg",
                    "http://imgsrc.baidu.com/forum/pic/item/8694a4c27d1ed21b6ac5745aad6eddc451da3f04.jpg",
                    "http://imgk.zol.com.cn/gamebbs/46/a45081.jpg",
                    "http://images2.china.com/game/zh_cn/onlinegame/jiong/11083938/20120331/2012033109545740120800.jpg"]
            for(var j = 0; j < pics.length; j++) {
                var itemx = {}
                itemx.picUrl = pics[i]
                data.push(itemx)
            }
            _waterfall.hasMore = false
        }
        _waterfall.data = data
    }
}

