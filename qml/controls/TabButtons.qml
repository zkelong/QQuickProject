import QtQuick 2.0
import "../controls/color.js" as Color
import "../controls/font.js" as FontUtl
import "../config.js" as Config

/*
* 按钮选择组
*/

Rectangle {
    id: root
    width: parent.width; height: Utl.dp(40)
    color: "white"

    signal clicked(var itemId) //点击事件
    property var items: ({})    //[{titleTxt: "按钮"},{titleTxt: "选择"}]

    property int selectItem: 0

    Component.onCompleted: {
        if(items && items.length > 0) {
            for(var i = 0; i < items.length; i++) {
                listmodel.append(items[i])
            }
        }
        listview.currentIndex = selectItem
    }

    ListView {
        id:listview
        anchors.fill: parent
        orientation: ListView.Horizontal
        interactive: false
        model: listmodel
        delegate: msnDelegate
    }

    ListModel {
        id: listmodel
    }

    Line {
        anchors.bottom: parent.bottom
    }

    Line {
        id: selectLine
        anchors.bottom: parent.bottom
        height: Utl.dp(2)
        color: "#70c7b5"
        //x: (selectLine.width + Utl.dp(15)) * selectItem + Utl.dp(15) * (selectItem + 1)
        width: listmodel.count > 0 ? root.width / listmodel.count : root.width
    }

    Component {
        id: msnDelegate
        Rectangle {
            anchors.top: parent.top
            height: root.height
            width: listmodel.count > 0 ? root.width / listmodel.count : root.width
            Text {
                id: _text
                anchors.centerIn: parent
                font.pointSize: 18
                text: titleTxt
                color: listview.currentIndex == index ? "#70c7b5" : "#696969"
            }
            Line {
                width: Utl.dp(1)
                height: parent.height
                anchors.right: parent.right
                visible: index == listModel.count - 1 ? false : true
            }

            MouseArea {
               anchors.fill: parent
               onClicked: {
                   listview.currentIndex = index
                   animation.from = selectLine.x
                   animation.to = (selectLine.width) * index
                   animation.start()
               }
            }
        }
    }

    PropertyAnimation {
        id: animation
        target: selectLine
        duration: 200
        properties: "x"
        onStopped: {
            selectItem = listview.currentIndex
            root.clicked(listview.currentIndex)
        }
    }
}

