import QtQuick 2.4
import "./color.js" as Color
import "../config.js" as Config

/*
 *一张图片，图片下有三排文字
 *
*/

Rectangle {
    id: root
    property alias picurl: _picone.source
    property alias picwidth: _picone.width
    property alias picheigth: _picone.height
    property alias picname: _picname.text
    property alias namecolor: _picname.color
    property alias namesize: _picname.font.pointSize
    //property alias numvalus: _picnum.text
    //property alias numcolor: _picnum.color
    property alias issuename: _issue.text
    property alias issuesize: _issue.font.pointSize
    property alias issuecolor: _issue.color

    property alias issname: issnum.text

    height: Utl.dp(90)
    //anchors.left: parent.left
    ImageLoader {
        id: _picone
        width: Utl.dp(72)
        height: Utl.dp(59)
        source: picUrl ? picUrl : Config.DefalutImage1
        anchors.top: parent.top
        defaultSource: Config.DefalutImage1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Utl.dp(10)
    }
    Text {
        id: _picname
        text: pictx ? pictx : ""
        font.pointSize: 10
        color: namecolor
        anchors.top: _picone.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Utl.dp(10)
    }
    Text {
        id: issnum
        font.pointSize: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: _picname.bottom
        anchors.topMargin: Utl.dp(5)
        color: "#938a8b"
        text:  pictx2 + "份"
    }

    Text {
        id: _issue
        text: pictx3 ? pictx3 : ""
        font.pointSize: 9
        color: issuecolor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: issnum.bottom
        anchors.topMargin: Utl.dp(5)

    }

}

