import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"
import "../../net"

View {
    id: root
    Flickable{
        width: parent.width
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        contentHeight: clo.height + Utl.dp(20)
        Column {
            id: clo
            width: parent.width
            height: childrenRect.y + childrenRect.height
            spacing: Utl.dp(5)

            Text {
                width: parent.width
                height: Utl.dp(150)
                wrapMode: Text.WrapAnywhere
                text: "继承自Item，selectByMouse要手动设置\n
文字不能自己滚动，要用个ScrollView来装\n"
            }

            TextEdit {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(45)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                wrapMode: Text.WrapAnywhere
                text: "只设置长宽。换行符\\n管用的，后面换行\n后面换行\n后面换行\n有效果\n。后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
            }
            TextEdit {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(45)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                cursorVisible: false
                wrapMode: Text.WrapAnywhere
                text: "cursorVisible: false。后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
            }
            TextEdit {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(65)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                wrapMode: Text.WrapAnywhere
                selectByMouse: true
                mouseSelectionMode: TextEdit.SelectWords   //TextEdit.SelectCharacters
                text: "selectByMouse: true; mouseSelectionMode: TextEdit.SelectWords。后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
            }

            TextEdit {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(65)
                wrapMode: Text.WrapAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                selectByMouse: true
                text: "focus,selectedText,selectedByMouse后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
                onFocusChanged: {
                    txSh.text += " focusChanged: " + focus
                }
                onSelectedTextChanged: {
                    if(selectedText)
                        txSh.text += " SelectedTextChanged: " + selectedText
                }
                onSelectByMouseChanged: {
                    if(selectedText)
                        txSh.text += " SelectByMouseChanged: " + selectedText
                }
            }

            Text {
                id: txSh
                width: parent.width - Utl.dp(40)
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAnywhere
                Rectangle {
                    width: Utl.dp(30)
                    height: Utl.dp(30)
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "red"
                    opacity: 0.5
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            txSh.text = ""
                        }
                    }
                }
            }
        }
    }
    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
