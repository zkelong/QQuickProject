import QtQuick 2.0
import "../controls"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl

View {
    id: root

    property int cellHeight: Utl.dp(50)

    NavigationBar {
        id: navbar
        title: "WINMAIN"
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

    ListModel {
        id: _model
        ListElement {
            lid: 1
            strName: "MessageDialog"
        }
        ListElement {
            lid: 2
            strName: "Dialog"
        }
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
        id: msd
        TMessageDialog{}
    }
    Component {
        id: td
        TDialog{}
    }

    function toNext(id) {
        switch(id) {
        case 1:
            root.navigationView.push(msd)
            break;
        case 2:
            root.navigationView.push(td)
            break;
        }
    }
}

