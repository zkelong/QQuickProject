import QtQuick 2.0
import QtQuick.Window 2.1
import QKit 1.0
import "./style"
import "./def"

Dialog {
    id:root
    closeWhenTapBg:false

    property string message         //显示的消息
    property var buttons: []        //按钮标题字符串数组

    radius: K.dp(5)
    width : Math.min(K.dp(6 * 48),parent.width * 0.8)
    height: btnBox.y + btnBox.height + K.dp(4)
    anchors.centerIn: parent


    QtObject{
        id:prv
        property var tmp_btns: []   //还未创建的按钮

        function cleanBtns(){
            var ch = btnBox.children;
            for(var i = 0; i < ch.length; ++i){
                ch[i].destroy();
            }
        }

        function createBtns(titles){
            cleanBtns()
            var box = null;
            var btnWidth = 0;
            var len = titles.length;
            var line = null;
            if(len < 3){//横向排列
                box = rowCmp.createObject(btnBox);
                line = vLine;
                btnWidth = Qt.binding(function(){
                    return btnBox.width / len;
                })
            } else { //纵向排列
                box = columnCmp.createObject(btnBox)
                line = hLine;
                btnWidth = Qt.binding(function() {return btnBox.width});
            }

            for(var i = 0; i < titles.length; ++i){
                var btn = btnCmp.createObject(box)
                btn.title = titles[i];
                btn.width = btnWidth;
                btn.tag = i;
                if(i < titles.length - 1){
                    line.createObject(box)
                }
            }

            btnBox.height = Qt.binding(function(){
                return box.y + box.height
            });
            resize()
        }
    }

    onButtonsChanged: {
        if(!btnBox){
            prv.tmp_btns = buttons;
        } else {
            prv.createBtns(buttons)
        }
        buttons.length = 0;
    }


    MaterialShadow {
        anchors.fill: root
        asynchronous: true
        depth: 3
        z: -100
        visible: root.opacity === 1
    }

    Flickable {//提示文字,超高可以滚动
        id:textBox
        width: root.width
        height: K.dp(2 * 48)
        clip: true
        Text {
            id:_text
            text : root.message
            width: parent.width - anchors.margins*2
            anchors.centerIn: parent
            anchors.margins: K.dp(16)
            horizontalAlignment: _text.lineCount > 1? Text.AlignLeft : Text.AlignHCenter
            font.pixelSize: Style.theme.text.textSize
            wrapMode : Text.WordWrap
            color : Style.theme.black87
            onHeightChanged: {
                resize()
            }
        }
    }


    function resize(){

        var textBoxHeight = _text.height + _text.anchors.margins*2;
        var bottomHeight = line.height + line.anchors.topMargin + btnBox.anchors.topMargin + btnBox.height

        var p = root.parent;
        var maxHeigth = 0;
        while(p){
            if(p.height > maxHeigth){
                maxHeigth = p.height;
            }
            p = p.parent;
        }
        maxHeigth *= 0.8;

        var d = textBoxHeight + bottomHeight - maxHeigth;
        if(d > 0){
            textBox.height = textBoxHeight - d;
        } else {
            textBox.height  = textBoxHeight;
        }

        if(_text.height > (textBox.height - _text.anchors.margins*2)){
            textBox.contentHeight = _text.height + K.dp(10)
        } else {
            textBox.contentHeight = textBox.height;
        }
    }

    HLine {
        id:line
        anchors.top: textBox.bottom; anchors.topMargin: K.dp(5)
    }

    //按钮容器
    Item{
        id:btnBox
        anchors.left: parent.left; anchors.leftMargin: K.dp(5)
        anchors.top:line.bottom; anchors.topMargin: K.dp(5)
        anchors.right: parent.right; anchors.rightMargin: K.dp(5)
        Component.onCompleted: {
            if(prv.tmp_btns.length){
                prv.createBtns(prv.tmp_btns)
            }
        }
    }

    Component{
        id:columnCmp
        Column{
            width: btnBox.width
            height: childrenRect.y + childrenRect.height
        }
    }

    Component{
        id:rowCmp
        Row{
            width: btnBox.width
            height: childrenRect.y + childrenRect.height
        }
    }

    Component{
        id:btnCmp
        BaseButton{
            property int tag: 0

            height: K.dp(35)
            label.color: Color.lightBlue
            onClicked: root.done(tag)
        }
    }

    Component{
        id:hLine
        HLine{

        }
    }

    Component{
        id:vLine
        VLine{
            height: K.dp(35)
        }
    }

}

