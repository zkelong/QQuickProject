import QtQuick 2.4
import QtGraphicalEffects 1.0

/**
  *按钮
  *背景：图片-默认/选中
  *图标：图片-默认/选中
  *文字，在图标右边--字体更改
  */
Rectangle {
    id: button
    color: "transparent"

    signal clicked(var button)  //点击事件
    signal pressed(var button)  //按下事件
    signal released(var button) //释放事件

    property bool scaleOnPressed: true //按下时是否显示缩放效果
    property alias label: txt //标题label
    property alias font: txt.font //标题字体
    property alias icon: _icon //图标--大小没有控制的，可能超出button的大小
    property alias backgroundImage: _backgroudImage //背景图片
    property var group: null   //分组，用于单选

    property alias container: row

    property bool selected: false //是否处于选中状态
    property bool holding: false  //是否正处理按住不放的状态

    function resize(){
        if(button.implicitWidth == 0){
            button.implicitWidth = Utl.dp(2) + _icon.width + _icon.anchors.leftMargin + _icon.anchors.rightMargin + label.width + label.anchors.leftMargin + label.anchors.rightMargin;
        }

        if(button.implicitHeight == 0){
            var _iconHeight = _icon.height + _icon.anchors.topMargin + _icon.anchors.bottomMargin;
            var labelHeight = label.height + label.anchors.topMargin + label.anchors.bottomMargin;
            button.implicitHeight = Math.max(_iconHeight, labelHeight) + Utl.dp(2);
        }

        if (_icon.height > button.height){
            var height = button.height - _icon.anchors.topMargin - _icon.anchors.bottomMargin;
            _icon.width = _icon.width * height/ _icon.height;
            _icon.height = height;
        }
    }

    onEnabledChanged: {
        backgroundImage.enabled = button.enabled;
        _icon.enabled = button.enabled;
    }

    onGroupChanged: {
        if (button.group != null){
            button.group.addButton(button)
        }
    }

    onSelectedChanged: {
        if (!button.enabled)
            return

        _icon.selected = button.selected;
        _backgroudImage.selected = button.selected;
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!button.enabled)
                return
            button.clicked(button)
        }

        onPressed: {
            if (!button.enabled)
                return
            holding = true;
            _icon.selected = holding;
            if(scaleOnPressed){
                _icon.scale = 0.8;
                _backgroudImage.scale = 0.8;    //背景图片也会有缩放
                label.scale = 0.8;
            }
            _backgroudImage.selected = holding;
            button.pressed(button);
        }

        onReleased: {
            if (!button.enabled || selected)
                return

            holding = false;
            _icon.selected = holding;
            if(scaleOnPressed){
                _icon.scale = 1.0;
                _backgroudImage.scale = 1.0;
                label.scale = 1.0;
            }
            _backgroudImage.selected = holding;
            button.released(button);
        }
    }

    StatusImage {
        id:_backgroudImage
        smooth: true
        anchors.fill: parent
        selected: selected
    }


    Row{
        id:row
        height: parent.height
        anchors.centerIn: parent
        spacing: 5

        StatusImage{
            id:_icon
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
            selected: selected
            onChildrenChanged: {
                resize()
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 13
            color: "#000000"
            id: txt
        }
    }

    onChildrenRectChanged: {
        resize()
    }
}

