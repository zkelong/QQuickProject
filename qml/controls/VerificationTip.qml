import QtQuick 2.0
import "../controls/color.js" as Color
import "../controls/font.js" as FontUtl
import "../config.js" as Config
import "../tools.js" as Tools
import "../api.js" as Api
import "../code.js" as Code

/**
* 也是个消息弹出框，风格不一样
* 两个按钮是在底部并排，用来测试过服务器发验证码的
*/

Rectangle {
    id: root
    anchors.fill: parent
    color: "#15000000"
    visible: false

    property alias tile: tile_text.text  //标题信息
    property alias message: message_text.text  //提示信息
    property alias btn1_text: btn1_text.text  //第一个按钮的显示文字
    property alias btn2_text: btn2_text.text  //第二个按钮的显示文字
    property alias verficationCode: messge_code.text //验证码
    signal clincked(var id); //1--第一个按钮；2--第二个按钮

    function show() {
        root.visible = true
    }

    function hide() {
        root.visible = false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    Rectangle {
        anchors.centerIn: parent
        width: Utl.dp(262); height: Utl.dp(170)
        radius: Utl.dp(5)

        Rectangle {  //信息标题
            id: tile
            anchors.top: parent.top
            width: parent.width; height: Utl.dp(40)
            radius: Utl.dp(5)

            Rectangle {
                id: rect1
                anchors.top: parent.top
                width: parent.width
                height: parent.height / 2
                radius: Utl.dp(5)
                color: Color.GreenTheme
            }
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.height - Utl.dp(7)
                color: Color.GreenTheme
            }

            Text {
                id: tile_text
                anchors.centerIn: parent
                font.pointSize: 18
                color: "white"
                text: qsTr("获取验证码成功")
            }
        }

        Rectangle {
            id: message
            anchors.top: tile.bottom
            width: parent.width; height: Utl.dp(90)

            Text {
                id: message_text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: Utl.dp(6)
                font.pointSize: FontUtl.FontSizeMidC
                color: "#6b6b6b"
                text: qsTr("输入验证码完成验证")
            }

            Text {
                id: messge_code
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.verticalCenter
                anchors.topMargin: Utl.dp(6)
                font.pointSize: 21
                color: Color.GreenTheme
                text: ""
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width; height: Utl.dp(35)
            radius: Utl.dp(5)

            Rectangle { //关闭
                anchors.left: parent.left
                width: parent.width / 2; height: parent.height
                radius: Utl.dp(5)

                Rectangle {
                    id: bg_1
                    anchors.top: parent.top;
                    width: parent.width; height: Utl.dp(15)
                    color: "#cccccc"
                }
                Rectangle {
                    id: bg_2
                    anchors.bottom: parent.bottom
                    radius: Utl.dp(5)
                    width: parent.width; height: parent.height - Utl.dp(8)
                    color: "#cccccc"
                }

                Rectangle {
                    id: bg_3
                    anchors.right: parent.right
                    height: parent.height; width: parent.width / 2
                    color: "#cccccc"
                }

                Text {
                    id: btn1_text
                    anchors.centerIn: parent
                    font.pointSize: 18
                    color: "#6f6f6f"
                    text: qsTr("关闭")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {clincked(1)}
                    onPressed: {bg_1.color = "#c0c0c0"; bg_2.color = "#c0c0c0"; bg_3.color = "#c0c0c0"}
                    onReleased: {bg_1.color = "#cccccc"; bg_2.color = "#cccccc"; bg_3.color = "#cccccc"}
                }
            }

            Rectangle { //复制
                anchors.right: parent.right
                width: parent.width / 2; height: parent.height
                radius: Utl.dp(5)

                Rectangle {
                    id: bg_4
                    anchors.top: parent.top;
                    width: parent.width; height: Utl.dp(15)
                    color: Color.GreenTheme
                }
                Rectangle {
                    id: bg_5
                    radius: Utl.dp(5)
                    anchors.bottom: parent.bottom
                    width: parent.width; height: parent.height - Utl.dp(8)
                    color: Color.GreenTheme
                }

                Rectangle {
                    id: bg_6
                    anchors.left: parent.left
                    height: parent.height; width: parent.width / 2
                    color: Color.GreenTheme
                }

                Text {
                    id: btn2_text
                    anchors.centerIn: parent
                    font.pointSize: 18
                    color: "white"
                    text: qsTr("复制")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {clincked(2)}
                    onPressed: {bg_4.color = "#76cfbd"; bg_5.color = "#76cfbd"; bg_6.color = "#76cfbd"}
                    onReleased: {bg_4.color = Color.GreenTheme; bg_5.color = Color.GreenTheme; bg_6.color = Color.GreenTheme}
                }
            }
        }
    }
}

