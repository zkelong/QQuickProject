import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "TreeView"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
    //Model
    ListModel {
        id: objModel
        Component.onCompleted: {
            objModel.append({"name":"A1","level":0,"subNode":[]})
            objModel.append({"name":"A2","level":0,"subNode":[]})
            objModel.append({"name":"A3","level":0,"subNode":[]})
            objModel.get(1).subNode.append({"name":"B1","level":1,"subNode":[]})
            objModel.get(1).subNode.append({"name":"B2","level":1,"subNode":[]})
            objModel.get(1).subNode.get(0).subNode.append({"name":"C3","level":2,"subNode":[]})
        }
    }

    //Delegate
    Component {
        id: objRecursiveDelegate
        Column {
            Row {
                //indent
                Item {
                    height: 1
                    width: model.level * 20
                }

                Text {
                    text:model.name
                }
            }

            Repeater {
                model: subNode
                delegate: objRecursiveDelegate
            }
        }
    }

    //View
    ListView{
        id: list1
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.verticalCenter
        clip: true
        model:objModel
        delegate: objRecursiveDelegate
    }


    //Delegate
    Component {
        id: objRecursiveDelegate1
        Column {
            id: objRecursiveColumn
            MouseArea {
                width: objRow.implicitWidth
                height: objRow.implicitHeight
                onDoubleClicked: {
                    for(var i = 1; i < parent.children.length - 1; ++i) {
                        parent.children[i].visible = !parent.children[i].visible
                    }
                }
                Row {
                    id: objRow
                    Item {
                        height: 1
                        width: model.level * 20
                    }
                    Text {
                        text: (objRecursiveColumn.children.length > 2 ?
                                   objRecursiveColumn.children[1].visible ?
                                       qsTr("-  ") : qsTr("+ ") : qsTr("   ")) + model.name
                        color: objRecursiveColumn.children.length > 2 ? "blue" : "green"
                    }
                }
            }
            Repeater {
                model: subNode
                delegate: objRecursiveDelegate1
            }
        }
    }

    //View
    ListView {
        width: parent.width
        anchors.top: list1.bottom
        anchors.bottom: parent.bottom
        model: objModel
        delegate: objRecursiveDelegate1
    }
}

