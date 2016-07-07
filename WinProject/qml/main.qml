import QtQuick 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import "./controls"

Window {
    id: win
    visible: true
    width: 800
    height: width*0.618

    NavigationBar {
        id: navbar
        title: qsTr("Hello Window")
        button.visible: false
    }

    GridView {
        id: gv
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        clip: true
        cellWidth: parent.width/4
        cellHeight: cellWidth*.618
        delegate: _delegate
        model: _model
    }

    Component {
        id: _delegate
        Item {
            width: gv.cellWidth
            height: gv.cellHeight
            Rectangle {
                anchors.fill: parent
                anchors.margins: 20
                radius: 5
                color: "#4a96e9"
                Text {
                    anchors.centerIn: parent
                    font.pointSize: 12
                    color: "white"
                    text: title
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        itemClicked(value)
                    }
                }
            }
        }
    }

    ListModel {
        id: _model
        ListElement {
            title: "Window"
            value: 0
        }
        ListElement {
            title: "Dialog"
            value: 1
        }
        ListElement {
            title: "DateDialog"
            value: 2
        }
        ListElement {
            title: "MessageDialog"
            value: 3
        }
    }

    function itemClicked(value) {
        switch(value) {
        case 0:
            newW.show()
            break;
        case 1:
            dialog.visible = true
            break;
        case 2:
            dateDialog.visible = true
            break;
        case 3:
            messageDialog.open()
            break;
        }
    }

    Window {
        id: newW
        width: win.width*.6
        height: win.height*.6
        color: "skyblue"
        onVisibleChanged: {
            console.log("visibleChanged....", visible)
        }
        Text {
            id: nText
            anchors.centerIn: parent
            text: "new window!"
        }
    }

    Dialog {
        id: dialog
        title: "Blue sky dialog"
        //modality: Qt.WindowModal  //显示位置

        contentItem: Rectangle {    //新建的窗口
            color: "lightskyblue"
            implicitWidth: 400
            implicitHeight: 100
            Text {
                text: "Hello blue sky!"
                color: "navy"
                anchors.centerIn: parent
            }
        }
    }

    Dialog {
        id: dateDialog
        title: "Choose a date"
        width: 500
        height: 500
        standardButtons: StandardButton.Save | StandardButton.Cancel

        onAccepted: console.log("Saving the date " +
            calendar.selectedDate.toLocaleDateString())

        Calendar {
            id: calendar
            onDoubleClicked: dateDialog.click(StandardButton.Save)
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Overwrite?"
        icon: StandardIcon.Question
        text: "file.txt already exists.  Replace?"
        detailedText: "To replace a file means that its existing contents will be lost. " +
                      "The file that you are copying now will be copied over it instead."
        standardButtons: StandardButton.Yes | StandardButton.YesToAll |
                         StandardButton.No | StandardButton.NoToAll | StandardButton.Abort
        onYes: console.log("copied")
        onNo: console.log("didn't copy")
        onRejected: console.log("aborted")
    }
}
