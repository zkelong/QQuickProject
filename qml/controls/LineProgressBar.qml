import QtQuick 2.4
import "."
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

/**
*进度条
*/

Item {
    id:root
    height: bg_progress.y + bg_progress.height
    property double maximumValue: 100  //最大值, 将会取value/maximumValue的结果做为百分比
    property double minimumValue: 0 //最小值,如果value小于此值，那么使用此值做为计算标准
    property double value: 0 //当前值
    property double percent //: Math.max(value,minimumValue)/maximumValue //当前值和最大值的比值
    property alias color: progress.color
    property int barHeight: Utl.dp(2)
    property bool useAnimation: false

    function doAnimation(){
        pam.start()
    }

    onPercentChanged: {
        if(percent > 0 && !useAnimation) {
            if(percent >= 1)
                progress.height = width
            else
                progress.height = percent*width
        }
    }

    Text{
        id:text
        anchors.right: parent.right; anchors.rightMargin: Utl.dp(2)
        color: "white"
        font.pointSize: FontUtl.FontSizeSmallA
        text: parseFloat(percent*100).toFixed(2) + "%"
        visible: false
    }

    //底色
    Rectangle{
        id:bg_progress
        height: barHeight
        width: parent.width
        //opacity: 0.5
        color: "#dcdcdc"
        anchors.left: parent.left
        anchors.top: text.bottom
    }
    //进度显示
    Rectangle{
        id:progress
        height: 0; width: bg_progress.height
        anchors.verticalCenter: bg_progress.verticalCenter
        x: bg_progress.x + (height - width) / 2
        rotation: -90 //旋转90度，渐变
        color: "#67c2b0"

        //gradient: Gradient{   //渐变
        //    GradientStop{position:0;color:"#667b20"}
        //    GradientStop{position: 1.0;color:"#cbfd53"}
        //}

        NumberAnimation {
            id:pam
            target: progress; running: false;
            property: "height"
            duration: 800
            easing.type: Easing.InOutQuad
            from: 0; to: percent<1 ? percent*root.width : root.width
        }

        //PropertyAnimation on width {
        //    to: percent*root.width; duration: 1000; easing.type: Easing.InOutQuad;
        //}

    }

    Rectangle { //圆点
        anchors.verticalCenter: bg_progress.verticalCenter
        width: bg_progress.height * 3
        height: width
        radius: width/2
        color: "white"
        x: bg_progress.x + progress.height - width / 2
        visible: false
    }
}

