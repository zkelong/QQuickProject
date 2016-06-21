import QtQuick 2.0
import "../../controls"

View {
    id: root

    property int loadTimes: 3
    property int page: 0

    Component.onCompleted: {
        loadListData()
    }

    PullListViewLR {
        id: listView
        height: 200
        width: parent.width
        anchors.top: titleBar.bottom
        clip: true
        spacing: 10
        model: listModel
        delegate: normalDelegate

        onLoadMore: {
            page += 1
            console.log("load more....")
            timer.start()
        }
    }

    //数据源
    ListModel {
        id:listModel
    }
    //样式
    Component {
        id: normalDelegate
        Rectangle {
            width: 200; height: listView.height
            color:"#f3f303"

            Column {
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: '<b>Name:</b> ' + name
                    font.pointSize: 14
                    color: listView.currentIndex == index ? "red" : "black"
                }
                Text {
                    text: '<b>Number:</b> ' + number
                    font.pointSize: 12
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index
                }
            }
        }
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }

    function loadListData() {
        listView.loading = false
        console.log("load.....", page, loadTimes)
        if(page > loadTimes) {
            listView.hasMore = false
        }
        for(var i = 0; i < 5; i++) {
            var item = {
                name: "我是谁" + ((page - 1) * 5 + i + 1),
                number: "我就是我" + i
            }
            listModel.append(item)
        }
        console.log(listView.loading)
    }

    Timer {
        id: timer
        interval: 3800
        repeat: false
        triggeredOnStart: false  //false--开始时不触发onTriggered()信号；true--开始时触发onTriggered()信号
        onTriggered: {
            console.log("bupao??????")
            loadListData()
        }
    }
}

