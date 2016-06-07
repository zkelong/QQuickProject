import QtQuick 2.0
import "../controls"
import "../controls/color.js" as Color
import "../controls/font.js" as FontUtl
import "../config.js" as Config

/**
  *行业选择，跟基金类型那个差不多
  */

Rectangle {
    id:root

    clip: true
    anchors.fill: parent
    color: "#33000000"
    visible: false

    //用户选择，idx-0取消；1-确定
    signal itemSelected(int idx, int industryCode, string industryName)

    property int industryid: -1
    property string industryName: ""

    property int marginsSize: Utl.dp(10)
    property int cellHeight: Utl.dp(45)
    property string textColor: "#454545"
    property string buttonTextColor: Color.LoginBtcolor

    //加载数据
    Component.onCompleted: {
        var i = 0;
        console.log("compnet length: " + Config.Industries.length)
        for(i = 0; i < Config.Industries.length; ++i){
            listModel_assortment.append({btnText:Config.Industries[i].name,id:Config.Industries[i].value,tag:Config.Industries[i].tagText,colorDefine:Config.Industries[i].colorDefine})
            console.log(Config.Industries[i].name,Config.Industries[i].value,Config.Industries[i].tagText,Config.Industries[i].colorDefine)
        }
        console.log("listModel_assortment: " + listModel_assortment.count)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    ListModel{  //行业分类
        id:listModel_assortment
    }

    Component {
        id: msnDelegate
        Rectangle {
            id: _button
            height: cellHeight
            anchors.left: parent.left
            anchors.right: parent.right
            color: Color.VeryLightGrayB

            //选中时的背景
            Image {
                anchors.fill: parent
                source: (_listSortment.currentIndex == index) ? "qrc:/res/area_provence.jpg" : ""
            }

            Rectangle { //标签
                id: tagText
                height: Utl.dp(20)
                width: Utl.dp(35)
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(13.5)
                radius: Utl.dp(4)
                anchors.verticalCenter: parent.verticalCenter
                color: colorDefine

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: tag
                    color: Color.White
                    font.pointSize: FontUtl.ListShowFontSize
                }
            }

            Text {  //显示
                anchors.left:tagText.right
                anchors.leftMargin: Utl.dp(25)
                anchors.top: parent.top
                width: cellHeight
                height: cellHeight
                color: textColor
                font.pointSize: FontUtl.ListShowFontSize
                verticalAlignment: Text.AlignVCenter
                text: btnText
            }

            Line {
                width: parent.width
                height: Utl.dp(1)
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    _listSortment.currentIndex = index
                    root.industryid = id
                    root.industryName = btnText
                }
            }
        }
    }
    Rectangle{
        anchors.top: _choiceButton.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        ListView {
            id:_listSortment
            anchors.fill: parent
            spacing: Utl.dp(0)
            currentIndex: -1

            model: listModel_assortment
            delegate: msnDelegate
        }
    }

    //按钮
    Rectangle {
        id: _choiceButton
        width: parent.width
        height: Utl.dp(50)
        anchors.top: parent.verticalCenter
        anchors.left: parent.left
        color: buttonColor

        Button {
            id: btnCancel
            height: parent.height
            width:parent.width / 2
            anchors.left: parent.left
            label.text: qsTr("取消")
            label.color: Color.White//"#919191"
            font.pointSize: FontUtl.FontSizeMidA
            color: "#aaaaaa"

            onPressed: btnCancel.color = "#989898"
            onReleased: btnCancel.color = "#aaaaaa"

            onClicked: {                
                itemSelected(0, 0, "")
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
                if(root.industryid == -1) {
                    tip.content = qsTr("请选择行业")
                    tip.show()
                    return
                }
                itemSelected(1, root.industryid, root.industryName)
            }
        }
    }

    TipView{
        id:tip
    }
}

