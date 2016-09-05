import QtQuick 2.0
import QtQml.Models 2.1
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    Component.onCompleted: {
        for(var i = 0; i < 30; i++) {
            _model_in.append({})
        }
    }

    ListView {
        id: _listView
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 250
        focus: false
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds

        model: ObjectModel {
            id: _model
            Rectangle {
                width: _listView.width
                height: _listView.height
                color: "green"
            }
            ListView {
                width: _listView.width
                height: _listView.height
                delegate: Rectangle{
                    width: _listView.width
                    height: Utl.dp(120)
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Utl.dp(10)
                        opacity: .5
                        color: "blue"
                    }
                }
                model: _model_in
            }
        }
    }

    ListModel {
        id: _model_in
    }

    NavigationBar {
        id: navbar
        title: "PageView"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
}

