import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"

View {
    id: root

    ClassMain {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        listModel: listModel
        onClicked: {
            switch(itemId) {
            case 1:
                root.navigationView.push(ta)
                break;
            case 2:
                root.navigationView.push(te)
                break;
            case 3:
                root.navigationView.push(tf)
                break;
            case 4:
                root.navigationView.push(ti)
                break;
            default:
                break;
            }
        }
    }

    ListModel {
        id: listModel
        ListElement{itemName: "TextArea"; itemId: 1}
        ListElement{itemName: "TextEdit"; itemId: 2}
        ListElement{itemName: "TextField"; itemId: 3}
        ListElement{itemName: "TextInput"; itemId: 4}
    }

    Component {
        id: ta
        TestTextArea{}
    }
    Component {
        id: te
        TestTextEdit{}
    }
    Component {
        id: tf
        TestTextField{}
    }
    Component {
        id: ti
        TestTextInput{}
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
