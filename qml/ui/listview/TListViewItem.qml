import QtQuick 2.4
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property var lastShowItem;
    property int lastShowIndex: -1

    Component.onCompleted: {
        setList()
    }

    NavigationBar {
        id: navbar
        title: "ListViewItem"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    ListView {
        id: listView
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        model: _model
        delegate: _delegate
        spacing: Utl.dp(3)
        clip: true
        currentIndex: -1
    }

    ListModel {
        id: _model
    }

    Component{
        id: _delegate
        Rectangle {
            width: root.width
            height: rect.y + rect.height

            Rectangle {
                id: rect_s
                width: parent.width
                height: Utl.dp(55)
                color: "white"
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    font.pointSize: FontUtl.FontSizeMidA
                    color: "darkGreen"
                    text: str
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index
                        if(showC) {
                            hide.start()
                        } else {
                            show.start()
                        }
                        //挪到屏幕外，有时候认不到
                        if(lastShowIndex != index && lastShowIndex != -1)
                            _model.get(lastShowIndex).showC = false
                        if(lastShowIndex != index && lastShowItem && typeof(lastShowItem.hideRect) === "function") {
                            lastShowItem.hideRect()
                        }
                    }
                }
            }
            Rectangle {
                id: rect
                width: parent.width
                height: 0
                anchors.top: rect_s.bottom
                color: "lightGreen"
                border.width: 1
            }
            PropertyAnimation {
                id: show
                duration: 500
                target: rect
                properties: "height"
                from: 0
                to: Utl.dp(25)
                onStopped: {
                    rect_s.color = "skyBlue"
                    _model.get(index).showC = true
                    lastShowIndex = index
                    lastShowItem = listView.currentItem
                }
            }
            PropertyAnimation {
                id: hide
                duration: 500
                target: rect
                properties: "height"
                from: rect.height
                to: 0
                onStopped: {
                    rect_s.color = "white"
                    _model.get(index).showC = false
                }
            }
            function hideRect() {
                hide.start()
            }
        }
    }

    function setList() {
        for(var i = 0; i < 38; i++) {
            var item = {
                str: "xx" + i
                ,showC: false
            }
            _model.append(item)
        }
    }
}

