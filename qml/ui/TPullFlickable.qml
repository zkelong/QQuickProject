import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../controls"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

View {
    id: root

    NavigationBar {
        id: navbar
        title: "ButtonGroup"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    ButtonGroup {
        id: btngroup
        onSelectedButtonChanged: {
            switch(selectedButton) {
            case btn1:
                _txt.text = "button1"
                break;
            case btn2:
                _txt.text = "button2"
                break;
            case btn3:
                _txt.text = "button3"
                break;
            }
        }
    }

    Rectangle {
        id: rect_btns
        width: parent.width
        height: parent.height/3
        anchors.top: navbar.bottom
        anchors.topMargin: Utl.dp(10)
        border.color: Color.LineGray

        Button {
            id: btn1
            group: btngroup
            width: Utl.dp(80)
            height: Utl.dp(30)
            border.color: Color.LineGray
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Utl.dp(20)
            icon.width: Utl.dp(25)
            icon.height: Utl.dp(25)
            icon.normalSource: "qrc:/res/1.png"
            icon.selectedSource: "qrc:/res/2.png"
            label.text: "button1"
        }
        Button {
            id: btn2
            group: btngroup
            width: Utl.dp(80)
            height: Utl.dp(30)
            border.color: Color.LineGray
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn1.right
            anchors.leftMargin: Utl.dp(20)
            icon.width: Utl.dp(25)
            icon.height: Utl.dp(25)
            icon.normalSource: "qrc:/res/1.png"
            icon.selectedSource: "qrc:/res/2.png"
            label.text: "button2"
        }
        Button {
            id: btn3
            group: btngroup
            width: Utl.dp(80)
            height: Utl.dp(30)
            border.color: Color.LineGray
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn2.right
            anchors.leftMargin: Utl.dp(20)
            icon.width: Utl.dp(25)
            icon.height: Utl.dp(25)
            icon.normalSource: "qrc:/res/1.png"
            icon.selectedSource: "qrc:/res/2.png"
            label.text: "button3"
        }
    }

    Text {
        id: _txt
        anchors.top: rect_btns.bottom
        anchors.topMargin: Utl.dp(30)
        anchors.horizontalCenter: parent.horizontalCenter
        text: "等待数据"
    }

}

