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
                text: "继承自FocusScope，接收1行的输入\n
displayText可以显示输入提示\n"
            }

            TextField {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(45)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                text: ""
                selectByMouse: true
                onFocusChanged: {
                    txSh.text += " selectByMouse*focusChanged: " + focus
                }
                onSelectedTextChanged: {
                    if(selectedText)
                        txSh.text += " selectByMouse*SelectedTextChanged: " + selectedText
                }
                onSelectByMouseChanged: {
                    if(selectedText)
                        txSh.text += " selectByMouse*SelectByMouseChanged: " + selectedText
                }
            }
            TextField {
                width: parent.width - Utl.dp(40)
                height: Utl.dp(45)
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                selectByMouse: false
                onFocusChanged: {
                    txSh.text += " false*focusChanged: " + focus
                }
                onSelectedTextChanged: {
                    if(selectedText)
                        txSh.text += " false*SelectedTextChanged: " + selectedText
                }
                onSelectByMouseChanged: {
                    if(selectedText)
                        txSh.text += " false*SelectByMouseChanged: " + selectedText
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
