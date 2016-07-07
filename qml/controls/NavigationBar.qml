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
    property alias content:_content

    property alias bottomLine: _line    //底部线条
    property alias button: _btn         //左边按钮

    signal buttonClicked()


    Rectangle{
       id:statusBar
       width: parent.width
       height: Qt.platform.os === "ios"?Utl.dp(20):0
       anchors.bottom: parent.top
       color:_background.color
       opacity:_background.opacity
       visible:_background.visible
       enabled: false
    }

    Rectangle{
        id:_content
        width: parent.width
        height: Utl.dp(55)
        anchors.top: parent.top
        color: Color.Clear
        Text{
            id:_title
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            color: Color.GreenTheme
            font.pointSize: FontUtl.FontSizeBigB
        }
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

