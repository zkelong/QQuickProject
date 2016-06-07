import QtQuick 2.0
import QtQuick.Controls 1.2
import "../toolsbox/color.js" as Color

Rectangle {
    id: root
    color: Color.ViewColor

    property StackView navigationView: null
    property bool hidenTabbarWhenPush: false
    property int currentPageState:1
    property bool specialBack: false   //特殊的返回键处理 需要写keyBackAct()方法

    onVisibleChanged: {
        if(root.visible) {
            root.enabled = true
            root.focus = true
            if (Qt.inputMethod.visible){  //隐藏键盘
                Qt.inputMethod.hide()
            }
        }
    }
}

