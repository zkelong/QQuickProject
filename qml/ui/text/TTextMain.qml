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
        title: "Text"
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
        id: ts
        TextShow{}
    }

    Component {
        id: tst
        TShineText{}
    }
    Component {
        id: txtA
        TextAnimation{}
    }

    ListModel {
        id: _model
        ListElement {
            lid: 1
            strName: "Text-show"
        }
        ListElement {
            lid: 2
            strName: "TShineText"
        }
        ListElement {
            lid: 3
            strName: "Text-animation"
        }
    }

    function toNext(id) {
        switch(id) {
        case 1:
            root.navigationView.push(ts)
            break;
        case 2:
            root.navigationView.push(tst)
            break;
        case 3:
            root.navigationView.push(txtA)
            break;
        }
    }
}
