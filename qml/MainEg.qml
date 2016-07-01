import QtQuick 2.0
import "controls"
import "app"
import "ui"
import "js"
import "window"
import "toolsbox/tools.js" as Tools
import "toolsbox/color.js" as Color


Item {
    id: root
    anchors.fill: parent

    Component.onCompleted: {
        Tools.setMainForm(root)
        var items = [];
        var views = [app, ui, js, wn];
        var pros = [{"label.text":qsTr("APP")/*,"icon.normalSource":"qrc:/res/tab_project.png","icon.selectedSource":"qrc:/res/tab_project_s.png"*/}
                    ,{"label.text":qsTr("UI")}
                    ,{"label.text":qsTr("JS")}
                    ,{"label.text":qsTr("WIN")}];
        for(var i = 0; i < views.length; ++i){
            items.push({barItem:tab, barItemProperties:pros[i], view:navigation, viewProperties:{initialItem:views[i]}});
        }
        tabView.tabs = items;
    }


    TabView {
        id: tabView
        width: parent.width
        height: parent.height
    }

    Component{
        id:tab
        TabItem {   //底部导航栏Item
            id:ti
            width: parent.width
            height: Utl.dp(40)
            anchors.bottom: parent.bottom
            color: Color.Clear
            label.color: ti.selected ? "#212324" : "#5d6366"
        }
    }

    Component{
        id: navigation
        NavigationView {
            id: stackView
        }
    }

    Component {
        id: app
        AppIn{}
    }

    Component {
        id: ui
        UiIn{}
    }

    Component {
        id: js
        JsIn{}
    }

    Component {
        id: wn
        WindowIn {}
    }
}

/************View 模板********************


import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "AnimatedImage(Sprite)"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.topMargin: Utl.dp(10)
        contentHeight: _col.height + Utl.dp(20)
        Column {
            id: _col
            width: parent.width
            height: childrenRect.height

        }
    }
}


*/
