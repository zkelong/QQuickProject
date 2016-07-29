import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import "../controls"
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/tools.js" as Tools

View {
    id: root
    hidenTabbarWhenPush: true

    property var baseData: [
        {method: "1.每次，当你要刷牙的时候，在心里重复", value: "今天，我要开始新的生活!"}
        ,{method: "2.拿出牙刷，像个棒子吗？对!", value: "我是最棒的，一定会成功!"}
        ,{method: "3.拿出牙刷，前端是方的吗？", value: "成功一定有方法!"}
        ,{method: "4.挤出牙膏一点点", value: "我要每天进步一点点!"}
        ,{method: "5.张开口，准备将牙刷入进口里", value: "我要微笑面对全世界!"}
        ,{method: "6.牙膏“挨”着牙齿了，一排牙膏犹如一群人", value: "人人都是我的贵人!"}
        ,{method: "7.刷牙的时候，要横着刷牙，口张到最大的时候", value: "我是最伟大的推销员!"}
        ,{method: "8.刷牙完毕，看着镜子里的自己，坚定信心", value: "我爱我的事业!"}
        ,{method: "9.离开梳妆台", value: "我要立即行动!"}
        ,{method: "10.开始出门", value: "坚持到底，绝不放弃，直到成功!"}]

    Component.onCompleted: {
        text1.text = baseData[0].method
        text2.text = baseData[0].value
        showIndex = 1
    }

    NavigationBar {
        id: navbar
        title: "NumberMemory"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Item {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        Text {
            id: text1
            opacity: 0
            width: parent.width - Utl.dp(30)
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: Utl.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WrapAnywhere
            font.pointSize: FontUtl.FontSizeMidE
            color: Color.GreenTheme
        }
        Text {
            id: text2
            opacity: 0
            width: parent.width - Utl.dp(30)
            anchors.top: parent.verticalCenter
            anchors.topMargin: Utl.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WrapAnywhere
            font.pointSize: FontUtl.FontSizeMidE
            color: Color.GreenTheme
        }

        MouseArea { //向后
            visible: !show.running
            anchors.fill: parent
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("show..me....", text1.opacity, text2.opacity)
                    if(text1.opacity == 1 && text2.opacity == 1) {  //都显示
                        text1.opacity = 0
                        text2.opacity = 0
                        showNext()
                    } else if(text1.opacity == 0) { //method未显示
                        show.target = text1
                        show.start()
                    } else if(text2.opacity == 0) { //value未显示
                        show.target = text2
                        show.start()
                    }
                }
            }
        }
    }

    PropertyAnimation {
        id: show
        running: false
        duration: 300
        properties: "opacity"
        from: 0
        to: 1
    }

    property int showIndex: 0

    function showNext() {
        if(showIndex == baseData.length)
            showIndex = 0
        text1.text = baseData[showIndex].method
        text2.text = baseData[showIndex].value
        showIndex++
    }
}
