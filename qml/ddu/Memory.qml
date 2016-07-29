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

    property int randomIndex: 0;  //随机产生到第几个数
    property int orderIndex: 0  //顺序显示
    property int searchBeginIndex: 0 //搜索开始坐标
    property int searchIndex: 0 //查询显示下标
    property int tenIndex: 0    //十位
    property int onesIndex: 0   //个位
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
    property var numberData: [];

    Component.onCompleted: {
        //numberData = baseData;  //这样操作，当numberData改变的时候，baseData也变了
        for(var i = 0; i < baseData.length; i++) {
            var item = baseData[i]
            numberData.push(item)
        }

        button.state = "buttonUseless"
    }

    NavigationBar {
        id: navbar
        title: "NumberMemory"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Item {  //搜索栏
        id: item_search
        width: childrenRect.width
        height: Utl.dp(80)
        anchors.top: navbar.bottom
        anchors.topMargin: Utl.dp(40)
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: label_search
            anchors.left: parent.left
            anchors.leftMargin: Utl.dp(10)
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: FontUtl.FontSizeMidC
            text: qsTr("搜索")
            color: "#4b4c4d"
        }

        TextField { //输入框
            id: input_field
            width: Utl.dp(60)
            height: Utl.dp(40)
            anchors.left: label_search.right
            anchors.leftMargin: Utl.dp(10)
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            maximumLength: 1
            validator: RegExpValidator{regExp: /^[0-9]*$/}
            style: TextFieldStyle {
                textColor: "#4a4a4a"
                background: Rectangle {
                    border.color: "#2b2b2b"
                    implicitWidth: input_field.width
                    implicitHeight: input_field.height
                }
            }
            onTextChanged: {
                if(button.state == "buttonUseless") {
                    button.state = ""
                    button.selectTen = true
                    changeType.state = "typeUseless"
                }
                if(button.selectTen) {   //十位
                    if(input_field.text == "") {
                        searchIndex = 0
                    } else {
                        searchIndex = 10* (parseInt(input_field.text) + 1)
                    }
                } else {    //个位
                    if(input_field.text == "") {
                        Tools.showTip("个位不能为空")
                        button.state = ""
                        button.selectTen = true
                        return
                    }
                    searchIndex = parseInt(input_field.text)
                }
                searchBeginIndex = searchIndex
                console.log("search_index....", searchIndex)
            }
        }

        Rectangle {     //按钮
            id: button
            width: Utl.dp(35); height: width
            anchors.left: input_field.right
            anchors.leftMargin: Utl.dp(10)
            anchors.verticalCenter: input_field.verticalCenter
            radius: width/2
            color: "#de0500"

            property bool selectTen: true

            states: [
                State {
                    name: "bit";
                    PropertyChanges {target: button; color: "#804d85" }
                    PropertyChanges {target: buttnText; text: qsTr("个")}
                }
                ,State {
                    name: "buttonUseless"
                    PropertyChanges {target: button; color: "#989898"}
                    PropertyChanges {target: buttnText; text: qsTr("NL")}
                }
                ,State {
                    name: "buttonBegin"
                    PropertyChanges {target: buttnText; text: "OK"}
                    PropertyChanges {target: btton; color: "#7bcfe0"}
                }
            ]
            Text {
                id: buttnText
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeMidA
                color: "white"
                text: qsTr("十")
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    button.selectTen = !button.selectTen
                    if(button.selectTen)
                        button.state = ""
                    else
                        button.state = "bit"
                    changeType.state = "typeUseless"
                    inputDone()
                    //处理显示
                    if(input_field === "") {
                        showNext()
                    } else {
                        var number = parseInt(input_field)
                    }
                    if(button.selectTen) {   //十位
                        if(input_field.text == "") {
                            searchIndex = 0
                        } else {
                            searchIndex = 10* (parseInt(input_field.text) + 1)
                        }
                    } else {    //个位
                        if(input_field.text == "") {
                            Tools.showTip("个位不能为空")
                            button.selectTen = true
                            button.state = ""
                            return
                        }
                        searchIndex = parseInt(input_field.text)
                    }
                    searchBeginIndex = searchIndex
                    showNext()
                }
            }
        }
    }

    Rectangle {     //变化方式
        id: changeType
        width: Utl.dp(50)
        height: Utl.dp(40)
        anchors.top: item_search.bottom; anchors.topMargin: Utl.dp(10)
        anchors.right: parent.right; anchors.rightMargin: Utl.dp(10)
        color: "#348500"

        property bool selectOrder: true

        states: [
            State {
                name: "random";
                PropertyChanges {target: changeType; color: "#6f9227" }
                PropertyChanges {target: changeText; text: qsTr("随机")}
            }
            ,State {
                name: "typeUseless"
                PropertyChanges {target: changeType; color: "#989898"}
                PropertyChanges {target: changeText; text: qsTr("NULL")}
            }

        ]
        Text {
            id: changeText
            anchors.centerIn: parent
            font.pointSize: FontUtl.FontSizeMidA
            color: "white"
            text: qsTr("顺序")
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                changeType.selectOrder = !changeType.selectOrder
                if(changeType.selectOrder) {
                    changeType.state = ""
                } else {
                    orderIndex = 0
                    changeType.state = "random"
                }
                input_field.text = ""
                button.state = "buttonUseless"
                inputDone()
            }
        }
    }

    Rectangle {     //显示方式
        id: showType
        width: Utl.dp(50)
        height: Utl.dp(40)
        anchors.top: changeType.top;
        anchors.left: parent.left; anchors.leftMargin: Utl.dp(10)
        color: "#069076"

        property int showTypeStatus: 1    //1--全部；2--数字；3--对象

        states: [
            State {
                name: "figure";
                PropertyChanges {target: showType; color: "#5cb2e3" }
                PropertyChanges {target: showText; text: qsTr("数字")}
            }
            ,State {
                name: "object";
                PropertyChanges {target: showType; color: "#b35f3b" }
                PropertyChanges {target: showText; text: qsTr("对象")}
            }
        ]
        Text {
            id: showText
            anchors.centerIn: parent
            font.pointSize: FontUtl.FontSizeMidA
            color: "white"
            text: qsTr("全部")
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                inputDone()
                if(showType.showTypeStatus === 3) {
                    showType.showTypeStatus = 1
                } else {
                    showType.showTypeStatus++
                }
                switch(showType.showTypeStatus) {
                case 1:
                    showType.state = ""
                    number.visible = true
                    object.visible = true
                    break;
                case 2:
                    showType.state = "figure"
                    number.visible = true
                    object.visible = false
                    break;
                case 3:
                    showType.state = "object"
                    number.visible = false
                    object.visible = true
                    break;
                }
            }
        }
    }

    Item {
        width: parent.width
        anchors.top: changeType.bottom
        anchors.bottom: parent.bottom

        Item {
            id: item_show
            width: Utl.dp(150)
            height: Utl.dp(150)
            anchors.centerIn: parent

            Text {
                id: number
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: Utl.dp(10)
                font.pointSize: FontUtl.FontSizeMidC
                color: "blue"
                text: "1"
            }

            Text {
                id: object
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.verticalCenter
                anchors.topMargin: Utl.dp(10)
                font.pointSize: FontUtl.FontSizeMidC
                color: "purple"
                text: "金箍棒"
            }
        }

        Button {    //左箭头
            visible: changeType.state == "" || button.state != "buttonUseless"
            width: Utl.dp(35)
            height: Utl.dp(35)
            icon.width: Utl.dp(30)
            icon.height: Utl.dp(30)
            icon.normalSource: "qrc:/res/arrow_left5.png"
            anchors.right: item_show.left
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                inputDone()
                showBefore()
            }
        }


        Button {    //右箭头
            width: Utl.dp(35)
            height: Utl.dp(35)
            icon.width: Utl.dp(30)
            icon.height: Utl.dp(30)
            icon.normalSource: "qrc:/res/arrow_left5.png"
            anchors.left: item_show.right
            anchors.verticalCenter: parent.verticalCenter
            rotation: 180
            onClicked: {
                inputDone()
                showNext()
            }
        }
    }

    //显示上一个
    function showBefore() {
        if(orderIndex == 0) {   //从当前显示的下个数开始
            getShowIndex()
        }
        if(button.state !== "buttonUseless") {  //按照十位/个位显示
            if(button.selectTen) {   //十位
                number.text = baseData[searchIndex].id
                object.text = baseData[searchIndex].value
                searchIndex--
                if(searchIndex == searchBeginIndex)
                    searchIndex = searchBeginIndex + 9
            } else {    //个位
                number.text = baseData[searchIndex].id
                object.text = baseData[searchIndex].value
                searchIndex -= 10
                if(searchIndex == searchBeginIndex) {
                    searchIndex = searchBeginIndex + 100
                }
            }
        } else {
            if(orderIndex == 0)
                orderIndex = baseData.length-1
            else
                orderIndex--
            number.text = baseData[orderIndex].id
            object.text = baseData[orderIndex].value
        }
    }

    //显示下一个
    function showNext() {
        console.log("show_nex...", searchIndex)
        if(button.state !== "buttonUseless") {  //按照十位/个位显示
            if(button.selectTen) {   //十位
                console.log("shownext...十位")
                number.text = baseData[searchIndex].id
                object.text = baseData[searchIndex].value
                searchIndex++
                if(searchIndex - searchBeginIndex > 9)
                    searchIndex = searchBeginIndex
            } else {    //个位
                console.log("shownext...个位")
                number.text = baseData[searchIndex].id
                object.text = baseData[searchIndex].value
                searchIndex += 10
                if(searchIndex >= baseData.length)
                    searchIndex = searchBeginIndex
            }
        } else {  //全部显示--随机/顺序
            if(!changeType.selectOrder) { //随机
                console.log("shownext...随机")
                var index = Math.floor(Math.random() * (numberData.length - randomIndex))
                if(index == numberData.length - randomIndex && index != 0)    //超出数组--小概率
                    index = numberData.length - randomIndex - 1
                number.text = numberData[index].id
                object.text = numberData[index].value
                //将随机过的数往后放，免得有的总是出现或不出现
                var item = numberData[index]
                var exIndex = numberData.length - randomIndex > 0 ? numberData.length - randomIndex - 1 : 0 //最后一个0位置上的
                numberData[index] = numberData[exIndex]
                numberData[numberData.length - randomIndex - 1] = item
                if(randomIndex < numberData.length)
                    randomIndex++
                else
                    randomIndex = 0
            } else {    //顺序
                console.log("shownext...顺序")
                if(orderIndex == 0) {
                    getShowIndex()
                }
                if(orderIndex === baseData.length - 1)
                    orderIndex = 0
                else
                    orderIndex++
                number.text = baseData[orderIndex].id
                object.text = baseData[orderIndex].value
            }
        }
        console.log("show_nex..xxxxeee.", searchIndex)
    }

    function getShowIndex() {   //获取当前显示的下标
        if(number.text === baseData[baseData.length-1]) {
            orderIndex = 0
        } else {
            var tempIndex = parseInt(number.text)
            for(; tempIndex < baseData.length; tempIndex++) {
                if(number.text === baseData[tempIndex].id) {
                    orderIndex = tempIndex
                    break
                }
            }
        }
    }

    function inputDone() {
        Qt.inputMethod.hide()
        input_field.focus = false
    }
}
