import QtQuick 2.4
import "../toolsbox/color.js" as Color
import "../toolsbox/tools.js" as Tools

//表情列表
Rectangle {
    color:Color.Clear

    property int columnNum: 4  //列数
    property int rowNum: 4  //行数

    property alias model: gridModel
    property alias delegate: gridView.delegate
    property alias cellWidth: gridView.cellWidth
    property alias cellHeight: gridView.cellHeight

    property var points: []

    ListView{
        id:listView
        anchors.fill: parent
        model: listModel
        delegate: Rectangle {
            width: listView.width
            height: listView.height
            color: Color.Clear
        }
        highlight: Rectangle{color:Color.Clear}
        highlightFollowsCurrentItem: true;
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        currentIndex: 0
        GridView{
            id: gridView
            width: parent.width
            height: cellHeight * rowNum
            anchors.top: parent.top
            flow:Grid.TopToBottom
            interactive: false
            model: gridModel
            clip: true
            cellWidth: width/columnNum
            cellHeight: cellWidth
            contentX: listView.contentX
        }
    }

    ListModel{
        id:listModel
        onCountChanged: {
            if(count > points.length) {
                var item = _pointItem.createObject(_rowPoint, {"index": count-1})
                points.push(item)
                if(points.length > 1 && !_rowPoint.visible)
                    _rowPoint.visible = true
            }
        }
    }

    ListModel{
        id: gridModel
        onCountChanged: {
            if(count > 0) {
                var pageNum = count / (columnNum * rowNum)
                if(pageNum > listModel.count) {
                    listModel.append({})
                }
            }
        }
    }

    Row{
        id: _rowPoint
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: listView.bottom
        spacing: Utl.dp(7)
    }

    Component{
        id: _pointItem
        Rectangle{
            property int index;
            width: Utl.dp(8)
            height: Utl.dp(8)
            radius: width/2
            color: "red"//"#4f4e54"
            opacity: index === listView.currentIndex ? 1 : 0.4
        }
    }
}

