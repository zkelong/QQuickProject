import QtQuick 2.0
import "../controls/color.js" as Color
import "../controls/font.js" as FontUtl
import "../config.js" as Config
import "../tools.js" as Tools
import "../api.js" as Api
import "../code.js" as Code

/**
*提示窗口
*标题
*提示语
*两个按钮： 确定--取消
*/

Rectangle {
    id: root
    anchors.fill: parent
    color: "#15000000"
    visible: false

    property alias title: tile_text  //标题信息--设置文字，字体，颜色
    property alias message: message_text  //提示信息--设置文字，字体，颜色
    property alias btn1_text: btn1_text   //第一个按钮的显示文字--设置文字，字体，颜色
    property alias btn2_text: btn2_text  //第二个按钮的显示文字--设置文字，字体，颜色

    property string titleRectColor: Color.GreenTheme

    signal clincked(var id);    //1--第一个按钮；2--第二个按钮

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
        width: Utl.dp(250); height: Utl.dp(150)
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
                color: titleRectColor
            }
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.height - Utl.dp(7)
                color: titleRectColor
            }

            Text {
                id: tile_text
                anchors.centerIn: parent
                font.pointSize: 18
                color: Color.White
                text: qsTr("消息提示")
            }
        }

        Rectangle {
            id: message
            anchors.top: tile.bottom
            width: parent.width; height: Utl.dp(60)

            Text {
                id: message_text
                anchors.centerIn: parent
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(10)
                wrapMode: Text.WrapAnywhere
                font.pointSize: FontUtl.FontSizeMidB
                color: "#7b7373"
                text: qsTr("确定要执行此操作？")
            }
        }

        Line {
            visible: false
            anchors.bottom: message.bottom
        }

        Rectangle {
            anchors.top: message.bottom
            width: parent.width; height: Utl.dp(50)
            radius: Utl.dp(5)

            Rectangle { //确定
                id: rect_btn1
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(15)
                width: (parent.width - Utl.dp(45)) / 2; height: Utl.dp(30)
                radius: Utl.dp(5)

                gradient: Gradient{ //确定按钮--用渐变颜色
                  GradientStop{id: stop1; position:0;color:"#70c7b5"}
                  GradientStop{id: stop2; position: 1.0;color:"#60b7a5"}
                }

                Text {
                    id: btn1_text
                    anchors.centerIn: parent
                    font.pointSize: 18
                    color: Color.White
                    text: qsTr("确定")
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {clincked(1)}
                    onPressed: {stop1.color = "#76cfbd"; stop2.color = "#66bfad"}
                    onReleased: {stop1.color = "#70c7b5"; stop2.color = "#60b7a5"}
                }
            }

            Rectangle { //取消
                id: btn_cancle
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(15)
                width: (parent.width - Utl.dp(45)) / 2; height: Utl.dp(30)
                radius: Utl.dp(5)
                border.color: "#d2d0d2"

                gradient: Gradient{ //取消按钮--用渐变颜色
                    GradientStop{id: stop3; position:0;color:"#f9f9f9"}
                    GradientStop{id: stop4; position: 1.0;color:"#e8e8e8"}
                }

                Text {
                    id: btn2_text
                    anchors.centerIn: parent
                    font.pointSize: 18
                    color: "#3c3c3c"
                    text: qsTr("取消")
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {clincked(2)}
                    onPressed: {stop3.color = "#eaeaea"; stop4.color = "#dad8df"}
                    onReleased: {stop3.color = "#f9f9f9"; stop4.color = "#e8e8e8"}
                }
            }
        }
    }
}

