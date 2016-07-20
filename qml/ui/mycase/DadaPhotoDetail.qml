import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl


View {
    id: root
    hidenTabbarWhenPush: true

    property real thumbnailScale: content_item.height/root.height * .95
    property bool preview: false    //预览
    property real originY: navbar.height + (content_item.height - root.height*scale)/2
    property int bgIndex: -1

    Component.onCompleted: {
        for(var i = 0; i < 10; i++) {
            var item = {
                pic: Config.wallpaperUrl[i]
            }
            _model.append(item)
        }
        bgIndex = 0
    }

    NavigationBar {
        id: navbar
        title: "上传照片"
        titleLabel.font.pointSize: FontUtl.FontSizeMidA
        titleLabel.color: "#4792dc"
        button.icon.normalSource: "qrc:/res/arrow_left5.png"
        button.icon.width: Utl.dp(27)
        button.icon.height: Utl.dp(27)
        onButtonClicked: {
            root.navigationView.pop()
        }

        Button {
            id: _complete
            height: parent.height
            width: Utl.dp(60)
            anchors.right: parent.right
            font.pointSize: FontUtl.FontSizeSmallA
            label.color: "#4792dc"
            label.text: qsTr("完成")
        }
    }

    Item {
        id: bottom_item
        width: parent.width
        height: Utl.dp(100)
        anchors.bottom: parent.bottom

        Item { //删除-上传
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: -content_item.height*0.05/2
            anchors.bottom: listView.top
            anchors.bottomMargin: -listView.height*0.1/2

            Button {
                id: _deleteBtn
                width: Utl.dp(35)
                height: Utl.dp(25)
                radius: Utl.dp(4)
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Utl.dp(15)
                font.pointSize: FontUtl.FontSizeSmallC
                label.color: "#4792dc"
                label.text: qsTr("删除")
                onClicked: {
                    console.log("delete")
                }
            }
            Button {
                id: _uploadBtn
                width: Utl.dp(35)
                height: Utl.dp(25)
                radius: Utl.dp(4)
                color: "white"
                anchors.verticalCenter: _deleteBtn.verticalCenter
                anchors.right: _deleteBtn.left
                anchors.rightMargin: Utl.dp(15)
                font.pointSize: FontUtl.FontSizeSmallC
                label.color: "#4792dc"
                label.text: qsTr("上传")
                onClicked: {
                    console.log("upload")
                }
            }
        }

        //照片--小的
        ListView {
            id: listView
            width: parent.width
            height: Utl.dp(75)
            anchors.bottom: parent.bottom
            orientation: ListView.Horizontal    //横向
            model: _model
            delegate: _delegate
        }
    }

    Item {
        id: content_item
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: bottom_item.top
    }

    Rectangle { //缩略
        id: rect_thumbnail
        height: root.height
        width: root.width
        y: originY
        anchors.horizontalCenter: content_item.horizontalCenter
        border.width: 1
        scale: thumbnailScale

        MouseArea {
            anchors.fill: parent
            onClicked: {
                play.start()
            }
        }

        ParallelAnimation {  //并行动画
            id: play
            running: false
            PropertyAnimation { target: rect_thumbnail; property: "scale";
                to: preview ? thumbnailScale : 1; duration: 300}
            PropertyAnimation { target: rect_thumbnail; property: "y";
                to: preview ? originY : 0; duration: 300}
            PropertyAnimation { target: _rectFace; property: "opacity";
                to: preview ? 1 : 0; duration: 300}
            onStopped: {
                preview = !preview
            }
        }

        //背景
        ListView {
            id: listView_bg
            anchors.fill: parent
            orientation: ListView.Horizontal    //横向
            model: _model
            delegate: _delegate_bg
            interactive: false
            currentIndex: bgIndex
            clip: true
            highlightMoveDuration: 300
        }

        //图片切换按钮
        Button {
            visible: bgIndex < _model.count - 2 && preview
            width: Utl.dp(35)
            height: Utl.dp(40)
            icon.width: Utl.dp(15)
            icon.height: Utl.dp(27)
            icon.normalSource: "qrc:/res/arrow_right.png"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            color: "#50000000"
            onClicked: {
                bgIndex++
            }
        }
        Button {
            visible: bgIndex > 0 && preview
            width: Utl.dp(35)
            height: Utl.dp(40)
            icon.width: Utl.dp(15)
            icon.height: Utl.dp(27)
            icon.normalSource: "qrc:/res/arrow_right.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            rotation: 180
            color: "#50000000"
            onClicked: {
                bgIndex--
            }
        }

        //设为封面
        Rectangle {
            id: _rectFace
            width: Utl.dp(60)
            height: Utl.dp(35)
            radius: Utl.dp(4)
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(12)
            anchors.right: parent.right
            anchors.rightMargin: Utl.dp(18)
            color: "#30000000"
            Rectangle {
                anchors.fill: parent
                anchors.margins: Utl.dp(3)
                radius: Utl.dp(4)
                anchors.centerIn: parent
                color: "transparent"
                border.color: "#ffffff"
                Text {
                    anchors.centerIn: parent
                    font.pointSize: FontUtl.FontSizeSmallC
                    color: "white"
                    text: qsTr("设为封面")
                }
            }
            MouseArea {
                visible: !preview
                anchors.fill: parent
                onClicked: {
                    console.log("设封面")
                }
            }
        }

        //个人资料
        Image {
            id: info_bg
            width: parent.width
            height: Utl.dp(53)
            anchors.bottom: parent.bottom
            source: "qrc:/res/bg.png"

            RoundImage {    //头像
                id: head_img
                height: parent.height-Utl.dp(18)
                width: height
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(5)
                anchors.verticalCenter: parent.verticalCenter
                radius: width/2
                border.color: "#de8696"
                border.width: Utl.dp(2)
                borderScape: 1
                source: "http://www.ld12.com/upimg358/allimg/c140918/14109D312RN0-352364.jpg"
            }
            Text {      //昵称
                id: nickname
                anchors.bottom: head_img.verticalCenter
                anchors.bottomMargin: Utl.dp(2)
                anchors.left: head_img.right
                anchors.leftMargin: Utl.dp(6)
                font.pointSize: FontUtl.FontSizeSmallC
                color: "#dddcda"
                text: qsTr("我是柳岩本人")
            }

            ScoreView{  //评级
                id: _score
                anchors.right: callTime.right
                anchors.verticalCenter: nickname.verticalCenter
                spacing: 2
                num: 5
                imgUrl: "qrc:/res/start_yellow.png"
                imgUrl2: "qrc:/res/start_yellowE.png"
                imgWidth: Utl.dp(11)
            }

            Rectangle { //性别+年龄
                id: rect_sex
                height: Utl.dp(15)
                width: Utl.dp(45)
                radius: height/2
                anchors.left: nickname.left
                anchors.top: head_img.verticalCenter
                anchors.topMargin: Utl.dp(2)
                color: "#ff8c53"

                Image {
                    height: Utl.dp(11)
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Utl.dp(5)
                    source: "qrc:/res/male_gray.png"
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: Utl.dp(5)
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("18岁")
                    color: "#edebee"
                }
            }
            Text {      //昵称
                id: price
                anchors.verticalCenter: rect_sex.verticalCenter
                anchors.left: rect_sex.right
                anchors.leftMargin: Utl.dp(15)
                font.pointSize: FontUtl.FontSizeSmallC
                color: "#dddcda"
                text: qsTr("1元/分钟")
            }
            Text {      //昵称
                id: callTime
                anchors.verticalCenter: rect_sex.verticalCenter
                anchors.left: price.right
                anchors.leftMargin: Utl.dp(10)
                font.pointSize: FontUtl.FontSizeSmallC
                color: "#dddcda"
                text: qsTr("累计通话 0小时")
            }
        }
    }

    ListModel {
        id: _model
    }

    Component {
        id: _delegate_bg
        ImageLoader {
            width: root.width
            height: root.height
            defaultSource: Config.DefaultImage
            fillModel: Image.PreserveAspectCrop
            source: pic
        }
    }

    Component {
        id: _delegate
        Item {
            id: delegate_item
            height: listView.height
            width: height
            RoundImage {
                height: parent.height - Utl.dp(6)
                width: height * 0.9
                anchors.centerIn: parent
                radius: Utl.dp(2)
                source: pic
                defaultSource: Config.DefaultImage
            }
        }
    }
}

