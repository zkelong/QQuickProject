import QtQuick 2.4
import "../controls/color.js" as Color
import "../controls/font.js" as FontUtl
import "../config.js" as Config
import "../api.js" as Api
import "../tools.js" as Tools
import "../code.js" as Code

/**
*列表单选，列表中单选其中一个
*众筹星球--基金选择
*/

Rectangle {
    id: root
    clip: true
    color: "#33000000"
    visible: false

    /*用户选择，idx-0取消；1-确定
    *fundFormId: 选中项的id
    *fundFormStr: 选中项的字符串
    */
    signal itemSelected(int idx, int fundFormId, string fundFormStr);
    property int fundFormId: -1
    property string fundFormStr: ""

    Component.onCompleted: {
        loadFundFormList()
    }

    function loadFundFormList() {   //加载列表数据
        for (var i = 0; i < Config.fundForm.length; i++) {
            //name: 显示字符串，value: 选择的id，checkable:能否选择
            listFundForm.append({name: Config.fundForm[i].name, value: Config.fundForm[i].value, checkable: true})
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    //按钮
    Rectangle {
        id: _choiceButton
        width: parent.width
        height: Utl.dp(50)
        anchors.top: parent.verticalCenter
        anchors.left: parent.left

        Button {
            id: btnCancel
            height: parent.height
            width:parent.width / 2
            anchors.left: parent.left
            label.text: qsTr("取消")
            label.color: Color.White//"#919191"
            font.pointSize: 21
            color: "#aaaaaa"

            onPressed: btnCancel.color = "#989898"
            onReleased: btnCancel.color = "#aaaaaa"

            onClicked: {
                itemSelected(0, fundFormId, fundFormStr)
            }
        }

        Button {
            id: btnSure
            height: parent.height
            anchors.right: parent.right
            width: parent.width / 2
            label.text: qsTr("确定")
            font.pointSize: 21
            label.color: Color.White
            color: "#b83c09"

            onPressed: btnSure.color = "#8e3209"
            onReleased: btnSure.color = "#b83c09"

            onClicked: {
                if(fundFormId == -1) {
                    Tools.showTip("未选中基金形式")
                    return
                }
                itemSelected(1, fundFormId, fundFormStr)
            }
        }

        Line {
            anchors.bottom: parent.bottom
            color: "#999898"
        }
        Line {
            anchors.top: parent.top
            color: "#999898"
        }
    }

    //基金形式
    ListModel {
        id: listFundForm
    }

    //基金形式
    Rectangle {
        id: _industrySelect
        anchors.top: _choiceButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        ListView {
            id: _listView
            anchors.fill: parent
            clip: true
            currentIndex: -1

            model: listFundForm
            delegate: msnDelegate
        }

        //上阴影
        Image {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Utl.dp(3)
            source: "qrc:/res/area_top.png"
        }

        //左阴影
        Image {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Utl.dp(3)
            source: "qrc:/res/area_left.png"
        }

        //右阴影
        Image {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width: Utl.dp(3)
            source: "qrc:/res/area_right.png"
        }
    }

    Component {
        id: msnDelegate
        Rectangle {
            id: _button
            height: Utl.dp(50)
            anchors.left: parent.left
            anchors.right: parent.right
            radius: Utl.dp(2) //圆角
            border.color: Color.Bordercolor
            border.width: Utl.dp(1)
            color: Color.VeryLightGrayB

            //选中时的背景
            Image {
                anchors.fill: parent
                source: (_listView.currentIndex == index) ? "qrc:/res/bg_select.jpg" : ""
            }

            Rectangle { //不能选择时的背景
                id: rect_bg
                visible: !checkable
                anchors.fill: parent
                color: "#020202"
            }

            Text {
                text: name
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: Color.DarkGray
                font.pointSize: FontUtl.ListShowFontSize
            }

            MouseArea {
                anchors.fill: parent
                enabled: checkable
                onClicked: {
                    _listView.currentIndex = index
                    fundFormId = value
                    fundFormStr = name
                }
            }
        }
    }
}
