import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.0
import QKit 1.0
import "."
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/config.js" as Config

Rectangle{
    id: root
    width: Utl.dp(50)
    height: Utl.dp(50)
    color: Color.Clear
    radius: root.width/2  //默认为圆的
    smooth: true
    antialiasing: true
    clip: true

    property real borderScape: 0   //图片与线框的间距
    property alias colorMask: _colorMask
    property alias source: _img.source
    property alias defaultSource: _img.defaultSource
    property bool selected: false

    Rectangle{
        id: _mask
        anchors.fill: parent
        anchors.margins: root.border.width + borderScape - 1
        radius: root.radius
        color:  "#fff"
        smooth: true
    }

    ImageLoader{
        id: _img
        anchors.fill: parent
        anchors.margins: root.border.width + borderScape - 1
        image.fillMode: Image.PreserveAspectCrop
        defaultSource: Config.DefaultImage
        smooth: true
        antialiasing:true
        image.sourceSize.width: 140
        image.sourceSize.height:140
        visible: false
    }

    OpacityMask {
        anchors.fill: _mask
        source: _img
        maskSource: _mask
    }

    Rectangle{
        id: _colorMask
        anchors.fill: parent
        color: "#60000000"
        visible: selected
        radius: parent.radius
    }
}


