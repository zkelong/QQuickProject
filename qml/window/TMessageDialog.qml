import QtQuick 2.0
import QtQuick.Dialogs 1.2
import "../controls"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

View {
    id: root

    NavigationBar {
        id: navbar
        title: "MessageDialog"
        onButtonClicked: {
            root.navigationView.pop()
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

    MessageDialog {
        id: mm
        width: Utl.dp(400)
        height: Utl.dp(400)

        Rectangle {
            anchors.fill: parent
            color: "red"
            Text {
                anchors.centerIn: parent
                text: "用Rectangle覆盖原窗体内容"
            }
        }
    }

    Item {
        height: root.height/3
        width: root.width
        anchors.bottom: parent.bottom
        Button {
            id: btn_show
            width: Utl.dp(45)
            height: Utl.dp(30)
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Utl.dp(15)
            label.text: "SHOW"
            onClicked: {
                messageDialog.visible = true
                //messageDialog.open()--效果同上；.close()
            }
        }
        Button {
            id: btn_hide
            width: Utl.dp(45)
            height: Utl.dp(30)
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn_show.right
            anchors.leftMargin: Utl.dp(15)
            label.text: "MyMessage"
            onClicked: {
                mm.open()
            }
        }
    }
}

