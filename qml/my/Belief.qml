import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"

View {
    id: root

    property var baseData: [
        {method: "每次，当你要刷牙的时候，在心里重复", value: "1.今天，我要开始新的生活!"}
        ,{method: "拿出牙刷，像个棒子吗？对!", value: "2.我是最棒的，一定会成功!"}
        ,{method: "拿出牙刷，前端是方的吗？", value: "3.成功一定有方法!"}
        ,{method: "挤出牙膏一点点", value: "4.我要每天进步一点点!"}
        ,{method: "张开口，准备将牙刷入进口里", value: "5.我要微笑面对全世界!"}
        ,{method: "牙膏“挨”着牙齿了，一排牙膏犹如一群人", value: "6.人人都是我的贵人!"}
        ,{method: "刷牙的时候，要横着刷牙，口张到最大的时候", value: "7.我是最伟大的推销员!"}
        ,{method: "刷牙完毕，看着镜子里的自己，坚定信心", value: "8.我爱我的事业!"}
        ,{method: "离开梳妆台", value: "9.我要立即行动!"}
        ,{method: "开始出门", value: "10.坚持到底，绝不放弃，直到成功!"}]

    property int resetCount: 0
    property string passWord: ""
    property string key: "218"

    property int currentIndex: 0

    Component.onCompleted: {
        getListModel()
    }

    Rectangle {     //9宫格
        width: parent.width
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom

        MouseArea {
            anchors.fill: parent
            property int mouseStartX: 0
            property int mouseStartY: 0
            onClicked: {
                currentIndex++
                if(currentIndex == baseData.length)
                    currentIndex = 0
                txt.text =  baseData[currentIndex].value
            }

            //onPressed: {
            //    mouseStartX = mouseX
            //    mouseStartY = mouseY
            //}

            Text {
                id: txt
                width: parent.width - Utl.dp(40)
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere
                font.pointSize: 20
                color: "darkgreen"
                text: baseData[0].value
            }

            //onReleased: {
            //    var moveX = mouseX - mouseStartX
            //    var moveY = mouseY - mouseStartY
            //    if(moveX > Utl.dp(15) && Math.abs(moveY) <= Math.abs(moveX)) {  //右划
            //        console.log("右")
            //    } else if(moveX < -Utl.dp(15) && Math.abs(moveY) <= Math.abs(moveX)) {  //左划
            //        console.log("左")
            //    } else if(moveY > Utl.dp(15) && Math.abs(moveX) <= Math.abs(moveY)) {  //下划
            //        console.log("下")
            //    } else if(moveY < -Utl.dp(15) && Math.abs(moveX) <= Math.abs(moveY)) {  //上划
            //        console.log("上")
            //    } else {    //点击事件
            //        console.log("点")
            //    }
            //}
        }
    }

    Rectangle {     //9宫格
        id: rect_grid
        width: parent.width
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom

        GridView {
            id: grid
            width: Utl.dp(120)
            height: Utl.dp(160)
            anchors.centerIn: parent
            cellWidth:  width / 3
            cellHeight: cellWidth
            model: listModel
            delegate: listDelegate
            interactive: false
        }
    }
    ListModel {
        id: listModel
    }
    Component {
        id: listDelegate
        Item {
            width: grid.cellWidth
            height: grid.cellHeight
            visible: value == -1 ? false : true
            Rectangle {
                id: rec
                width: parent.width - Utl.dp(4)
                height: parent.height - Utl.dp(4)
                anchors.centerIn: parent
                color: Qt.rgba(r, g, b, 1)
                border.width: Utl.dp(1)
                border.color: txt.color

                property double r: Math.random()
                property double g: Math.random()
                property double b: Math.random()

                Text {
                    id: txt
                    anchors.centerIn: parent
                    font.pointSize: 18
                    color: Qt.rgba(1-rec.r, 1-rec.g, 1-rec.b, 1)
                    text: value
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("rec.color",rec.color)
                    if(rec.color == "#000000") {
                        rec.color = Qt.rgba(rec.r, rec.g, rec.b, 1)
                        txt.color = Qt.rgba(1-rec.r, 1-rec.g, 1-rec.b, 1)
                        passWord = passWord.replace(value, "")
                    } else {
                        rec.color = "#000"
                        txt.color = "#fff"
                        passWord += value
                    }
                    if(value == 0) {
                        root.resetCount++
                        if(root.resetCount == 3) {
                            listModel.clear()
                            getListModel()
                            passWord = ""
                            root.resetCount = 0
                            return
                        }
                    } else {
                        root.resetCount = 0
                    }

                    checkPass()
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

    function getListModel() {
        for(var i = 1; i < 13; i++) {
            var item;
            if(i < 10)
                item = {value: i}
            else if(i == 11)
                item = {value: 0}
            else
                item = {value: -1}
            listModel.append(item)
        }
    }

    function checkPass() {
        console.log(passWord)
        if(passWord == key)
            rect_grid.visible = false
    }
}
