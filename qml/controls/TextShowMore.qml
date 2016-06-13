import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import "../controls"
import "../controls/color.js" as Color
import "../controls/font.js" as FontUtl

// 申请成为声讯员
Item {
    height: _more.visible ? _more.y + _more.height : _text.y + _text.height

    property alias text: _text.text
    property alias font: _text.font
    property alias color: _text.color
    property alias lineHeight: _text.lineHeight
    property int showLineCount: 3

    property string showMoreText: qsTr("全文")
    property string hideMoreText: qsTr("收起")
    property alias moreColor: _more.color

    Text {
        id: _text
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        lineHeight: 1.3
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        onLineCountChanged: {
            if(lineCount > showLineCount + 1 && !_more.visible) {     //行数多了，隐藏
                maximumLineCount = showLineCount
                _more.visible = true
            }
        }
    }

    Text {
        id: _more
        visible: false
        anchors.top: _text.bottom
        anchors.topMargin: Utl.dp(3)
        font: _text.font
        color: "#5d7099"
        text: showMoreText
    }
    MouseArea {
        anchors.fill: _more
        anchors.margins: -Utl.dp(3)
        onClicked: {
            if(_more.text == showMoreText) {    //显示全部
                _text.maximumLineCount = 100*1000
                _more.text = hideMoreText
            } else {
                _text.maximumLineCount = showLineCount
                _more.text = showMoreText
            }
        }
    }
}
