import QtQuick 2.0
import "../controls/font.js" as FontUtl
import "../controls/color.js" as Color

//显示系统提示信息

Rectangle {
    id: _systemInfo
    width: dialogWidth
    height: dialogHeight
    anchors.centerIn: parent
    border.color: Color.Bordercolor
    border.width: Utl.dp(3)

    property string info: ""
    property alias editText: _text
    property variant parentView: null

    property int dialogWidth: Utl.dp(200)
    property int dialogHeight: Utl.dp(150)
    property int textWidth: Utl.dp(160)
    property int textHeight: Utl.dp(120)


    Text {
        id: _text
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        font.pointSize: FontUtl.FontSizeSmallB
        maximumLineCount: 200
        wrapMode: Text.WrapAnywhere
        lineHeight: 1.5
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: info

        MouseArea {
            anchors.fill: parent
            onClicked: {
                parentView.hideInfo()
            }
        }
    }
}

