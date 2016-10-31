import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

//图像处理HueSaturation
View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "TestHurSturation"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Item {
        id: _item
        width: parent.width
        height: root.height/2
        anchors.top: navbar.bottom
        //目标图片
        Image {
            id: img
            visible: false
            width: parent.width - Utl.dp(30)
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            source: "qrc:/res/h1.jpg"
        }

        //处理工具
        HueSaturation {
            id: _hue
            anchors.fill: img
            source: img //处理对象（Image）
            hue: 0.0    //色调：-1.0~1.0 default(0.0)
            saturation: 0.0 //饱和度：-1.0~1.0 default(0.0)
            lightness: 0.0  //亮度：-1.0~1.0 default(0.0)
        }
    }

    Column {
        id: _column
        width: parent.width
        height: childrenRect.y + childrenRect.height
        anchors.top: _item.bottom
        spacing: Utl.dp(4)

        //色调
        Text {
            anchors.left:parent.left
            anchors.leftMargin: Utl.dp(10)
            font.pointSize: FontUtl.FontSizeSmallE
            text: qsTr("色调(-1.0~1.0 default(0.0)): ") + bar1.progress
        }
        AdjustableScrollBar {
            id: bar1
            width: parent.width - Utl.dp(40)
            anchors.horizontalCenter: parent.horizontalCenter
            onProgressChanged: {
                _hue.hue = progress
            }
        }

        //饱和度
        Text {
            anchors.left:parent.left
            anchors.leftMargin: Utl.dp(10)
            font.pointSize: FontUtl.FontSizeSmallE
            text: qsTr("饱和度(-1.0~1.0 default(0.0)): ") + bar2.progress
        }
        AdjustableScrollBar {
            id: bar2
            width: parent.width - Utl.dp(40)
            anchors.horizontalCenter: parent.horizontalCenter
            onProgressChanged: {
                _hue.saturation = progress
            }
        }

        //亮度
        Text {
            anchors.left:parent.left
            anchors.leftMargin: Utl.dp(10)
            font.pointSize: FontUtl.FontSizeSmallE
            text: qsTr("亮度(-1.0~1.0 default(0.0)): ") + bar3.progress
        }
        AdjustableScrollBar {
            id: bar3
            width: parent.width - Utl.dp(40)
            anchors.horizontalCenter: parent.horizontalCenter
            onProgressChanged: {
                _hue.lightness = progress
            }
        }
    }

    Text {
        anchors.bottom: pb.top
        anchors.topMargin: Utl.dp(5)
        anchors.left:parent.left
        anchors.leftMargin: Utl.dp(10)
        font.pointSize: FontUtl.FontSizeSmallE
        text: qsTr("进度条：") + pb.progress
    }
    ProgressBar {
        id: pb
        width: parent.width - Utl.dp(40)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: _column.bottom
        anchors.topMargin: Utl.dp(40)
    }
}

