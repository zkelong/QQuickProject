import QtQuick 2.0
import "../controls"

View {
    id: root
    hidenTabbarWhenPush: true

    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: _col.height

        Column {
            id: _col
            width: parent.width
            height: childrenRect.height + Utl.dp(30)
            spacing: Utl.dp(30)

            Item {
                width: parent.width
                height: Utl.dp(155)
                Text {
                    anchors.top: parent.top
                    anchors.topMargin: Utl.dp(10)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("MouseArea左键/右键")
                }
                Rectangle {
                    id: rectr
                    height: parent.height*.8
                    width: parent.width*.8
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom

                    Text {
                        id: txx
                        anchors.centerIn: parent

                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: {
                            if (mouse.button == Qt.RightButton)
                                txx.text = "right"
                            else
                                txx.text = "left"
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: Utl.dp(155)
                Text {
                    anchors.top: parent.top
                    anchors.topMargin: Utl.dp(10)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("MouseArea重叠--不穿透")
                }
                Rectangle {
                    id: rect1
                    height: parent.height*.8
                    width: parent.width*.8
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Utl.dp(10)
                        text: "MouseArea-1"

                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            txt1.text = "MouseArea-1**"
                        }
                    }
                }
                Rectangle {
                    id: rect2
                    height: parent.height*.8
                    width: rect1.width*.45
                    border.width: 1
                    border.color: "#0099aa"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Utl.dp(10)
                        text: "MouseArea-2"

                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            txt1.text = "MouseArea-2**"
                        }
                    }
                }
                Text {
                    id: txt1
                    anchors.left: parent.left
                    anchors.leftMargin: Utl.dp(10)
                    anchors.right: parent.right
                    anchors.rightMargin: Utl.dp(10)
                    wrapMode: Text.WrapAnywhere
                }
            }

            Item {  //穿透
                width: parent.width
                height: Utl.dp(155)
                Text {
                    anchors.top: parent.top
                    anchors.topMargin: Utl.dp(10)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("MouseArea重叠--穿透")
                }
                Rectangle {
                    id: rect3
                    height: parent.height*.8
                    width: parent.width*.8
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    property bool click4: false

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Utl.dp(10)
                        text: "MouseArea-3"

                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(rect3.click4)
                                txt2.text += "MouseArea-3**"
                            else
                                txt2.text = "MouseArea-3**"
                            rect3.click4 = false
                        }
                    }
                }
                Rectangle {
                    id: rect4
                    height: parent.height*.8
                    width: rect3.width*.45
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Utl.dp(10)
                        text: "MouseArea-4"

                    }
                    MouseArea {
                        anchors.fill: parent
                        propagateComposedEvents: true //没有处理的事件信号可以向下传递，可以被再次获取到
                        onClicked: {
                            txt2.text = "MouseArea-4**"
                            rect3.click4 = true
                            mouse.accepted = false  //该事件信号向下传递，可以被再次获取到
                        }
                    }
                }
                Text {
                    id: txt2
                    anchors.left: parent.left
                    anchors.leftMargin: Utl.dp(10)
                    anchors.right: parent.right
                    anchors.rightMargin: Utl.dp(10)
                    wrapMode: Text.WrapAnywhere
                }
            }

            Item {  //圆形
                width: parent.width
                height: Utl.dp(155)
                Text {
                    anchors.top: parent.top
                    anchors.topMargin: Utl.dp(10)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("MouseArea圆形区域")
                }

                Rectangle {
                    anchors.fill: rectx
                    border.width: 1
                }

                Rectangle {
                    id: rectx
                    height: parent.height*2/3
                    width: height
                    border.width: 1
                    radius: height/2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom

                    Text {
                        id: txt3
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Utl.dp(10)

                    }
                    MouseArea {
                        height: parent.height
                        width: parent.width
                        onClicked: {
                            if((mouseX - width/2)*(mouseX - width/2) + (mouseY - width/2)*(mouseY-width/2) < (width/2)*(width/2))
                                txt3.text = "get"
                            else
                                txt3.text = "miss"
                        }
                    }
                }
            }

            Item {  //旋转
                width: parent.width
                height: Utl.dp(155)
                Text {
                    anchors.top: parent.top
                    anchors.topMargin: Utl.dp(10)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("MouseArea旋转")
                }

                Rectangle {
                    anchors.fill: recty
                    border.width: 1
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            txt4.text = "miss"
                        }
                    }
                }

                Rectangle {
                    id: recty
                    height: parent.height*2/3
                    width: height
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    rotation: 45

                    Text {
                        id: txt4
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Utl.dp(10)
                        text: ""

                    }
                    MouseArea {
                        height: parent.height
                        width: parent.width
                        onClicked: {
                            if((mouseX - width/2)*(mouseX - width/2) + (mouseY - width/2)*(mouseY-width/2) < (width/2)*(width/2))
                                txt4.text = "get"
                        }
                    }
                }
            }
        }
    }

    NavigationBar {
        id: navbar
        title: "MouseArea"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

}


