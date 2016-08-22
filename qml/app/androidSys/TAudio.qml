import QtQuick 2.0
import QtMultimedia 5.6
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color
import "../../toolsbox/tools.js" as Tools

View {
    id:root
    hidenTabbarWhenPush: true

    property int typeSelect: 0  //选择类型: 0--Audio; 1--QAudio
    property real totalDuration: 0  //时长
    property string sourcePath: "E:/QtSpace/QQuickProject/source/music.mp3" //此处字符串的反斜杠不认，双反斜杠也不认

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

        Item {
            id: item0
            width: parent.width
            height: parent.height * 0.66
            Text {
                id: show_txt
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeMidE
                text: "SHOW TEXT"
            }

            Text {
                id: txt_time1
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(20)
                font.pointSize: FontUtl.FontSizeSmallF
                text: "00:00:00"
            }
            Text {
                id: txt_time2
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(20)
                font.pointSize: FontUtl.FontSizeSmallF
                text: "00:00:00"
            }

            Rectangle {
                id: rect_bg
                height: Utl.dp(8)
                radius: height/2
                anchors.verticalCenter: txt_time1.verticalCenter
                anchors.left: txt_time1.right
                anchors.leftMargin: Utl.dp(6)
                anchors.right: txt_time2.left
                anchors.rightMargin: Utl.dp(6)
                color: Color.White
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("mouse....", mouseX, rect_bg.width)
                        var duration = (mouseX / rect_bg.width) * totalDuration
                        seekTo(duration)
                    }
                }
            }

            Rectangle {
                id: rect_progress
                height: rect_bg.height - Utl.dp(2)
                radius: height/2
                width: 0
                anchors.left: rect_bg.left
                anchors.verticalCenter: rect_bg.verticalCenter
                color: Color.GreenTheme
            }
        }

        Item {
            width: parent.width
            anchors.top: item0.bottom
            anchors.bottom: parent.bottom

            Item {
                id: item_model
                width: parent.width
                height: Utl.dp(45)
                anchors.top: parent.top

                Button {
                    id: btn_qml
                    width: Utl.dp(70)
                    height: Utl.dp(35)
                    radius: Utl.dp(4)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Utl.dp(40)
                    label.color: typeSelect == 0 && enabled  ? Color.Blue : "#606060"
                    label.text: "QML Audio"
                    onClicked: {
                        typeSelect = 0
                    }
                }
                Button {
                    id: btn_qaudio
                    width: Utl.dp(70)
                    height: Utl.dp(35)
                    radius: Utl.dp(4)
                    anchors.verticalCenter: btn_qml.verticalCenter
                    anchors.left: btn_qml.right
                    anchors.leftMargin: Utl.dp(20)
                    label.color: typeSelect == 1 && enabled  ? Color.Blue : "#606060"
                    label.text: "QAudio"
                    onClicked: {
                        typeSelect = 1
                    }
                }
            }

            Item {
                width: parent.width
                anchors.top: item_model.bottom
                anchors.bottom: parent.bottom

                Button {
                    id: btn_play_pause
                    width: Utl.dp(45)
                    height: Utl.dp(25)
                    anchors.top: parent.top
                    anchors.topMargin: Utl.dp(15)
                    anchors.left: parent.left
                    anchors.leftMargin: Utl.dp(60)
                    radius: Utl.dp(4)
                    color: Color.GreenTheme
                    label.text: "Play"
                    onClicked: {
                        play()
                    }
                }
                Button {
                    id: btn_record_stop
                    width: Utl.dp(45)
                    height: Utl.dp(25)
                    anchors.verticalCenter: btn_play_pause.verticalCenter
                    anchors.left: btn_play_pause.right
                    anchors.leftMargin: Utl.dp(15)
                    radius: Utl.dp(4)
                    color: Color.GreenTheme
                    label.text: "Record"
                    onClicked: {

                    }
                }
            }
        }
    }

    Audio {
        id: player_q
        source: sourcePath
        //autoLoad: false
        //duration
        //loops : int --Audio.Infinite
        //position : int
        onDurationChanged: {
            console.log("duration....", duration)
            if(duration > 0) {
                totalDuration = duration
                txt_time2.text = Tools.getTimeFormat(Math.floor(duration / 1000))
            }
        }
        onError: {
            console.log("error...", error, errorString)
        }
        onPaused: {
            console.log("pause....", duration)
        }
        onPlaying: {
            console.log("playing....")
        }
        onStopped: {
            //rect_progress.width = 0
        }
        onPositionChanged: {
            txt_time1.text = Tools.getTimeFormat(Math.floor(position / 1000))
            rect_progress.width = position / duration * rect_bg.width
        }
    }


    function play() {
        console.log("has audio....", player_q.source, player_q.hasAudio, player_q.hasVideo,player_q.duration)
        switch(typeSelect) {
            case 0:
                player_q.play()
                break;
            case 1:
                break;
        }
    }

    function pause() {
        switch(typeSelect) {
            case 0:
                player_q.pause()
                break;
            case 1:
                break;
        }
    }

    function seekTo(duration) {
        switch(typeSelect) {
            case 0:
                player_q.seek(duration)
                break;
            case 1:
                break;
        }
    }
}
