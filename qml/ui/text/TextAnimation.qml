import QtQuick 2.0
import QtQuick.Controls 1.3
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: false

    property string marqueeStr: qsTr("滚动展示，轮播不停。。。滚动展示，轮播不停。。。11");
    property int rollTextMarginLeft: 0
    property int rollTextWidth: 0
    property int rollTextMarginTop: 0
    property var marqueeArr: [{marqueeStr: "翻滚吧，少年。。"},
        {marqueeStr: "翻滚吧，根本停不下来"},
        {marqueeStr: "尼玛，停不下来了~~！"}]
    property int marqueeArrShowIndex: 0

    Component.onCompleted: {
        rollTextWidth = rollText.width
        rollTextMarginTop = (rollTextBox1.height - rollText1.height)/2
    }

    Item {
        anchors.top: navbar.bottom;
        anchors.topMargin: Utl.dp(20)
        anchors.bottom: parent.bottom
        anchors.left: parent.left;
        anchors.right: parent.right

        Column {
            anchors.fill: parent
            spacing: Utl.dp(20)

            //左右跑
            Rectangle {
                id: rollTextBox
                width: parent.width * 0.8; height: parent.height / 10
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                border.width: 2
                border.color: "#555555"

                Text {
                    id: rollText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left;
                    anchors.leftMargin: rollTextMarginLeft
                    font.pointSize: 16
                    color: "Red"
                    text: marqueeStr
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        timer_marquee1.start()
                    }
                }
            }
            //上下跑
            Rectangle {
                id: rollTextBox1
                width: parent.width * 0.8; height: 80
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                border.width: 2
                border.color: "#555555"

                Text {
                    id: rollText1
                    anchors.top: parent.top; anchors.topMargin: rollTextMarginTop
                    anchors.left: parent.left;
                    anchors.leftMargin: 10
                    font.pointSize: 16
                    color: "Red"
                    text: marqueeArr[0].marqueeStr
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        timer_marquee2.start()
                    }
                }
            }

        }
    }

    //跑马灯--左右跑
    Timer {
        id: timer_marquee1
        interval: 5
        repeat: true
        triggeredOnStart: false  //false--开始时不触发onTriggered()信号；true--开始时触发onTriggered()信号
        onTriggered: {
            if(rollTextMarginLeft <= -rollTextWidth)
                rollTextMarginLeft = rollTextBox.width
            rollTextMarginLeft -= 1
        }
    }
    //跑马灯--上下跑
    Timer {
        id: timer_marquee2
        interval: 5
        repeat: true
        triggeredOnStart: false  //false--开始时不触发onTriggered()信号；true--开始时触发onTriggered()信号
        onTriggered: {
            if(rollTextMarginTop < -rollText1.height) { //高度循环
                if(marqueeArrShowIndex < marqueeArr.length - 1) //数组循环
                    marqueeArrShowIndex++
                else {
                    marqueeArrShowIndex = 0
                }
                rollText1.text = marqueeArr[marqueeArrShowIndex].marqueeStr
                rollTextMarginTop = rollTextBox1.height
            }
            rollTextMarginTop--
        }
    }


    NavigationBar {
        id: navbar
        title: "TextAnimation"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
}
