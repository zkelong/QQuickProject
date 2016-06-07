import QtQuick 2.4
import "../toolsbox/tools.js" as Tools

/**
* tabView
*/

// {barItem:obj, barItemProperties:obj, view:obj, viewProperties:obj}
// barItem:  tabbar item的着色器
// barItemProperties:  barItem 着色器属性
// view: 主view着色器
// viewProperties: 主view的属性

Rectangle {
    id: tabView

    signal tabSelected;
    property alias selectedIndex: _tabbar.selectedIndex

    property var tabs: []  //Tab 对象
    property var views: [] //Tab中的view对象
    property alias tabbar: _tabbar
    property alias tabbarVisible: _tabbar.visible;

    onTabsChanged: {        //加载界面
        var children = contentView.children
        if (children && children.length){   //有内容先干掉
            for (var i = 0; i < children.length;++i){
                var ch = children[i];
                ch.destroy();
            }
        }
        views = [];
        var items = [];
        var tab,view;
        for (i = 0; i < tabs.length; ++i){
            tab = tabs[i];
            if(tab.barItemProperties){
                items.push({component:tab.barItem, properties:tab.barItemProperties});
            } else {
                items.push(tab.barItem)
            }

            if (tab.viewProperties){
                view = tab.view.createObject(contentView,tab.viewProperties);
            } else {
                view = tab.view.createObject(contentView);
            }

            views.push(view)
            if (view.hasOwnProperty("tabView")){
                view.tabView = tabView;
            }
            view.anchors.fill = contentView;
            view.visible =  _tabbar.selectedIndex == i;
        }
        _tabbar.items = items;
    }

    onTabbarVisibleChanged: {   //tabbar可见度变化，调整contentView的大小
        if (tabbarVisible){
            contentView.anchors.bottom = _tabbar.top;
        } else {
            contentView.anchors.bottom = tabView.bottom;
        }
    }

    Rectangle{  //view界面容器
        id: contentView
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: _tabbar.top
    }

    Tabbar{ //底部导航栏
        id:_tabbar
        isHide: false
        color: "#7ec242"
        width: parent.width
        height: Utl.dp(55)
        anchors.bottom: parent.bottom
        onItemSelected: {
            for(var i = 0; i < views.length; i++) {
                views[i].visible = selectedIndex == i;
            }
            tabView.tabSelected();
        }
    }

    Timer{
        id:timer
        running: false; repeat: false; interval: 1500
        onTriggered: {
            tabView.exit = false
        }
    }

    //取得指定tab的主view
    function getTab(index){
        return views[index];
    }

    //添加一个tab
    function addTab(tab){
        var view = null;
        if (tab.viewProperties){
            view = tab.view.createObject(contentView,tab.viewProperties);
        } else {
            view = tab.view.createObject(contentView);
        }

        if (view.hasOwnProperty("tabView")){
            view.tabView = tabView;
        }

        views.push(view)
        view.anchors.fill = contentView;
        view.visible =  _tabbar.selectedIndex == i;

        if(tab.barItemProperties){
            _tabbar.addItem({component:tab.barItem, properties:tab.barItemProperties});
        } else {
            _tabbar.addItem(tab.barItem)
        }
    }

    //根据所给的索引,移除一个tab
    function removeTab(index){
        views[index].destroy();
        views.splice(index,1);
        _tabbar.removeItem(index);
        if (index === selectedIndex){
            selectedIndex = 0;
        }
    }
}

