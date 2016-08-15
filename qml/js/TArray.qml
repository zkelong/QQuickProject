import QtQuick 2.0
import "../controls"
import "../toolsbox/tools.js" as Tools
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    //property var nArray
    property var array1: []
    property var array2: []
    property var array3
    property var array4;

    NavigationBar {
        id: navbar
        title: "Array"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: childrenRect.height

        Column {
            id: _col
            width: parent.width
            anchors.top: parent.top
            height: childrenRect.height
            spacing: Utl.dp(15)

            Item {  //新建数组
                id: item0
                width: parent.width
                height: childrenRect.height
                property var aa;
                Text {
                    id: txt00
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                    text: "var aa = new Array; new Array(1,2,3); //可以创建数组。\ndelete aa; //无效，delete变量无效。\nnew出来的对象没有不用delete,系统自动回收,也可以赋值aa = nll"
                }
                Text {
                    id: txt01
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: txt00.bottom
                    anchors.topMargin: Utl.dp(5)
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                }
                MouseArea {
                    anchors.fill: txt00
                    onClicked: {
                        if(!item0.aa) {
                            item0.aa = new Array(1, 2, 3);
                            txt01.text = JSON.stringify(item0.aa)
                        }
                    }
                }
            }

            Item {
                id: item1
                width: parent.width
                height: childrenRect.height
                property bool show: false
                Text {
                    id: txt10
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                    text: "JS中的delete: \nJs中的回收，JavaScript引擎释放掉某个对象，需要确保整个程序里已经没有对那个对象的活引用。\n可以将想释放的对象赋值为null。\ndelete删不了变量，删不掉原型链(??)中的变量，可以删除对象属性。"
                }
                Text {
                    id: txt11
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: txt10.bottom
                    anchors.topMargin: Utl.dp(5)
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                }
                MouseArea {
                    anchors.fill: txt10
                    onClicked: {
                        if(!item1.show) {
                            item1.show = true
                            var aa = {pr1: {a: "ss"}, pr2: 1, pr3: 2}
                            txt11.text = JSON.stringify(aa)
                            txt11.text += "\ndelete aa.pr2; delete aa.pr1"
                            delete aa.pr2; delete aa.pr1;
                            txt11.text += "\n" + JSON.stringify(aa)
                        }
                    }
                }
            }

            Item {
                id: item2
                width: parent.width
                height: childrenRect.height
                Text {
                    id: txt20
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                    text: "http://www.w3school.com.cn/jsref/jsref_obj_array.asp"
                }
                Text {
                    id: txt21
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: txt20.bottom
                    anchors.topMargin: Utl.dp(5)
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                }
                MouseArea {
                    anchors.fill: txt20
                    onClicked: {
                        if(!item1.show) {

                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: childrenRect.height
                Text {
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                    text: ""
                }
            }

            Item {
                width: parent.width
                height: childrenRect.height
                Text {
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                    text: ""
                }
            }

            Item {
                width: parent.width
                height: childrenRect.height
                Text {
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                    text: ""
                }
            }

            Item {
                width: parent.width
                height: childrenRect.height
                Text {
                    width: parent.width - Utl.dp(40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    wrapMode: Text.WrapAnywhere
                    color: "#595959"
                    text: ""
                }
            }
        }
    }







//    property var sourceD: []
//    property var leftD1: []
//    property int showN: 7


//    Component.onCompleted: {
//        for(var i = 0; i < 16; i++) {
//            var str = "测" + i
//            sourceD.push(str)
//        }
//        leftD1 = [].concat(sourceD)
//        source_t.text = JSON.stringify(leftD1)
//    }

//    Item {
//        width: parent.width
//        anchors.top: navbar.bottom
//        anchors.bottom: parent.bottom

//        Button {
//            id: btn
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: Utl.dp(15)
//            anchors.horizontalCenter: parent.horizontalCenter
//            width: Utl.dp(80)
//            height: Utl.dp(35)
//            border.width: Utl.dp(2)
//            border.color: Color.Blue
//            label.text: qsTr("换一批")
//            onClicked: {
//                showNext()
//            }
//        }

//        Text {
//            id: source_t
//            anchors.top: parent.top
//            anchors.topMargin: Utl.dp(10)
//            width: parent.width - Utl.dp(20)
//            anchors.horizontalCenter: parent.horizontalCenter
//            font.pointSize: FontUtl.FontSizeSmallF
//            wrapMode: Text.WrapAnywhere
//        }

//        Text {*
//            id: show_t
//            anchors.top: source_t.bottom
//            anchors.topMargin: Utl.dp(10)
//            width: parent.width - Utl.dp(20)
//            anchors.horizontalCenter: parent.horizontalCenter
//            font.pointSize: FontUtl.FontSizeSmallF
//            wrapMode: Text.WrapAnywhere
//            color: "#454545"
//        }
//    }


//    function showNext() {
//        if(leftD1.length === 0) {
//            leftD1 = [].concat(sourceD)
//        }
//        var sArray = []
//        var selectNum = Math.min(showN, leftD1.length)
//        for(var i = 0; i < selectNum; i++) {
//            var index = Math.floor(Math.random() * leftD1.length)
//            sArray.push(leftD1[index])
//            leftD1[index] = leftD1[leftD1.length-1]
//            leftD1.pop()
//        }
//        console.log("left1...", JSON.stringify(sArray), "\n", JSON.stringify(leftD1), "\nlength...", leftD1.length)
//    }
}
