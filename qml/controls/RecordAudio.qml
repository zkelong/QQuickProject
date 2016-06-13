import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QAudio 1.0
import QKit 1.0
import "../controls/color.js" as Color
import "../controls/font.js" as FontUtl
import "../tools.js" as Tools
import "../api"
import "../controls"

View {
    id: root
    hidenTabbarWhenPush: true
    specialBack: true

    property string timeColor: "#454545"

    property int recordStatus: 0  //录音状态: 0-等待录音；1-录制中；2-录音结束
    property int playStatus: 0  //播放状态：0-等待播放；1-播放中；2-播放结束
    property int timeLimitUp: 90    //录制时间限制(秒数)
    property int timeLimitDown: 5    //录制时间限制(秒数)

    property int recordTime: 0  //录制时间长度
    property bool recordSucceed: false    //录制成功
    property string filePath: ""    //录音地址
    property bool onlyCheck: false  //只是查看-直接返回，不予提示

    property var voice: ({})    //语音 url, filePath, len

    signal saved(var voice)

    Component.onCompleted: {    //录了，跳出去，再回来
        if(voice && voice.filePath) {
            recordStatus = 2
            filePath = voice.filePath
            recordTime = voice.len
            showTimeText()
            onlyCheck = true
        }
    }

    Rectangle {
        id: rect
        width: parent.width
        anchors.top: navBar.bottom
        anchors.bottom: parent.bottom
        color: Color.Clear

        //Text { //调试信息打印
        //    id: test
        //    width: parent.width
        //    anchors.top: parent.top
        //    wrapMode: Text.WrapAnywhere
        //    color: "red"
        //}

        Button {     //录制
            id: record_button
            enabled: playStatus != 1  //非播放中
            height: Utl.dp(40)
            radius: Utl.dp(3)
            border.width: enabled ? 0 : Utl.dp(1)
            border.color: "#d0c1c3"
            anchors.top: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Utl.dp(20)
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: Utl.dp(18)
            color: enabled ? Color.BlueTheme : "#d1c0c0"
            label.color: enabled ? Color.White : "#505050"
            font.pointSize: FontUtl.FontSizeMidA
            label.text: {
                if(recordStatus == 0)
                    return qsTr("录音")
                else if(recordStatus == 1)
                    return qsTr("结束")
                else
                    return qsTr("重录")
            }
            onClicked: {
                if(recordStatus == 2)
                    playStatus = 0
                onlyCheck = false
                voice = {}
                qAudio.recorder()
            }
        }
        Button {     //播放
            id: play_button
            enabled: recordSucceed || filePath != ""
            height: Utl.dp(40)
            radius: Utl.dp(3)
            border.width: enabled ? 0 : Utl.dp(1)
            border.color: "#d0c1c3"
            anchors.verticalCenter: record_button.verticalCenter
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: Utl.dp(18)
            anchors.right: parent.right
            anchors.rightMargin: Utl.dp(20)
            color: enabled ? Color.BlueTheme : "#d1c0c0"
            label.color: enabled ? Color.White : "#505050"
            font.pointSize: FontUtl.FontSizeMidA
            label.text: {
                if(playStatus == 0)
                    return qsTr("播放")
                else if(playStatus == 1)
                    return qsTr("停止")
                else {
                    return qsTr("重播")
                }
            }
            onClicked: {
                qAudio.play(filePath)
            }
        }

        Text {  //时间
            id: text_time
            anchors.bottom: record_button.top
            anchors.bottomMargin: Utl.dp(60)
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: FontUtl.FontSizeSmallC
            color: timeColor
            text: qsTr("录制时长：") + timeLimitDown + qsTr("秒到") + timeLimitUp + qsTr("秒")
        }

        AnimatedSprite {
            id: animate_phone
            running: false
            width: Utl.dp(176)
            height: Utl.dp(95)
            anchors.bottom: text_time.top
            anchors.bottomMargin: Utl.dp(18)
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/res/microphonePic.png";
            frameDuration:400;
            frameCount: 4;
            frameX: 0;
            frameY: 0;
        }
    }

    QAudio {
        id: qAudio
        onStatusChanged:{
            //1：录音状态 2：录音停止 3：播放状态 4：播放停止
            switch(status){
            case 1:
                animate_phone.resume()
                if(!animate_phone.running) {
                    animate_phone.restart()
                }

                filePath = ""
                recordTime = 0
                recordSucceed = false
                recordStatus = 1
                text_time.text = "00:00:00"
                text_time.color = timeColor
                break;
            case 2:
                recordStatus = 2
                if(animate_phone.running) {
                    animate_phone.pause()
                    animate_phone.currentFrame = 0
                }
                if(recordTime < timeLimitDown) {
                    filePath = ""
                    recordSucceed = false //录制无效
                    text_time.text = qsTr("录音至少5秒，请重新录制")
                    text_time.color = Color.Red
                } else {   //录制有效
                    recordSucceed = true
                    filePath = "file:///"  + qAudio.getFilePath()
                }
                break;
            case 3:
                playStatus = 1
                K.setSpeaker(true); //使用扬声器
                text_time.text = qsTr("正在播放")
                text_time.color = Color.Blue
                break;
            case 4:
                playStatus = 2
                K.setSpeaker(false); //关闭扬声器
                showTimeText()
                break;
            }
        }
        onError:{
            switch(err){
            case 1:
                filePath = ""
                recordStatus = 2
                recordSucceed = false //录制无效
                text_time.text = qsTr("录制出错，请重试")
                text_time.color = Color.Red
                break;
            case 2:
                K.setSpeaker(false); //关闭扬声器
                playStatus = 2
                showTimeText()
                Tools.showTip("播放出错，请重试")
                break;
            }
        }

        onDurationChanged:{     //录制
            if(recordStatus == 2)   //状态变了，这边还要走。。。
                return
            var rTime = Math.floor(duration/1000)
            if(recordTime == rTime)
                return
            recordTime = rTime
            showTimeText()
            if(recordTime == timeLimitUp) {     //到达录制时间长度--停止录音
                qAudio.recorder()
            }
        }
        onPositionChanged:{     //播放
            //console.log("positio...", position)
        }
    }

    NavigationBar{
        id: navBar
        title: qsTr("语音介绍")
        onBackClicked: {
            backAction()
        }

        Button {
            id: releaseBtn
            visible: recordSucceed
            width: Utl.dp(50)
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin:Utl.dp(5)
            anchors.verticalCenter: parent.verticalCenter
            label.text: qsTr("保存")
            font.pointSize: FontUtl.FontSizeMidE
            label.color: Color.BlueTheme
            onClicked: {
                if(playStatus == 1) //停止播放
                    qAudio.play(filePath)
                saveFile()
            }
        }
        Line{
            anchors.bottom: parent.bottom
        }
    }

    //对话框
    DialogView{
        id: dialogbox
        z: 10
        content: qsTr("是否放弃录音")
        rightName: qsTr("否")
        leftName: qsTr("是")
        onLeftAction:  {
            root.navigationView.pop()
        }
    }

    function showTimeText() {   //显示时间
        text_time.color = timeColor
        var timeStr = ("00" + Math.floor(recordTime/3600)).slice(-2)   //时
        timeStr +=  ":" + ("00" + Math.floor(recordTime%3600/60)).slice(-2)   //分
        timeStr += ":" + ("00" + recordTime%60).slice(-2)   //秒
        text_time.text = timeStr
    }

    function saveFile() {   //上传音频
        if(recordSucceed) {
            Tools.showBusy()
            Api.uploadFile(filePath.substring(8, filePath.length), function (obj){
                Tools.hidenBusy()
                if(obj) {
                    voice.len = recordTime
                    voice.url = obj
                    voice.filePath = filePath
                    Tools.showTip(qsTr("保存成功"))
                    root.saved(voice)
                    root.navigationView.pop()
                } else {
                    Tools.showTip(qsTr("上传录音失败"))
                }
            })
        }
    }

    function back() {   //返回键操作
        backAction()
        return false
    }

    function backAction() { //返回动作
        if(playStatus == 1) //停止播放
            qAudio.play(filePath)
        if(recordStatus == 0 || onlyCheck) {
            root.navigationView.pop()
            return
        }
        //录制中，录制完成，提示
        if(dialogbox.visible) {    //提示放弃
            dialogbox.visible = false
        }  else {
            dialogbox.visible = true
        }
    }
}
