import QtQuick 2.4
import "./font.js" as FontUtl
import "./color.js" as Color

/**
* 底部弹出选择项
*/
Rectangle {
    id:root
    clip: true
    anchors.fill: parent
    color: "#33000000"
    visible: false

    signal itemSelected(int idx); //用户选择了某项--idx：0-取消
    property var items: []    //选择项目--["男", "女"]

    function show(){    //显示
        root.visible = true;
        //animate.from = root.height;
        animate.to = root.height - container.height;
        animate.start();
    }

    function hide(){    //隐藏
        animate.to = root.height;
        //animate.from = root.height - container.height;
        animate.start();
    }

    NumberAnimation {
        id:animate
        target: container
        property: "y"
        duration: 300
        easing.type: Easing.InOutBack
        onStopped: {
            if(animate.to == root.height) {
                root.visible = false;
            }
        }
    }

    onItemsChanged: {
        var children = itemContainer.children
        if (children && children.length){
            for (var i = 0; i < children.length;++i){
                var ch = children[i];
                ch.destroy();
            }
        }

        for(i = 0; i < items.length; ++i){
            var obj = cellComponent.createObject(itemContainer,{index:i + 1, title:items[i]})

        }
        itemContainer.update();
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {}
    }

    Item {
        id: container
        width: parent.width
        height: itemBg.height + cancelItem.height + Utl.dp(30)
        y: root.height

        Rectangle{
            id:itemBg
            radius: Utl.dp(5)
            clip:true
            width: parent.width
            height: itemContainer.height
            anchors.left: parent.left; anchors.leftMargin: Utl.dp(10);
            anchors.right: parent.right; anchors.rightMargin: Utl.dp(10)
            Column{
                id:itemContainer
                spacing: 0
                width: parent.width
                height: childrenRect.y + childrenRect.height
            }
            anchors.bottom: cancelItem.top; anchors.bottomMargin: Utl.dp(10)
        }

        Loader{
            id:cancelItem
            sourceComponent: cellComponent
            anchors.left: parent.left; anchors.leftMargin: Utl.dp(10);
            anchors.right: parent.right; anchors.rightMargin: Utl.dp(10)
            anchors.bottom: parent.bottom; anchors.bottomMargin: Utl.dp(20)
            onLoaded: {
                item.title = qsTr("取消");
                item.text.font.weight = Font.Bold;
                //item.radius = Utl.dp(5);
            }
        }
    }

    Component{      //选项样式
        id:cellComponent
        Rectangle{
            id:cellItem
            color:Color.White
            property int index: 0
            property alias title: _text.text
            property alias text: _text
            height: Utl.dp(40); width:parent.width
            clip: true

            Text{
                id:_text
                anchors.fill: cellItem
                font.pointSize: FontUtl.FontSizeMidB
                color: Color.Blue
                verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
            }

            MouseArea{
                anchors.fill: parent
                onClicked: root.itemSelected(index)
            }

            Line{
                anchors.bottom: parent.bottom
                visible: index != 0
            }
        }
    }
}

