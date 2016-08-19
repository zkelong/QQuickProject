import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"

View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "Text"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable{
        clip: true
        width: parent.width
        anchors.top: navbar.bottom
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
                text: "TextArea继承自ScrollView\nScrollView有滑动条属性horizontalScrollBarPolicy和verticalScrollBarPolicy：\n值有：Qt.ScrollBarAsNeeded(default)/Qt.ScrollBarAlwaysOff/Qt.ScrollBarAlwaysOn\n换行用\\n跟Text的换行一样。text赋值的字符串直接打回车也有用！"
            }

            /*TextArea {
                width: parent.width/2
                height: Utl.dp(50)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                text: "只设置长宽，其他没有设置，看看效果，电脑上和手机上表现还不一样。换行符\\n管用的，后面换行\n后面换行\n后面换行\n有效果\n。后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
            }
            TextArea {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(45)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                text: "设置长宽，隐藏滚动条。后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
            }
            TextArea {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(65)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                backgroundVisible: false
                text: "设置长宽，隐藏滚动条,隐藏边框。后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
            }*/

            TextArea {
                id: test
                width: parent.width - Utl.dp(40)
                height: Utl.dp(65)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                backgroundVisible: false
                selectByMouse: true
                text: "设置长宽，隐藏滚动条,隐藏边框,selectByMouse(true, default true);包含于MouseArea, MouseArea接收不到信号。后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
                onFocusChanged: {
                    txSh.text += " selectByMouse*focusChanged: " + focus
                }
                onSelectedTextChanged: {
                    if(selectedText)
                        txSh.text += " selectByMouse*SelectedTextChanged: " + selectedText
                }
                onSelectByKeyboardChanged: {
                    if(selectedText)
                        txSh.text += " selectByMouse*SelectByKeyboardChanged: " + selectedText
                }
                onSelectByMouseChanged: {
                    if(selectedText)
                        txSh.text += " selectByMouse*SelectByMouseChanged: " + selectedText
                }
            }
            Rectangle {
                width: parent.width/2
                height: Utl.dp(45)
                color: "red"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        txSh.text += " selectedText: " + test.selectedText + " selectedStart: " + test.selectionStart + " selectedEnd: " + test.selectionEnd
                    }
                }
            }

            /*TextArea {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(65)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                backgroundVisible: false
                frameVisible: false
                selectByKeyboard: true
                text: "设置长宽，隐藏滚动条,隐藏边框,selectByKeyboard:true；包含MouseArea，MouseArea会截断获取焦点事件，backgroundVisible=false; frameVisible=false。后边的是乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据乱七八糟的测试数据"
                onFocusChanged: {
                    txSh.text += " selectByKeyboard*focusChanged: " + focus
                }
                onSelectedTextChanged: {
                    if(selectedText)
                        txSh.text += " selectByKeyboard*SelectedTextChanged: " + selectedText
                }
                onSelectByKeyboardChanged: {
                    if(selectedText)
                        txSh.text += " selectByKeyboard*SelectByKeyboardChanged: " + selectedText
                }
                onSelectByMouseChanged: {
                    if(selectedText)
                        txSh.text += " selectByKeyboard*SelectByMouseChanged: " + selectedText
                }
            }*/

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
}
