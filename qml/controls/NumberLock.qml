import QtQuick 2.5
import "../api"
import "../toolsbox/color.js" as ColorUtl
import "../toolsbox/font.js" as FontUtl

Rectangle {
    id: root
    color: "#f0f0f0"

    property real cellWidth: root.width/3
    property real cellHeight: cellWidth * 0.85
    //键盘类型
    property int keyTypeNumber: 1
    property int keyTypeWord: 2
    property int keyTypeImage: 3
    //圆点数量
    property int pointsNum: 4
    //圆点颜色
    property string defaultColor: "#aeb5bf"
    property string putinColor: "green"
    property string errorColor: "red"
    //圆点对象
    property var pointItems: []
    //输入数字个数
    property int putinNum: 0
    property string password: ""
    property string passwordNew: ""
    property bool haveOldPassword: false   //是否有老密码
    property int setNewPasswordStep: 0  //0--验证老密码；1--第一次输入新密码；2--第二次输入新密码

    property int type: 0    //0--密码验证；1--设置密码

    //取消
    signal canceled()
    //验证通过
    signal passed()
    //验证出错
    signal pdErroed()
    //设置新密码成功
    signal setNewSucceed()

    Component.onCompleted: {
        setKeyShow()
        for(var i = 0; i < pointsNum; i++) {
            var pointItem = point.createObject(points);
            pointItems.push(pointItem)
        }
    }

    Item {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: rect_keyboard.top

        Column {
            anchors.centerIn: parent
            width: childrenRect.width
            height: childrenRect.height
            spacing: Utl.dp(15)

            Item {  //图片
                id: item0
                width: childrenRect.width
                height: childrenRect.height
                RoundImage {
                    id: img
                    width: Utl.dp(45)
                    height: width
                    radius: Utl.dp(5)
                    source: "qrc:/res/icon.png"
                }
                Text {
                    id: name
                    anchors.left: img.right
                    anchors.leftMargin: Utl.dp(6)
                    anchors.top: img.top
                    font.pointSize: FontUtl.FontSizeBigD
                    color: "#323232"
                    text: qsTr("DDU内容")
                }
                Text {
                    anchors.left: name.left
                    anchors.top: name.bottom
                    anchors.topMargin: Utl.dp(2)
                    font.pointSize: FontUtl.FontSizeSmallA
                    color: "#a1a1a1"
                    text: "http://my.csdn.net/u012419303"
                }
            }
            Text {
                id: tip
                anchors.horizontalCenter: item0.horizontalCenter
                font.pointSize: FontUtl.FontSizeMidD
                color: "#989ba0"
                text: qsTr("请输入密码")
            }
            Row {
                id: points
                anchors.horizontalCenter: item0.horizontalCenter
                width: childrenRect.width
                height: childrenRect.height
                spacing: Utl.dp(25)
            }
        }
    }

    Rectangle {
        id: rect_keyboard
        width: parent.width
        height: cellHeight*4 + Utl.dp(15)
        anchors.bottom: parent.bottom

        GridView {
            id: gv
            interactive: false
            width: parent.width
            height: parent.height-Utl.dp(15)
            cellWidth: root.cellWidth
            cellHeight: root.cellHeight
            model: _model
            delegate: _delegate
        }
    }

    ListModel {
        id: _model
    }

    Component {
        id: _delegate
        Rectangle {
            width: gv.cellWidth
            height: gv.cellHeight

            states: State {
                name: "showbg"
                when: mouse_delegate.pressed
                PropertyChanges {
                    target: rect_bg
                    visible: true
                }
                PropertyChanges {
                    target: text_delegate
                    color: "white"
                }
                PropertyChanges {
                    target: img_delegate
                    source: "qrc:/res/delete_back_white.png"
                }
            }

            Rectangle {
                id: rect_bg
                visible: false
                anchors.centerIn: parent
                width: parent.height * .75
                height: width
                radius: width/2
                color: "#3993ff"
            }

            Text {
                id: text_delegate
                anchors.centerIn: parent
                font.pointSize: keyType === keyTypeNumber ? FontUtl.FontSizeLargrC : FontUtl.FontSizeMidC
                color: "#979ca2"
                text: showStr ? showStr : ""
            }
            Image { //删除键
                id: img_delegate
                visible: keyType === keyTypeImage
                width: Utl.dp(35)
                height: Utl.dp(35)
                anchors.centerIn: parent
                source: keyType === keyTypeImage ? picUrl : ""
            }
            MouseArea {
                id: mouse_delegate
                anchors.fill: parent
                onClicked: {
                    switch(keyType) {
                    case keyTypeNumber: //数字
                        password += showStr
                        if(putinNum < pointsNum)
                            putinNum++
                        break;
                    case keyTypeWord:   //取消
                        root.canceled()
                        return;
                    case keyTypeImage:  //删除
                        if(putinNum > pointsNum) {
                            putinNum = 4
                            password = password.substring(0, 4)
                        }
                        password = password.substring(0, password.length-1)
                        if(putinNum > 0)
                            putinNum--
                        break;
                    }
                    if(putinNum <= pointsNum && keyType !== keyTypeWord) {  //设置圆点显示
                        setPointsColor(1)
                    }
                    if(keyType === keyTypeWord || putinNum !== pointsNum)
                        return
                    if(type == 0) {   //验证密码
                        checkPassword()
                    } else {    //设置新密码
                        setNewPassword()
                    }
                }
            }
        }
    }

    Component {
        id: point
        Rectangle {
            width: Utl.dp(12)
            height: width
            radius: width/2
            color: defaultColor
        }
    }

    //设置键盘按键内容
    function setKeyShow() {
        for(var i = 1; i < 13; i++) {
            var item;
            if(i < 10) {
                item = {
                    keyType: keyTypeNumber
                    ,showStr: i+""
                }
            } else if(i === 10) {
                item = {
                    keyType: keyTypeWord
                    ,showStr: qsTr("取消")
                }
            } else if(i === 11) {
                item = {
                    keyType: keyTypeNumber
                    ,showStr: "0"
                }
            } else {
                item = {
                    keyType: keyTypeImage
                    ,picUrl: "qrc:/res/delete_back.png"
                }
            }
            _model.append(item)
        }
    }

    //设置点点的颜色
    //keyType: 0--全设为默认色；1--设置输入时的颜色；2--设置错误时的颜色
    function setPointsColor(setType) {
        var i;
        switch(setType) {
        case 0: //默认颜色
            for(i = 0; i < pointItems.length; i++) {
                pointItems[i].color = defaultColor
            }
            break;
        case 1:   //输入时设置颜色
            for(i = 0; i < pointsNum; i++) {
                if(i < putinNum) {
                    pointItems[i].color = putinColor
                } else {
                    pointItems[i].color = defaultColor
                }
            }
            break;
        case 2:  //错误时的颜色
            for(i = 0; i < pointItems.length; i++) {
                pointItems[i].color = errorColor
            }
            break;
        }
    }

    //显示错误信息
    function showErro() {
        putinNum = 0
        password = ""
        setPointsColor(2)
        tip.color = errorColor
        if(type == 1 && setNewPasswordStep == 2)
            tip.text = qsTr("密码不一致，请重新设置")
        else
            tip.text = qsTr("密码错误，请重新输入")
        animatoin.start()
    }

    SequentialAnimation {
        id: animatoin
        running: false
        PropertyAnimation{target: tip; properties: "scale"; to: 1.3; duration: 800; easing.type: Easing.OutInElastic}
        PropertyAnimation{target: tip; properties: "scale"; to: 1; duration: 500;}
        onStarted: {
            root.enabled = false
        }
        onStopped: {
            root.enabled = true
            setPointsColor(0)
        }
    }

    //检查密码
    function checkPassword() {
        Api.checkPassword(password, function(obj){
            if(obj) {
                if(type == 0) {
                    hide()
                    passed()
                } else {
                    password = ""
                    putinNum = 0
                    setPointsColor(0)
                    tip.color = "#989ba0"
                    tip.text = qsTr("请输入新密码")
                    setNewPasswordStep = 1
                }
            } else {
                root.pdErroed()
                showErro()
            }
        })
    }

    //设置新密码
    function setNewPassword() {
        switch(setNewPasswordStep) {
        case 0: //验证旧密码
            checkPassword()
            break;
        case 1: //第一次输入新密码
            setNewPasswordStep = 2
            passwordNew = password
            password = ""
            putinNum = 0
            setPointsColor(0)
            tip.text = qsTr("请再次输入新密码")
            tip.color = "#989ba0"
            break;
        case 2: //第二次输入新密码
            if(password === passwordNew) {
                Api.setDduPassword(password)
                setNewSucceed()
                root.hide()
            } else {
                showErro()
                setNewPasswordStep = 1
            }
            break;
        }
    }

    //显示
    function show(type) {
        type = type || 0
        root.type = type
        tip.color = "#989ba0"
        if(type === 1) {
            Api.getDduPassword(function(obj){
                if(obj) {   //有老密码
                    haveOldPassword = true
                    setNewPasswordStep = 0
                    tip.text = qsTr("请输入原密码")
                } else {
                    setNewPasswordStep = 1
                    tip.text = qsTr("设置密码")
                }
            })
        }
        putinNum = 0
        password = ""
        setPointsColor(0)
        root.visible = true
    }
    //隐藏
    function hide() {
        root.visible = false
    }
}

