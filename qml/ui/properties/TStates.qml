import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property int itemHeight: root.height/4

    NavigationBar {
        id: navbar
        title: "States"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: _col.height + Utl.dp(20)
        clip: true

        Column {
            id: _col
            width: parent.width
            height: childrenRect.height
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            spacing: Utl.dp(10)

            Item {
                id: item0
                width: parent.width
                height: itemHeight

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: innerRec.top
                    anchors.bottomMargin: Utl.dp(10)
                    text: "state点击改变"
                }

                Rectangle {
                    id: innerRec
                    height: parent.height/2
                    width: height
                    anchors.centerIn: parent
                    color: "#59a72c"
                    //state: "pre"    //初始状态，不指明，则初始化为""

                    Text {
                        id: txt
                        anchors.centerIn: parent
                        text: "Hello QML"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {    //状态变化
                            if(innerRec.state == ""/*"pre"*/)
                                innerRec.state = "tag"
                            else
                                innerRec.state = ""//"pre"
                        }
                    }
                    states: [   //状态列表，可以有很多状态
                        State {
                            name: "tag"
                            PropertyChanges {   //属性变化
                                target: innerRec
                                color: "#5cb4da"
                            }
                            PropertyChanges {   //属性变化
                                target: txt
                                text: "Hello Qt!!"
                            }
                        }
                    ]
                }
            }

            Item {
                id: item1
                width: parent.width
                height: itemHeight
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: rect1.top
                    anchors.bottomMargin: Utl.dp(10)
                    text: "state用when来获取"
                }
                Rectangle {
                    id: rect1
                    height: parent.height/2
                    width: height
                    anchors.centerIn: parent
                    color: "#59a72c"

                    Text {
                        id: txt1
                        anchors.centerIn: parent
                        text: "Hello QML"
                    }

                    MouseArea {
                        id: mouse1
                        anchors.fill: parent
                    }
                    states: [   //状态列表，可以有很多状态
                        State {
                            name: "change"
                            when: mouse1.pressed    //用when来触发state变化
                            PropertyChanges {   //属性变化
                                target: rect1
                                color: "#5cb4da"
                            }
                            PropertyChanges {   //属性变化
                                target: txt1
                                text: "Hello Qt!!"
                            }
                        }
                    ]
                }
            }

            Item {
                id: item2
                width: parent.width
                height: itemHeight
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: redRect.top
                    anchors.bottomMargin: Utl.dp(10)
                    text: "ParentChange相对于父组件的属性改变"
                }

                Rectangle {
                    id: redRect
                    x: 50
                    width: 100;
                    height: 100
                    color: "red"
                }
                Rectangle {
                    id: blueRect
                    x: redRect.width+redRect.x
                    width: 50;
                    height:50;
                    color: "blue"
                    states:
                        State{
                        name: "reparented"
                        ParentChange {      //更改的属性是相对于父组件的。如(sition, size, rotation, and scale)
                            target: blueRect;
                            parent: redRect;    //ParentChange: 先指定一个parent
                            x: 10;
                            y: 10
                            scale: 1.2  //相对于自己的。。
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: blueRect.state = "reparented"
                    }
                }
            }

            Item {
                id: item3
                width: parent.width
                height: itemHeight
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: window.top
                    anchors.bottomMargin: Utl.dp(10)
                    text: "AnchorChanges的改变"
                }

                Rectangle {
                    id: window
                    width: 120;
                    height: 120
                    color: "black"

                    Rectangle {
                        id: myRect
                        width: 50
                        height: 50
                        color: "red"
                    }
                    states:
                        State {
                        name: "reanchored"
                        AnchorChanges { //相对位置属性
                            target: myRect
                            anchors.top: window.top
                            anchors.bottom: window.bottom
                        }
                        PropertyChanges {   //属性值
                            target: myRect
                            anchors.topMargin: 10
                            anchors.bottomMargin: 10
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.state = "reanchored"
                    }
                }
            }

            Item {
                id: item4
                width: parent.width
                height: itemHeight
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: Utl.dp(10)
                    text: "AnchorAnimation"
                }
                Rectangle {
                    id: myRect1
                    width: 100;
                    height:100
                    color: "red"
                }
                states:
                    State {
                    name: "reanchored"
                    AnchorChanges {
                        target: myRect1;
                        anchors.right: item4.right
                    }
                }
                transitions:
                    Transition {
                    AnchorAnimation {
                        easing.type: Easing.OutBounce;
                        duration: 1000
                    }
                }

                MouseArea {
                    anchors.fill: myRect1
                    onClicked: item4.state = "reanchored"
                }
            }

//            Item {
//                id: item2
//                width: parent.width
//                height: itemHeight

//                Text {
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    anchors.bottom: innerRec.top
//                    anchors.bottomMargin: Utl.dp(10)
//                    text: "顺序动画"
//                }
//                Rectangle {
//                    id: rect2
//                    height: parent.height/2
//                    width: height
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    y: 0
//                    color: "#59a72c"

//                    Text {
//                        id: txt2
//                        anchors.centerIn: parent
//                        text: "Hello QML"
//                    }

//                    SequentialAnimation on y{
//                        loops: Animation.Infinite
//                        NumberAnimation {
//                            to: 100//item2.height - rect2.height
//                            easing.type: Easing.OutBounce;
//                            duration: 2000
//                        }
//                        ScriptAction {
//                            script: {console.log("ddd", item2.height - rect2.height);}
//                        }
//                        PauseAnimation {
//                            duration: 2000
//                        }
//                        NumberAnimation {
//                            to: 0;
//                            easing.type: Easing.OutQuad;
//                            duration: 1000
//                        }
//                    }
//                }
//            }

        }
    }
}

/*
所有Item都有state属性值，默认未指定state属性时，该值为空字符串""
默认情况下，QML会帮你保存默认定义的state状态，即Item中的颜色，文本，字体等内容属性值。
在State状态对象中，一般采用PropertyChanges方式来修改某个指定对象的属性。
State通常与Transtion联合使用。
*/
