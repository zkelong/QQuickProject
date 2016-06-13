import QtQuick 2.0
import QtQuick.Controls 1.3

import "."

Item {
    id: root

    property var dataList: []   //数据
    property var delegate   //样式




//    Component.onCompleted: {
//        reLoadData()
//    }

//    function reLoadData() {
//        lvm1.clear()
//        lvm2.clear()
//        var pic = ["http://img2.3lian.com/2014/f2/144/d/59.jpg",
//                "http://pic3.nipic.com/20090529/2711368_174536043_2.jpg",
//                "http://p9.qhimg.com/t013d4a160e61ec8a80.jpg",
//                "http://pic31.nipic.com/20130702/6858319_221908434119_2.jpg",
//                "http://cdn.duitang.com/uploads/item/201409/18/20140918053430_3jBHJ.thumb.700_0.jpeg",
//                "http://www.myjy.com/upload/experience/20120915/20120915111642174.jpg",
//                "http://img2.duitang.com/uploads/item/201302/19/20130219115924_ZLNnS.thumb.600_0.jpeg",
//                "http://img4.duitang.com/uploads/item/201204/06/20120406170408_JdUyx.thumb.600_0.jpeg"]
//        for(var i = 0; i < pic.length; i++) {
//            var item = {}
//            item.picUrl = pic[i]
//            if(i%2 == 0) {
//                lvm1.append(item)
//            } else if(i%2 == 1){
//                lvm2.append(item)
//            }
//        }
//        pullflick.stopLoading(true)
//    }

//    function loadMoreData() {
//        var pic = ["http://www.52tq.net/d/file/a/remenhuati/remenhuati/2015-11-24/ba76e390bc598de9ea708ae966bc1465.jpg",
//                "http://img.ifeng.com/res/201001/0125_909092.jpg",
//                "http://s2.img.766.com/155/120331/0921/239192.jpg",
//                "http://k.zol-img.com.cn/gamebbs/46/a45085_s.jpg",
//                "http://images2.china.com/game/zh_cn/onlinegame/jiong/11083938/20120331/2012033109545784886400.jpg",
//                "http://imgsrc.baidu.com/forum/pic/item/8694a4c27d1ed21b6ac5745aad6eddc451da3f04.jpg",
//                "http://imgk.zol.com.cn/gamebbs/46/a45081.jpg",
//                "http://images2.china.com/game/zh_cn/onlinegame/jiong/11083938/20120331/2012033109545740120800.jpg",]
//        var tag = 0;
//        console.log("height: ", lv1.height, lv2.heigh, " contentHeight: ", lv1.contentHeight, lv2.contentHeight)
//        if(lv1.height > lv2.heigh)
//            tag = 1
//        for(var i = 0; i < pic.length; i++) {
//            var item = {}
//            item.picUrl = pic[i]
//            if(i%2 == tag) {
//                lvm1.append(item)
//            } else if(i%2 == 1){
//                lvm2.append(item)
//            }
//        }
//    }

//    PullFlickable {
//        id: pullflick
//        width: parent.width
//        anchors.top: titleBar.bottom
//        anchors.bottom: parent.bottom
//        contentHeight: row.height
//        clip: true
//        onReload: reLoadData()
//        onLoadMore: loadMoreData()

//        Row {
//           id: row
//           anchors.left: parent.left; anchors.right: parent.right
//           anchors.top: parent.top; anchors.topMargin: 10
//           width: root.width - 20
//           height: childrenRect.height
//           anchors.margins: 10
//           spacing: 10

//           ListView {
//               id: lv1
//               width: (root.width - 30)/2
//               interactive: false
//               height: childrenRect.height
//               model: lvm1
//               delegate: lvd
//               spacing: 10
//           }
//           ListView {
//               id: lv2
//               width: (root.width - 30)/2
//               height: childrenRect.height
//               interactive: false
//               model: lvm2
//               delegate: lvd
//               spacing: 10
//           }
//        }
//    }

//    ListModel { id: lvm1 }
//    ListModel { id: lvm2 }

//    Component {
//        id: lvd
//        Rectangle {
//            width: (root.width - 30)/2
//            height: childrenRect.height
//            Image {
//                anchors.top: parent.top
//                width: parent.width
//                fillMode: Image.PreserveAspectFit
//                source: picUrl
//            }
//        }
//    }
}
