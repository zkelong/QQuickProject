import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.2
import "../controls"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

View {
    id: root

    NavigationBar {
        id: navbar
        title: "Dialog"
        onButtonClicked: {
            root.navigationView.pop()
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
        standardButtons: StandardButton.Save | StandardButton.Cancel

        onAccepted: console.log("Saving the date " +
            calendar.selectedDate.toLocaleDateString())

        Calendar {
            id: calendar
            onDoubleClicked: dateDialog.click(StandardButton.Save)
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
                dialog.visible = true
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
            label.text: "dateDialog"
            onClicked: {
                dateDialog.open()
                console.log("aaaa")
            }
        }
    }
}

