import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "."

View {
    id: root
    hidenTabbarWhenPush: true

    property int cellHeight: Utl.dp(50)

    NavigationBar {
        id: navbar
        title: "Components"
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

    Component {
        id: tbtn
        TButtonGroup{}
    }
    Component {
        id: tpf
        TPullFlickable{}
    }
    Component {
        id: tw
        TWaterfallView{}
    }
    Component {
        id: ad
        TAdcolumn{}
    }
    Component {
        id: tpl
        TPullListView{}
    }
    Component {
        id: tfl
        TFlipable{}
    }
    Component {
        id: gp
        TGridPage{}
    }
    Component {
        id: pg
        TPageView{}
    }

    ListModel {
        id: _model
        ListElement {
            lid: 1
            strName: "ButtonGroup"
        }
        ListElement {
            lid: 2
            strName: "PullFlickable"
        }
        ListElement {
            lid: 3
            strName: "WaterfallView"
        }
        ListElement {
            lid: 4
            strName: "Adcolumn"
        }
        ListElement {
            lid: 5
            strName: "PullListView"
        }
        ListElement {
            lid: 6
            strName: "Flipable"
        }
        ListElement {
            lid: 7
            strName: "GridPage"
        }
        ListElement {
            lid: 8
            strName: "PageView"
        }
    }

    function toNext(id) {
        switch(id) {
        case 1:
            root.navigationView.push(tbtn)
            break;
        case 2:
            root.navigationView.push(tpf)
            break;
        case 3:
            root.navigationView.push(tw)
            break;
        case 4:
            root.navigationView.push(ad)
            break;
        case 5:
            root.navigationView.push(tpl)
            break;
        case 6:
            root.navigationView.push(tfl)
            break;
        case 7:
            root.navigationView.push(gp)
            break;
        case 8:
            root.navigationView.push(pg)
            break;
        }
    }
}
