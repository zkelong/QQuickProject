import QtQuick 2.4
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl

Rectangle {
    id:root
    property alias content: _contentText.text //要显示的内容
    property int times: 1000    //显示时长

    color: "#88000000" //背景颜色
    visible: false
    anchors.centerIn: parent

    border.color: Color.Bordercolor
    border.width: Utl.dp(1)
    radius: Utl.dp(5)

    Text {  //提示文字
        id:_contentText
        anchors.centerIn: root
        font.pointSize: FontUtl.FontSizeMidD
        color: Color.White
        maximumLineCount: 10
        wrapMode: Text.WrapAnywhere
        lineHeight: lineCount == 1 ? 1 : 1.5
        onTextChanged: {
            resize()
        }
    }

    SequentialAnimation {   //顺序执行动画
        id:showAnimate
        running: false
        ScaleAnimator { target: root; from: 0.5; to: 1.2; duration: 100 }
        ScaleAnimator { target: root; from: 1.2; to: 0.8; duration: 100 }
        ScaleAnimator { target: root; from: 0.8; to: 1.1; duration: 100 }
        ScaleAnimator { target: root; from: 1.1; to: 0.9; duration: 100 }
        ScaleAnimator { target: root; from: 0.9; to: 1; duration: 100 }

        onStopped: {
            timer.start()
        }
    }

    ScaleAnimator { //大小动画
        id:hidenAnimate
        running: false
        target: root; from: 1.0; to: 0.8; duration: 200
        onStopped: {
            root.visible = false
        }
    }

    Timer{
        id: timer
        interval: times
        repeat: false
        running: false

        onTriggered: {
            hide()
        }
    }

    function resize(){  //重新设置大小
        if(!parent || !_contentText)
            return
        if(_contentText.lineCount > 1 && _contentText.paintedWidth < parent.width/5*4)  //长度不够
            _contentText.width = parent.width/5*4
        _contentText.width = _contentText.paintedWidth
        if(_contentText.paintedWidth > parent.width/5*4) { //过长
            _contentText.maximumLineCount = 10
            _contentText.width = parent.width/5*4
        }
        root.width = _contentText.width + Utl.dp(20)
        root.height = _contentText.paintedHeight + Utl.dp(20)
    }

    function show(){
        if (root.visible)
            return
        root.scale = 0.5
        root.visible = true
        showAnimate.start()
    }

    function hide(){
        if(hidenAnimate.running){
            return
        }
        if(!root.visible){
            root.visible = false
        }
        hidenAnimate.start()
    }
}

