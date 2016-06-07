import QtQuick 2.0

/*
  TabItem组件必须实现 selected属性
*/
Rectangle{
    id: item
    height: Utl.dp(44)
    color: "transparent"
    anchors.verticalCenter: parent.verticalCenter

    property alias label: _txt
    property alias icon: _icon
    property bool hideIcon: true    //隐藏图片
    property bool selected: false

    property bool haveMessage: false    //有消息
    property bool showRedPoint: false   //显示红点

    Component.onCompleted: {
        if(hideIcon) {
            _txt.anchors.centerIn = item
        }
    }

    onSelectedChanged: {
        _icon.selected = selected;
    }

    StatusImage{    //图标
        id:_icon
        width: Utl.dp(22)
        height: Utl.dp(22)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Utl.dp(3)
        anchors.top: parent.top
        smooth: true
        selected: selected
    }

    Rectangle {     //红点
        width: Utl.dp(6); height: width; radius: width/2
        anchors.top: _icon.top; anchors.topMargin: -Utl.dp(1.2)
        anchors.left: _icon.right; anchors.leftMargin: -Utl.dp(7.5)
        color: "#ff0000"
        visible: haveMessage && showRedPoint
    }

    Text {  //文字
        id: _txt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Utl.dp(6)
        color: selected ? "#0000ff" : "#000000"
        font.family: "Arial"
        font.pointSize: 13
    }
}



