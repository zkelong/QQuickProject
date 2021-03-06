﻿import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl

View {
    id: root
    hidenTabbarWhenPush: true

    property int cellHeight: Utl.dp(50)

    NavigationBar {
        id: navbar
        title: "IMAGE"
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
        id: imf
        TImageFillMode{}
    }

    Component {
        id: tri
        TRoundImage{}
    }
    Component {
        id: thue
        THueSaturation{}
    }
    Component {
        id: mir
        TImageMirro{}
    }
    Component {
        id: tfast
        TFastBlur{}
    }

    ListModel {
        id: _model
        ListElement {
            lid: 1
            strName: "ImageFillMode"
        }
        ListElement {
            lid: 2
            strName: "RoundImage"
        }
        ListElement {
            lid: 3
            strName: "HueSaturation"
        }
        ListElement {
            lid: 4
            strName: "Mirro"
        }
        ListElement {
            lid: 5
            strName: "FastBlur"
        }
    }

    function toNext(id) {
        switch(id) {
        case 1:
            root.navigationView.push(imf)
            break;
        case 2:
            root.navigationView.push(tri)
            break;
        case 3:
            root.navigationView.push(thue)
            break;
        case 4:
            root.navigationView.push(mir)
            break;
        case 5:
            root.navigationView.push(tfast)
            break;
        }
    }
}
