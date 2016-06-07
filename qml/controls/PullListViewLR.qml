import QtQuick 2.4
import "./color.js" as Color
import "./font.js" as FontUtl

ListView {
    id:root
    orientation: ListView.Horizontal //横向
    layoutDirection: Qt.LeftToRight //横向
    footer: moreComponent

    property bool loading: false //是否正处于加载中
    property bool hasMore: true //是否还有更多

    property int footWidth: Utl.dp(60)
    signal loadMore //加载更多

    Component{
        id:moreComponent
        Rectangle{
            id: foot
            property alias label: _label
            width: footWidth
            height: root.height
            visible: root.count > 4
            color: "transparent"
            Text {
                id:_label
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeSmallB
                color: "#828282"
                text: {
                    if(root.loading){
                        return qsTr("加载中...")
                    } else if (root.hasMore){
                        return qsTr("加载更多")
                    }
                    return qsTr("加载完了")
                }
            }
        }
    }

    //拉动到位置，立即开始加载
    onContentXChanged: { //在滚动过程中计算滚动值，更新加载元素的状态
        if(loading)
            return
        if(root.hasMore && root.contentWidth > root.width){
            if(root.contentX + root.width >= (root.contentWidth - root.footerItem.width/2)){//加载更多
                loading = true
                loadMore()
            }
        }
    }
}

