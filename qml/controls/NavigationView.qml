import QtQuick 2.0
import QtQuick.Controls 1.3
import "../toolsbox/tools.js" as Tools

StackView{
    id:root
    anchors.fill: parent
    enabled: !root.busy     //切换界面，多次点击，就第一次有效

    property var tabView: null  //TabView
    property alias busy: root.busy
    property alias currentItem: root.currentItem
    property alias depth: root.depth        //stackView中View的数量
    property alias initialItem: root.initialItem

    onCurrentItemChanged: {
        root.focus = false
        Qt.inputMethod.hide()
        if(root.currentItem){
            if(root.currentItem.navigationView === null){
                Tools.registStack(root)     //stackView
                root.currentItem.navigationView = root; //给每个view的StackView赋值
            }
            if(root.tabView){   //是否显示底部栏
                root.tabView.tabbarVisible = !root.currentItem.hidenTabbarWhenPush;
            }
        }
    }
}

//StackView切换方法
/*
.push()--item, properties, immediate, replace, destroyOnPop
.pop()--item, immediate(bool-隐藏切换效果(true))
    var item = .get(.depth - 2) //get()--从0开始；depth--从1开始
    .pop({item:item})
*/


