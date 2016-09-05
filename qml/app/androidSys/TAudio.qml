import QtQuick 2.0
import QtMultimedia 5.6
import QKit 1.0
import QAudio 1.0
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
    property int playStatus: 0 //播放状态 0--等待，1--播放中，2--暂停
    property int recordStatus: 0 //录音状态 0--等待，1--录音中，2--暂停，3--结束
    property string sourcePath: Qt.platform === "android" ? FileTools.assetsUrl("source/music.mp3") : "E:/QtSpace/QQuickProject/source/music.mp3" //此处字符串的反斜杠不认，双反斜杠也不认
    property bool recordFinish: false

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

        Item {  //展示
            id: item0
            width: parent.width
            height: parent.height * 0.66
            Text {
                id: show_txt
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeMidE
                text: "Exist Source"
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
                        var duration = (mouseX / rect_bg.width) * totalDuration
                        if(typeSelect === 0) {  //qml
                            player_q.seek(duration)
                        } else {   //QMediaPlayer
                            player_c.seek(duration)
                        }
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

        Item {  //类型选择
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
                    enabled: playStatus !== 1 || typeSelect === 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Utl.dp(40)
                    label.color: typeSelect == 0 && enabled ? Color.Blue : "#606060"
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
                    color: "red"
                    enabled: playStatus !== 1 || typeSelect === 1
                    anchors.verticalCenter: btn_qml.verticalCenter
                    anchors.left: btn_qml.right
                    anchors.leftMargin: Utl.dp(20)
                    label.color: typeSelect == 1 ? Color.Blue : "#606060"
                    label.text: "QAudio"
                    onClicked: {
                        typeSelect = 1
                    }
                }
            }

            Item {  //播放控制
                width: parent.width
                anchors.top: item_model.bottom
                anchors.bottom: parent.bottom

                Button {
                    id: btn_play_pause
                    width: Utl.dp(45)
                    height: Utl.dp(25)
                    enabled: recordStatus !== 1 && recordStatus !==2 //不在录音中
                    anchors.top: parent.top
                    anchors.topMargin: Utl.dp(15)
                    anchors.left: parent.left
                    anchors.leftMargin: Utl.dp(60)
                    radius: Utl.dp(4)
                    color: enabled ? Color.GreenTheme : "#606060"
                    label.text: playStatus === 1 ? "Pause" : "Play"
                    onClicked: {
                        if(typeSelect === 0) {  //qml
                            if(playStatus === 1) {
                                player_q.pause()
                            } else {
                                player_q.play()
                            }
                        } else {    //QMediaPlayer
                            if(playStatus === 1) {
                                player_c.playPause()
                            } else {
                                player_c.play(sourcePath)
                            }
                        }
                    }

                    Button {
                        id: btn_play_stop
                        visible: playStatus !== 0
                        width: btn_play_pause.width
                        height: btn_play_pause.height
                        anchors.top: btn_play_pause.bottom
                        anchors.topMargin: Utl.dp(10)
                        anchors.left: btn_play_pause.left
                        radius: Utl.dp(4)
                        color: Color.GreenTheme
                        label.text: "Stop"
                        onClicked: {
                            if(typeSelect === 0) {  //qml
                                player_q.stop()
                            } else {    //QMediaPlayer
                                player_c.playStop()
                            }
                        }
                    }

                    Button {
                        id: btn_record_pause
                        width: Utl.dp(45)
                        height: Utl.dp(25)
                        enabled: playStatus === 0
                        anchors.verticalCenter: btn_play_pause.verticalCenter
                        anchors.left: btn_play_pause.right
                        anchors.leftMargin: Utl.dp(15)
                        radius: Utl.dp(4)
                        color: enabled ? Color.GreenTheme : "#606060"
                        label.text: recordStatus === 0 ? "Record" : "Pause"
                        onClicked: {
                            if(recordStatus === 0) {    //录制
                                player_c.record();
                            } else {    //暂停
                                player_c.recordPause();
                            }
                        }
                    }

                    Button {
                        id: btn_record_stop
                        visible: recordStatus !== 0
                        width: Utl.dp(45)
                        height: Utl.dp(25)
                        anchors.verticalCenter: btn_play_pause.verticalCenter
                        anchors.left: btn_play_pause.right
                        anchors.leftMargin: Utl.dp(15)
                        radius: Utl.dp(4)
                        color: Color.GreenTheme
                        label.text: "Stop"
                        onClicked: {
                            player_c.recordStop();
                            recordFinish = true
                        }
                    }
                }
            }
        }

        //QML类型，可以播放音频
        Audio {
            id: player_q
            source: sourcePath
            //autoLoad: false
            //duration
            //loops : int --Audio.Infinite
            //position : int
            onDurationChanged: {
                if(duration > 0) {
                    totalDuration = duration
                    txt_time2.text = Tools.getTimeFormat(Math.floor(duration / 1000))
                }
            }
            onPlaying: {
                playStatus = 1
            }
            onPaused: {
                playStatus = 3
            }
            onStopped: {
                playStatus = 0
                console.log("xxxxx", playStatus, btn_qaudio.enabled)
            }
            onError: {
                playStatus = 0
                console.log("Audio...Error..", error, errorString)
            }
            onPositionChanged: {
                txt_time1.text = Tools.getTimeFormat(Math.floor(position / 1000))
                rect_progress.width = position / duration * rect_bg.width
            }
        }
    }

    //C++QMediaPlayer
    QAudio {
        id: player_c
        //播放
        onPlayStateChanged: {
            playStatus = state
            if(recordFinish && state === 0)
            {
                sourcePath = "file:///" + getFilePath()
            }

            console.log("play state...", state)
        }
        onPlayErrored: {
            playStatus = 0
            console.log("error", error)
        }
        onPlayDurationChanged: {
            console.log("duration...", duration)
            if(duration > 0) {
                totalDuration = duration
                txt_time2.text = Tools.getTimeFormat(Math.floor(duration / 1000))
            }
            console.log("duration...", duration)
        }
        onPlayPositionChanged: {
            console.log("position...", position)

            txt_time1.text = Tools.getTimeFormat(Math.floor(position / 1000))
            rect_progress.width = position / totalDuration * rect_bg.width
        }
        //录音
        onRecordStateChanged: {

        }
        onRecordErrored: {

        }
        onRecordDurationChanged: {

        }
    }
}
