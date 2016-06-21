import QtQuick 2.0
import QtQuick.Controls 1.3

import "."
import "../toolsbox/font.js" as FontUtl

PullFlickable {
    id: root
    contentHeight: _row.height

    property int footHeight: Utl.dp(30)

    property bool clickLoadMore: false  //点击加载更多--默认是拉到底直接加载更多
    property bool isReload: false   //是否是重新加载

    property bool hasMore: false    //还有更多
    property var data: [] //数据
    property var delegate   //样式
    signal loadmore //加载更多

    onDataChanged: {
        if(data.length == 0) {
            hasMore = false
            return
        }
        if(isReload) {
            lvm1.clear()
            lvm2.clear()
        }
        for(var i = 0; i < data.length; i++) {
            if(lv1.height < lv2.height) {
                lvm1.append(data[i])
            } else if(lv1.height > lv2.height) {
                lvm2.append(data[i])
            } else {
                if(lvm1.count > lvm2.count) {
                    lvm2.append(data[i])
                } else {
                    lvm1.append(data[i])
                }
            }
        }
    }


    onReload: {
        isReload = true
        console.log("reload......")
    }

    onContentYChanged: {
        console.log("water....ContenY")
        if(root.hasMore && root.contentHeight > root.height){
            if(root.contentY - root.originY + root.height >= (root.contentHeight - _itemMore.height/2)){ //加载更多
                loading = true
                isReload = false
                loadmore()
            }
        }
    }

    Row {
        id: _row
        anchors.left: parent.left; anchors.right: parent.right
        anchors.top: parent.top; anchors.topMargin: 10
        width: root.width - 20
        height: childrenRect.height
        anchors.margins: Utl.dp(5)
        spacing: Utl.dp(5)

        ListView {
            id: lv1
            width: (root.width - Utl.dp(15))/2
            interactive: false
            height: childrenRect.height
            model: lvm1
            delegate: root.delegate
            spacing: Utl.dp(5)
        }
        ListView {
            id: lv2
            width: (root.width - Utl.dp(15))/2
            height: childrenRect.height
            interactive: false
            model: lvm2
            delegate: root.delegate
            spacing: Utl.dp(5)
        }
    }

    //加载更多
    Item {
        id: _itemMore
        visible: hasMore && lvm1.count > 0
        width: parent.width
        height: footHeight
        anchors.top: _row.bottom
        Text {
            id:_label
            anchors.centerIn: parent
            font.pointSize: FontUtl.FontSizeSmallA

            text: {
                if(root.loading){
                    return qsTr("正在加载更多...")
                } else if (root.hasMore){
                    return clickLoadMore ? qsTr("点击加载更多") : qsTr("加载更多")
                }
                return qsTr("全部加载完毕")
            }
        }
        MouseArea {
            visible: clickLoadMore && root.hasMore
            anchors.fill: parent
            onClicked: {
                isReload = false
                loadmore()
            }
        }
    }

    ListModel { id: lvm1 }
    ListModel { id: lvm2 }
}
