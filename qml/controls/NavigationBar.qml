import QtQuick 2.4
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl

/**
* 导航条
*/

Rectangle {
    id: root
    width: parent.width
    height: Utl.dp(44)
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    color: Color.NavigationLightGray

    property alias title: _title.text   //导航标题
    property alias titleLabel: _title

    property alias bottomLine: _line    //底部线条
    property alias button: _btn         //左边按钮

    signal buttonClicked()

    Text{
        id:_title
        anchors.centerIn: parent
        color: Color.GreenTheme
        font.pointSize: 21
    }

    Button{
        id: _btn
        width: Utl.dp(40)
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        icon.width: Utl.dp(11)
        icon.height: Utl.dp(20)
        icon.normalSource: "qrc:/res/arrow_left4.png"
        onClicked: {
            root.buttonClicked()
        }
    }

    Line {
        id: _line
        anchors.bottom: parent.bottom
        color: Color.LineGray
    }
}

