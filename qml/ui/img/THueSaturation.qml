import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

//图像处理HueSaturation
View {
    id: root

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
        anchors.left:parent.left
        anchors.leftMargin: Utl.dp(10)
        anchors.top: _item.bottom
        spacing: Utl.dp(4)

        //色调
        Text {
            font.pointSize: FontUtl.FontSizeSmallE
            text: qsTr("色调(-1.0~1.0 default(0.0)):")
        }
        Rectangle {
            height: Utl.dp(18)
            width: Utl.dp(80)
            border.width: Utl.dp(1)
            TextInput {
                id: txt_hur
                anchors.fill: parent
                anchors.margins: Utl.dp(3)
                verticalAlignment: TextInput.AlignVCenter
            }
        }


        //饱和度
        Text {
            font.pointSize: FontUtl.FontSizeSmallE
            text: qsTr("饱和度(-1.0~1.0 default(0.0)):")
        }
        Rectangle {
            height: Utl.dp(18)
            width: Utl.dp(80)
            border.width: Utl.dp(1)
            TextInput {
                id: txt_saturation
                anchors.fill: parent
                anchors.margins: Utl.dp(3)
                verticalAlignment: TextInput.AlignVCenter
            }
        }
        //亮度
        Text {
            font.pointSize: FontUtl.FontSizeSmallE
            text: qsTr("亮度(-1.0~1.0 default(0.0)):")
        }
        Rectangle {
            height: Utl.dp(18)
            width: Utl.dp(80)
            border.width: Utl.dp(1)
            TextInput {
                id: txt_lightness
                anchors.fill: parent
                anchors.margins: Utl.dp(3)
                verticalAlignment: TextInput.AlignVCenter
            }
        }

        Button {
            height: Utl.dp(18)
            width: Utl.dp(50)
            color: Color.ButtonColor
            label.text: qsTr("确定")
            onClicked: {
                if(txt_hur.text.trim() != "" && !isNaN(txt_hur.text))
                    _hue.hue = txt_hur.text
                if(txt_saturation.text.trim() != "" && !isNaN(txt_saturation.text))
                    _hue.saturation = txt_saturation.text
                if(txt_lightness.text.trim() != "" && !isNaN(txt_lightness.text))
                    _hue.lightness = txt_lightness.text
            }
        }
    }


    AdjustableScrollBar {
        anchors.top: _column.bottom
        width: Utl.dp(250)
    }
}

