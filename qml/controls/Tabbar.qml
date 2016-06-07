import QtQuick 2.4

import "../controls"
import "../toolsbox/tools.js" as Tools

/**
* 底部按钮条
*/

// 模型：{"component":obj, "properties":obj}
// component 组件（着色器）,必须实现 selected属性和clicked信息号
// properties 组件属性
// 元素可以是上面的模型(可以设置额外属性),也可以是组件本身

Rectangle {
    id:tabbar
    height: Utl.dp(50)

    signal itemSelected
    property Component background: null  //背景着色器
    property Component separator: null   //分隔符着色器
    property int selectedIndex: 0  //当前选中的是哪个
    property bool isHide: true //初始隐藏

    property var items: [] //bar item 元素着色器组,有多少个就创建多少个元素

    property var _backgroundObj: null //背景着色器实例
    property var _barItems: []  //元素着色器实例对象组
    property var  _separators: ({}) //放置分隔线的实例

    onWidthChanged: {
        _layout();
    }

    onSelectedIndexChanged: {

        if (!_barItems || !_barItems.length)
            return

        for (var i = 0; i < _barItems.length;++i){
            _barItems[i].selected = false;
        }
        _barItems[selectedIndex].selected = true;
        tabbar.itemSelected();

        console.log("selectedIndex = " + selectedIndex)
    }

    function _layout(){
        if (!_barItems || !_barItems.length)
            return

        var _separatorsWidth = 0;
        for(var key in _separators){
            _separatorsWidth += _separators[key].width;
        }

        var itemWidth = (tabbar.width - _separatorsWidth)/_barItems.length;

        for (var i = 0; i < _barItems.length;++i){
            _barItems[i].width = itemWidth;
            _barItems[i].z = i;
        }
        //        container.update()
    }


    onItemsChanged: {
        var children = container.children
        if (children && children.length){
            for (var i = 0; i < children.length;++i){
                var ch = children[i];
                ch.destroy();
            }
        }
        _barItems = [];
        _separators = {};

        if (items && items.length) {
            for (i = 0; i < items.length; ++i){
                var item = items[i];
                var sep = null;
                if (separator && i != 0){
                    sep = separator.createObject(container);
                }

                var obj = null;
                if (item["component"]){
                    obj = item["component"].createObject(container,item["properties"]);
                } else {
                    obj = item.createObject(container);
                }

                if (sep){
                    _separators[obj] = sep;
                }

                _barItems.push(obj);
            }
            _layout();
            if (selectedIndex < _barItems.length){
                _barItems[selectedIndex].selected = true;
            }
        }
    }

    Row{
        id:container
        spacing: 0
        anchors.fill: parent
    }

    MouseArea{
        id:mouse
        anchors.fill: parent
        onClicked: {
            var pt = Qt.point(mouseX,mouseY)
            for (var i = 0; i < items.length;++i){

                var item = _barItems[i];
                pt.x = mouseX - item.x;
                pt.y = mouseY - item.y;
                if (item.contains(pt)){

                    tabbar.selectedIndex = i;
                    return;
                }
            }
        }
    }

    PropertyAnimation {  //显示隐藏动画
        id: animation
        target: tabbar
        duration: 800
        properties: "y"
        property int movedBegin: 0  //移动开始位置 --动画终止用
        property int movedEnd: tabbar.height   //移动结束位置
        onStopped: {
            tabbar.enabled = true
            movedEnd = tabbar.y
        }
        onStarted: {
            tabbar.enabled = false
            movedBegin = tabbar.y
        }
    }

    //useAnimatoion使用动画
    function hide(useAnimation) { //隐藏下方按钮条
        if(isHide)
            return
        useAnimation = useAnimation || false
        if(useAnimation) {
            animation.stop();
            isHide = true
            animation.from = tabbar.y
            animation.to = tabbar.y + tabbar.height
            animation.start();
        } else {
            tabbar.visible = false
        }
    }

    function show(useAnimation) {  //显示下方按钮条
        if(!isHide)
            return
        useAnimation = useAnimation || false
        if(useAnimation) {
            animation.stop();
            isHide = false
            animation.from = tabbar.y
            animation.to = tabbar.y - Math.abs(animation.movedBegin - animation.movedEnd) //执行隐藏到一半，又执行显示
            animation.start();
        } else {
            tabbar.visible = false
        }
    }


    function addItem(component,properties){
        if (separator && _barItems.length){
            var sep = separator.createObject(container);
        }
        var obj = null;
        if(properties){
            obj = component.createObject(container,properties)
            items.push({component:component, properties:properties});
        } else {
            obj = component.createObject(container)
            items.push(component);
        }

        if (sep){
            _separators[obj] = sep;
        }

        _barItems.push(obj);
        _layout();
    }


    function removeItem(index){
        items.splice(index,1);
        var obj = _barItems[index];
        if (_separators[obj]){
            _separators[obj].destroy();
            delete _separators[obj];
        }

        obj.destroy();
        _barItems.splice(index,1);
        _layout();
    }

    function getItem(index){
        return _barItems[index];
    }

}

