import QtQuick 2.0
import "../controls"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl

View {
    id: root
    hidenTabbarWhenPush: true

    property int cellHeight: Utl.dp(50)

    NavigationBar {
        id: navbar
        title: "UIMAIN"
        onButtonClicked: {
            root.navigationView.pop()
        }
        Button {
            visible: Qt.platform.os !== "windows"
            height: parent.height
            width: height * 1.4
            anchors.right: parent.right
            label.text: qsTr("修改密码")
            label.color: "#979ca2"
            onClicked: {
                numberlock.show(1)
            }
        }
    }

    ListView {
        id: _listView
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        model: _model
        delegate: _delegate
        clip: true
        spacing: Utl.dp(5)
    }

    Component {
        id: _delegate
        Rectangle {
            width: _listView.width
            height: cellHeight

            Text {
                anchors.left: parent.left
                anchors.leftMargin: Utl.dp(10)
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: FontUtl.FontSizeSmallC
                text: strName
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    toNext(lid)
                }
            }
            Line {
                anchors.top: parent.top
            }
            Line {
                anchors.bottom: parent.bottom
            }
        }
    }

    Component {
        id: nm
        Memory{}
    }
    Component {
        id: bf
        Belief{}
    }

    ListModel {
        id: _model
        ListElement {
            lid: 1
            strName: "NumberMemory"
        }
        ListElement {
            lid: 2
            strName: "Belief"
        }
    }

    function toNext(id) {
        switch(id) {
        case 1:
            root.navigationView.push(nm)
            break;
        case 2:
            root.navigationView.push(bf)
            break;
        //case 3:
        //    root.navigationView.push(comp)
        //    break;
        //case 4:
        //    root.navigationView.push(tm)
        //    break;
        //case 5:
        //    root.navigationView.push(pr)
        //    break;
        //case 6:
        //    root.navigationView.push(lv)
        //    break;
        //case 99:
        //    root.navigationView.push(mc)
        //    break;
        }
    }

    NumberLock { //锁定框
        id: numberlock
        visible: Qt.platform.os !== "windows"
        width: parent.width
        height: root.height
        onCanceled: {
            if(numberlock.type == 0) {
                root.navigationView.pop()
            } else {
                numberlock.hide()
            }
        }
    }
}
