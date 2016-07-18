import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property real topCompHeight: Utl.dp(250)
    property var topItem
    property bool reload: true

    Component.onCompleted: {
        _lazyLoad.start()
    }

    Timer {
        id: _lazyLoad
        interval: 2000
        repeat: false
        running: false
        onTriggered: {
            loadDate()
        }
    }

    PullListView {
        id: listView
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        clip: true
        model: _model
        delegate: _delegate
        onReload: {
            root.reload = true
            loadDate()
        }
        onLoadmore: {
            loadDate()
        }
    }

    ListModel {
        id: _model
    }

    Component {
        id: _delegate
        Rectangle {
            width: root.width
            height: Utl.dp(80)
            Text {
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeMidD
                color: Color.GreenTheme
                text: showText
            }
            Line {
                visible: index == 0
                anchors.top: parent.top
            }
            Line {
                anchors.bottom: parent.bottom
            }
        }
    }

    Component {
        id: topComp
        Rectangle {
            width: root.width
            height: topCompHeight
            border.width: Utl.dp(1)
            Text {
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeMidD
                text: qsTr("新加的栏")
                color: "blue"
            }
        }
    }

    NavigationBar {
        id: navbar
        title: "PullListView"
        onButtonClicked: {
            root.navigationView.pop()
        }

        Button {
            height: parent.height
            width: Utl.dp(120)
            anchors.right: parent.right
            label.text: qsTr("加一栏/加载延时")
            label.font.pointSize: FontUtl.FontSizeSmallB
            onClicked: {
                if(!topItem) {
                    console.log("creat...")
                    topItem = topComp.createObject(listView.contentItem)
                    topItem.y = -topCompHeight
                    listView.topMargin = topCompHeight
                    listView.contentY = -topCompHeight
                    listView.oldTopMargin = topCompHeight
                } else {
                    if(_timer.interval < 2000)
                        _timer.interval += 500
                    else
                        _timer.interval = 2
                }
            }
        }
    }

    Timer {
        id: _timer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            console.log("interval....", _timer.interval)
            getDate()
        }
    }

    function loadDate() {
        listView.startLoading(reload)
        _timer.start()
    }

    function getDate() {
        listView.stopLoading(reload)
        if(reload) {
            _model.clear()
            reload = false
        }
        for(var i = 0; i < 10; i++) {
            var item = {
                showText: "cellXXX" + i
            }
            _model.append(item)
        }
        if(_model.count > 30) {
            listView.hasMore = false
        } else {
            listView.hasMore = true
        }
    }
}

