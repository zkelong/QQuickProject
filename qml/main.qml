import QtQuick 2.4
import QtQuick.Window 2.2
import QKit 1.0
import "."
import "./controls"
import "toolsbox/tools.js" as Tools


import "toolsbox/api.js" as Api
import "toolsbox/config.js" as Config

Window {
    id: win
    visible: true
    width: Utl.dp(300)
    height: Utl.dp(600)

    //property alias positionService: pos //位置服务

    property bool exit: false   //退出操作

    Component.onCompleted: {
        Tools.setMainWindow(win);
        Tools.registMainStack(mainNav)
        Tools.registMainBusy(busy);
        Tools.registMainTip(tip);
        //pos.start();
    }

    NavigationView {
        id: mainNav
        anchors.fill: parent
        initialItem: Component{
            MainEg{
            }
        }
    }

    //加载界面
    BusyView {
        id: busy
        anchors.centerIn: parent
    }

    //提示界面
    TipView {
        id: tip
    }

    MouseArea {

    }

    ////地址服务
    //PositionService {
    //    id:pos
    //    geocoding: true
    //    onAddressChanged: {
    //        if(pos.address){
    //            pos.stop();
    //        }
    //    }
    //}

    Timer {  //短时间点击返回才做退出操作
        id: exitTimer
        running: false; repeat: false; interval: 1500
        onTriggered: {
            exit = false
        }
    }

    //监听android返回键
    onActiveFocusItemChanged: {
        if (activeFocusItem !== null && activeFocusItem.Keys !== undefined)
            activeFocusItem.Keys.onReleased.disconnect(onKeyReleased)

        if (activeFocusItem !== null) {
            activeFocusItem.Keys.onReleased.connect(onKeyReleased)
        }
    }

    function onKeyReleased(event) {
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
            event.accepted = true;
            if (Qt.inputMethod.visible){  //隐藏键盘
                Qt.inputMethod.hide()
                return
            }
            if(Tools.stackView.currentItem.specialBack) { //单独写了返回按钮处理
                Tools.stackView.currentItem.keyBackAct()
            } else if(Tools.stackView.depth>1) {
                if(Tools.busyRunning())
                    Tools.hidenBusy()
                Tools.stackView.pop()
            }/* else if(Tools.stackView.depth === 1){    //退出程序操作
                if(exit == true) {
                    Qt.quit()
                } else {
                    Tools.showTip(qsTr("再按一次退出程序"))
                    exit = true
                    exitTimer.start()
                }
            }*/
        }
    }

    MouseArea {
        id: enableM
        visible: false
        anchors.fill: parent
        onClicked: {}
    }

    function setEnabled(enable) {
        if(enable) {
            enableM.visible = false
        } else {
            enableM.visible = true
        }
    }

    function setWindowShow(show) {
        if(show) {
            win.show()
        } else {
            win.hide()
        }
    }
}
