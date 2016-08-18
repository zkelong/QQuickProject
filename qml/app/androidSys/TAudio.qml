import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id:root

    property int typeSelect: 0  //选择类型
    //property


    NavigationBar {
        id: navbar
        title: "Audio"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Item {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        //模式
        Item {
            id: item0
            width: parent.width
            height: Utl.dp(90)
            anchors.bottom: parent.bottom
            Line {
                anchors.top: parent.top
            }
            Button {
                id: btn_qml
                width: Utl.dp(60)
                height: Utl.dp(35)
                anchors.top: parent.top
                anchors.topMargin: Utl.dp(15)
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(40)
                color: typeSelect == 0 && enabled  ? Color.Blue : "#606060"
                label.text: "QML Audio"
                onClicked: {
                    typeSelect = 0
                }
            }
            Button {
                id: btn_qaudio
                width: Utl.dp(60)
                height: Utl.dp(35)
                anchors.verticalCenter: btn1.verticalCenter
                anchors.left: btn1.right
                anchors.leftMargin: Utl.dp(15)
                color: typeSelect == 1 && enabled  ? Color.Blue : "#606060"
                label.text: "QAudio"
                onClicked: {
                    typeSelect = 1
                }
            }
            Button {
                id: btn_ss
                width: Utl.dp(60)
                height: Utl.dp(35)
                anchors.verticalCenter: btn1.verticalCenter
                anchors.left: btn2.right
                anchors.leftMargin: Utl.dp(15)
                color: typeSelect == 2 && enabled ? Color.Blue : "#606060"
                label.text: "QML Audio"
                onClicked: {
                    typeSelect = 2
                }
            }
        }
        //操作
        Item {
            width: parent.width
            anchors.top: item0.bottom
            anchors.bottom: parent.bottom
            Button {
                id: btn_play_pause
                width: Utl.dp(30)
                height: Utl.dp(15)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(60)
                radius: Utl.dp(4)
                color: Color.Green
                label.text: "Play"
                onClicked: {

                }
            }
            Button {
                id: btn_record_stop
                width: Utl.dp(30)
                height: Utl.dp(15)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: btn_play_pause.right
                anchors.leftMargin: Utl.dp(15)
                radius: Utl.dp(4)
                color: Color.Green
                label.text: "Play"
                onClicked: {

                }
            }
        }
    }
}
