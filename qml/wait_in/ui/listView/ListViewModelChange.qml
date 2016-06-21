import QtQuick 2.0
import "../../controls"

View {
    id: root

    ListView {
        id: listView
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true //裁剪，保证不显示在listview以外的地方

        model: listModel //数据源
        focus: true
        delegate: delegate2 //点击有数据源的变动（添加移除）
        remove: Transition {  //移除动画
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: 1000 } //透明度动画
                NumberAnimation { properties: "x,y"; to: 100; duration: 1000 }
            }
        }
        removeDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 3000 }
        }
        add: Transition {
            NumberAnimation { properties: "x"; from: -listView.width; duration: 1000 }
        }
    }

    //数据源
    ListModel {
        id:listModel
        ListElement {
            name: "111Bill Smith"
            number: "555 3264"
        }
        ListElement {
            name: "222John Brown"
            number: "555 8426"
        }
        ListElement {
            name: "333Sam Wise"
            number: "555 0473"
        }
        ListElement {
            name: "444Sam Wise"
            number: "555 0473"
        }
        ListElement {
            name: "555Sam Wise"
            number: "111 0473"
        }
        ListElement {
            name: "666Sam Wise"
            number: "222 0473"
        }
        ListElement {
            name: "777Sam Wise"
            number: "333 0473"
        }
        ListElement {
            name: "888Sam Wise"
            number: "444 0473"
        }
        ListElement {
            name: "999Sam Wise"
            number: "555 0473"
        }
        ListElement {
            name: "000Sam Wise"
            number: "666 0473"
        }
    }

    //数据源
    ListModel {
        id:listModel0
        ListElement {
            name: "xxxBill Smith"
            number: "555 3264"
        }
        ListElement {
            name: "yyyJohn Brown"
            number: "555 8426"
        }
        ListElement {
            name: "zzzSam Wise"
            number: "555 0473"
        }
    }

    //样式
    Component {
        id: delegate2

        Rectangle {
            id: wrapper
            width: parent.width
            height: 20
            color: "white"
            Text {
                id: contactInfo
                anchors.verticalCenter: parent.verticalCenter
                text: name + ": " + number
                color: wrapper.ListView.isCurrentItem ? "red" : "black"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {  //单击
                    listView.currentIndex = index
                    if(listView.model.count < 15) {
                        //数据源追加信息
                        listView.model.append({name:"append", number: "追加+++++++++++++"})
                        //数据源插入信息
                        listView.model.insert(index, {name: "insert", number: "添加+++++++++"})
                    } else {
                        //数据源移除信息
                        listView.model.remove(index + 1, listView.model.count - index - 1)  //移除位置，移除个数

                    }
                }
                onDoubleClicked: { //双击
                    if(index == 5) {
                        listView.model.set(1,{name: "set", number: "like replace"})  //set
                    }

                    //改变数据源
                    if(listView.model == listModel0)
                        listView.model = listModel
                    else {
                        listView.model = listModel0
                    }

                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "blue"
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

}

