import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl

View {
    id: root
    hidenTabbarWhenPush: true

    property int cellHeight: Utl.dp(50)

    NavigationBar {
        id: navbar
        title: "ListView"
        onButtonClicked: {
            root.navigationView.pop()
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

    Component{
        id: ta
        TListViewAnimation{}
    }

    ListModel {
        id: _model
        ListElement {
            lid: 1
            strName: "ListView-Animation"
        }
//        ListElement {
//            lid: 2
//            strName: "ScaleAnimation"
//        }
//        ListElement {
//            lid: 3
//            strName: "Transition"
//        }
//        ListElement {
//            lid: 4
//            strName: "PropertyAnimation"
//        }
//        ListElement {
//            lid: 5
//            strName: "NumberAnimation"
//        }
//        ListElement {
//            lid: 6
//            strName: "RotationAnimator(tion)"
//        }
//        ListElement {
//            lid: 7
//            strName: "ColorAnimation"
//        }
//        ListElement {
//            lid: 8
//            strName: "Sequential/ParallelAnimation"
//        }
//        ListElement {
//            lid: 9
//            strName: "PauseAnimation"
//        }
//        ListElement {
//            lid: 10
//            strName: "PropertyAction"
//        }
    }

    function toNext(id) {
        switch(id) {
        case 1:
            root.navigationView.push(ta)
            break;
//        case 2:
//            root.navigationView.push(ts)
//            break;
//        case 3:
//            root.navigationView.push(tt)
//            break;
//        case 4:
//            root.navigationView.push(pa)
//            break;
//        case 5:
//            root.navigationView.push(na)
//            break;
//        case 6:
//            root.navigationView.push(ra)
//            break;
//        case 7:
//            root.navigationView.push(ca)
//            break;
//        case 8:
//            root.navigationView.push(tsa)
//            break;
//        case 9:
//            root.navigationView.push(tpa)
//            break;
//        case 10:
//            root.navigationView.push(tpac)
//            break;
        }
    }
}
