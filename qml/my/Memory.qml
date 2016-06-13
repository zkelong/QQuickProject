import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"

View {
    id: root
    property int showIndex: 0;  //随机产生到第几个数
    property int tenIndex: 0    //十位
    property int onesIndex: 0   //个位
    property int showType: 0    //显示类型：0-显示数字和对象；1-显示文字；2-显示对象
    property var baseData: [
        {id: "0", value: "鸡蛋"},
        {id: "1", value: "金箍棒"},
        {id: "2", value: "鸭子"},
        {id: "3", value: "耳朵"},
        {id: "4", value: "旗子"},
        {id: "5", value: "钩子"},
        {id: "6", value: "哨子/勺子"},
        {id: "7", value: "锄头"},
        {id: "8", value: "葫芦"},
        {id: "9", value: "球拍"},
        {id: "00", value: "望远镜"},
        {id: "01", value: "灵药"},
        {id: "02", value: "铃儿"},
        {id: "03", value: "灵山"},
        {id: "04", value: "灵寺"},
        {id: "05", value: "领舞"},
        {id: "06", value: "羚鹿"},
        {id: "07", value: "令旗/灵气"},
        {id: "08", value: "泥巴"},
        {id: "09", value: "灵酒"},
        {id: "10", value: "棒球"},
        {id: "11", value: "筷子"},
        {id: "12", value: "幺儿"},
        {id: "13", value: "药散"},
        {id: "14", value: "钥匙"},
        {id: "15", value: "妖物/妖雾"},
        {id: "16", value: "水流"},
        {id: "17", value: "仪器/妖旗"},
        {id: "18", value: "要发"},
        {id: "19", value: "药酒"},
        {id: "20", value: "耳饰"},
        {id: "21", value: "鳄鱼"},
        {id: "22", value: "鸳鸯"},
        {id: "23", value: "峨眉山"},
        {id: "24", value: "2死/傻子"},
        {id: "25", value: "二胡"},
        {id: "26", value: "二流"},
        {id: "27", value: "爱妻/新娘"},
        {id: "28", value: "恶霸"},
        {id: "29", value: "恶狗"},
        {id: "30", value: "三菱"},
        {id: "31", value: "鲨鱼/山药/山玉"},
        {id: "32", value: "伞儿"},
        {id: "33", value: "钻石闪闪"},
        {id: "34", value: "三丝"},
        {id: "35", value: "珊瑚"},
        {id: "36", value: "山麓"},
        {id: "37", value: "三七"},
        {id: "38", value: "妈妈"},
        {id: "39", value: "上酒"},
        {id: "40", value: "死灵/司令"},
        {id: "41", value: "司仪"},
        {id: "42", value: "石儿/孙悟空"},
        {id: "43", value: "四散"},
        {id: "44", value: "狮子"},
        {id: "45", value: "思吾"},
        {id: "46", value: "思路"},
        {id: "47", value: "死骑"},
        {id: "48", value: "死吧"},
        {id: "49", value: "死鹫"},
        {id: "50", value: "武林/斑白"},
        {id: "51", value: "巫医/巫妖"},
        {id: "52", value: "武二/武松"},
        {id: "53", value: "午餐"},
        {id: "54", value: "青年"},
        {id: "55", value: "火车呜呜"},
        {id: "56", value: "物流"},
        {id: "57", value: "武器"},
        {id: "58", value: "五霸"},
        {id: "59", value: "无酒"},
        {id: "60", value: "六小龄童"},
        {id: "61", value: "儿童"},
        {id: "62", value: "鹿儿"},
        {id: "63", value: "硫酸"},
        {id: "64", value: "柳丝"},
        {id: "65", value: "礼物"},
        {id: "66", value: "溜溜球"},
        {id: "67", value: "油漆"},
        {id: "68", value: "喇叭"},
        {id: "69", value: "太极"},
        {id: "70", value: "器灵/麒麟"},
        {id: "71", value: "奇异果"},
        {id: "72", value: "弃儿"},
        {id: "73", value: "青山"},
        {id: "74", value: "启示/骑士"},
        {id: "75", value: "欺辱"},
        {id: "76", value: "气流"},
        {id: "77", value: "弃棋"},
        {id: "78", value: "奇葩"},
        {id: "79", value: "气球"},
        {id: "80", value: "巴陵"},
        {id: "81", value: "建军"},
        {id: "82", value: "靶儿"},
        {id: "83", value: "拔山"},
        {id: "84", value: "巴士"},
        {id: "85", value: "白虎"},
        {id: "86", value: "八路"},
        {id: "87", value: "白起"},
        {id: "88", value: "爸爸"},
        {id: "89", value: "把酒言欢/罢酒/戒酒"},
        {id: "90", value: "精灵"},
        {id: "91", value: "救生衣"},
        {id: "92", value: "球儿"},
        {id: "93", value: "救伞/降落伞"},
        {id: "94", value: "救市"},
        {id: "95", value: "FM/九五至尊"},
        {id: "96", value: "酒楼"},
        {id: "97", value: "酒器/酒气/月光杯"},
        {id: "98", value: "酒吧"},
        {id: "99", value: "舅舅"},
        {id: "100", value: "圆满"}]
    property var numberData;

    Component.onCompleted: {
        numberData = baseData;
        button4.checked = true
        showNext()
    }

    Rectangle {
        width: parent.width
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        color: "green"

        Rectangle {
            id: button1
            width: (parent.width - Utl.dp(50))/4
            height: Utl.dp(40)
            anchors.left: parent.left
            anchors.leftMargin: Utl.dp(10)
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            border.width: checked ? Utl.dp(1) : 0

            property bool checked: false

            Text {
                anchors.centerIn: parent
                font.pointSize: 18
                color: button1.checked ? "black" : "gray"
                text: "查询"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    checkButtons(button1)
                }
            }
        }
        Rectangle {
            id: button2
            width: (parent.width - Utl.dp(50))/4
            height: Utl.dp(40)
            anchors.left: button1.right
            anchors.leftMargin: Utl.dp(10)
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            border.width: checked ? Utl.dp(1) : 0

            property bool checked: false

            Text {
                anchors.centerIn: parent
                font.pointSize: 18
                color: button2.checked ? "black" : "gray"
                text: "十位"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    checkButtons(button2)
                }
            }
        }
        Rectangle {
            id: button3
            width: (parent.width - Utl.dp(50))/4
            height: Utl.dp(40)
            anchors.left: button2.right
            anchors.leftMargin: Utl.dp(10)
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            border.width: checked ? Utl.dp(1) : 0

            property bool checked: false

            Text {
                anchors.centerIn: parent
                font.pointSize: 18
                color: button3.checked ? "black" : "gray"
                text: "个位"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    checkButtons(button3)
                }
            }
        }
        Rectangle {
            id: button4
            width: (parent.width - Utl.dp(50))/4
            height: Utl.dp(40)
            anchors.left: button3.right
            anchors.leftMargin: Utl.dp(10)
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            border.width: checked ? Utl.dp(1) : 0

            property bool checked: false

            Text {
                anchors.centerIn: parent
                font.pointSize: 18
                color: button4.checked ? "black" : "gray"
                text: "随机"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    checkButtons(button4)
                }
            }
        }

        Rectangle {     //输入+查询
            id: rect_search
            visible: button4.checked ? false : true
            height: Utl.dp(40)
            width: childrenRect.width
            anchors.top: button1.bottom
            anchors.topMargin: Utl.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            TextField {
                id: input
                width: Utl.dp(60)
                height: parent.height
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                maximumLength: button1.checked ? 3 : 1
                validator: RegExpValidator{regExp: /^[0-9]*$/}
            }
            Rectangle {
                anchors.left: input.right
                anchors.leftMargin: Utl.dp(10)
                height: parent.height
                width: height
                color: "gray"
                Text {
                    id: query_txt
                    anchors.centerIn: parent
                    font.pointSize: 18
                    text: "OK"
                }
                MouseArea {
                    anchors.fill: parent
                    onPressed: query_txt.scale = 0.8
                    onReleased: query_txt.scale = 1.0
                    onClicked: {
                        if(Qt.inputMethod.visible)
                            Qt.inputMethod.hide()
                        if(button1.checked) {   //查询
                            if(parseInt(input.text) > 100)
                                input.text = "100"
                            if(input.text == "") {
                                number.text = baseData[0].id
                                text.text = baseData[0].value
                            } else {
                                for(var i = parseInt(input.text); i < baseData.length; i ++) {
                                    if(input.text == baseData[i].id) {
                                        number.text = baseData[i].id
                                        text.text = baseData[i].value
                                        break;
                                    }
                                }
                            }
                        } else {
                            showIndex = 0
                            tenIndex = 0
                            onesIndex = 0
                            showNext()
                        }
                    }
                }
            }
        }

        Rectangle { //类型
            width: Utl.dp(60)
            height: Utl.dp(45)
            anchors.top: rect_search.bottom
            anchors.topMargin: Utl.dp(20)
            anchors.left: parent.left
            anchors.leftMargin: Utl.dp(20)

            Text {
                id: type_text
                anchors.centerIn: parent
                font.pointSize: 18
                text: "全部"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(showType == 0) {
                        showType = 1
                        type_text.text = qsTr("数字")
                        number.visible = true
                        text.visible = false
                    } else if(showType == 1) {
                        showType = 2
                        type_text.text = qsTr("对象")
                        number.visible = false
                        text.visible = true
                    } else {
                        showType = 0
                        type_text.text = qsTr("全部")
                        number.visible = true
                        text.visible = true
                    }
                }
            }
        }


        Text {
            id: number
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: Utl.dp(10)
            font.pointSize: 18
            color: "blue"
            text: "1"
        }

        Text {
            id: text
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: Utl.dp(10)
            font.pointSize: 18
            color: "purple"
            text: "金箍棒"
        }

        Rectangle {
            visible: !button1.checked
            width: parent.width/2
            height: Utl.dp(40)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Utl.dp(80)
            anchors.horizontalCenter: parent.horizontalCenter
            color: "yellow"
            Text {
                anchors.centerIn: parent
                font.pointSize: 18
                text: "Next"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    showNext()
                }
            }
        }
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }

    //选择按钮
    function checkButtons(button) {
        input.text = ""
        button1.checked = false
        button2.checked = false
        button3.checked = false
        button4.checked = false
        button.checked = true
        showIndex = 0
        tenIndex = 0
        onesIndex = 0
    }

    //显示下一个
    function showNext() {
        var numberInput = parseInt(input.text)
        if(button2.checked) {   //十位
            console.log("十位，tenIndex", tenIndex)
            if(input.text == "") {  //0~9
                number.text = baseData[tenIndex].id
                text.text = baseData[tenIndex].value
            } else {
                console.log("what..", tenIndex + (numberInput + 1) * 10)
                number.text = baseData[tenIndex + (numberInput + 1) * 10].id
                text.text = baseData[tenIndex + (numberInput + 1) * 10].value
            }
            if(tenIndex < 9)
                tenIndex++
            else
                tenIndex = 0
        } else if(button3.checked) {   //个位
            console.log("个位")
            if(input.text == "") {  //0
                number.text = baseData[onesIndex * 10].id
                text.text = baseData[onesIndex * 10].value
            } else {
                number.text = baseData[onesIndex * 10 + numberInput].id
                text.text = baseData[onesIndex * 10 + numberInput].value
            }
            if(onesIndex < 10)
                onesIndex++
            else if((input.text == "" || input.text == "0") && onesIndex < 11)
                onesIndex++
            else
                onesIndex = 0
        } else if(button4.checked) {   //随机
            console.log("随机")
            var index = Math.floor(Math.random() * (numberData.length - showIndex))
            number.text = numberData[index].id
            text.text = numberData[index].value
            var item = numberData[index]
            numberData[index] = numberData[numberData.length - showIndex - 1]
            numberData[numberData.length - showIndex] = item
            if(showIndex < numberData.length)
                showIndex++
            else
                showIndex = 0
        }
    }
}
