import QtQuick 2.0
import QtGraphicalEffects 1.0

/**
具有毛玻璃效果的视图
    属性target：目标控件。要求与本控件位于同一坐标系
    若本视图遮盖住目标控件，遮盖部分显示毛玻璃效果
*/
Item{
    id: panelFg
    width: 200
    height: 200
    clip: true

    // 属性
    property Item target : null  // 模糊源
    property bool dragable : true   // 是否可拖动
    property alias radius: blur.radius

    // 毛玻璃效果
    FastBlur {
        id: blur
        source: parent.target
        width: source.width;
        height: source.height
        radius: 64
    }

    // 可拖移
    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: dragable ? parent : null
    }

    // 设置模糊组件的位置
    onXChanged: setBlurPosition();
    onYChanged: setBlurPosition();
    Component.onCompleted: setBlurPosition();
    function setBlurPosition(){
        blur.x = target.x - x;
        blur.y = target.y - y;
    }
}

