import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import "./color.js" as Color
import "./font.js" as FontUtl

/**
*图片+文字+箭头
*
*/
Rectangle {

    color:Color.Clear
    width: parent.width

    property alias img: _img        //图片
    property alias label: _lable    //文字
    property alias arrow: _rdArrow  //箭头

    Image {     //图标
        id: _img
        width: Utl.dp(40); height: Utl.dp(40)
        anchors.left: parent.left; anchors.leftMargin: Utl.dp(10)
        source: pic
    }

    Text{       //文字
        id:_lable
        anchors.left: _img.right; anchors.leftMargin: Utl.dp(10)
        anchors.verticalCenter: parent.verticalCenter
        width: Utl.dp(60); height: parent.height
        verticalAlignment: Text.AlignVCenter
        font.pointSize: FontUtl.FontSizeMidD
        color:Color.DarkGray
    }

    Image{      //箭头
        id:_rdArrow
        width: Utl.dp(12)
        height: Utl.dp(15)
        source: "qrc:/res/select_p.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Utl.dp(10)
    }

    Line{
        anchors.bottom: parent.bottom
    }
}

