import QtQuick 2.4
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
        title: "S/PlAnimation"
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
                Rectangle {         //串行或并行执行动画
                    id: banner
                   width: parent.width; height: parent.height
                   border.color: "black"

                    Column {
                        anchors.centerIn: parent
                        Text {
                            id: code
                            text: "Code less."
                            opacity: 0.01
                        }
                        Text {
                            id: create
                            text: "Create more."
                            opacity: 0.01
                        }
                        Text {
                            id: deploy
                            text: "Deploy everywhere."
                            opacity: 0.01
                        }
                    }

                    MouseArea {
                        height: parent.height
                        width: parent.width/2
                        anchors.left: parent.left
                        onClicked: {playbanner.start(); cl1.visible = false}
                        Text {
                            id: cl1
                            anchors.centerIn: parent
                            text: "Click-1"
                        }
                    }
                    MouseArea {
                        height: parent.height
                        width: parent.width/2
                        anchors.right: parent.right
                        onClicked: {play.start(); cl2.visible = false}
                        Text {
                            id: cl2
                            anchors.centerIn: parent
                            text: "Click-2"
                        }
                    }
                    //一旦有动画被放在了SequentialAnimation 或 ParallelAnimation中, 他们就不会再独立的启动或停止.串行或并行动画必须作为一个组合来启动或停止.
                    SequentialAnimation {  //串行动画
                        id: playbanner
                        running: false
                        NumberAnimation { target: code; property: "opacity"; to: 1.0; duration: 2000}
                        NumberAnimation { target: create; property: "opacity"; to: 1.0; duration: 2000}
                        NumberAnimation { target: deploy; property: "opacity"; to: 1.0; duration: 2000}
                        ScriptAction{script: {code.opacity=0; create.opacity=0; deploy.opacity=0}}
                    }

                    ParallelAnimation {  //并行动画
                        id: play
                        running: false
                        NumberAnimation { target: code; property: "opacity"; to: 1.0; duration: 2000}
                        NumberAnimation { target: create; property: "opacity"; to: 1.0; duration: 2000}
                        NumberAnimation { target: deploy; property: "opacity"; to: 1.0; duration: 2000}
                    }
                }
            }
        }
    }
}

