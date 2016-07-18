import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl


View {
    id: root
    hidenTabbarWhenPush: true

    NavigationBar {
        id: navbar
        title: "浮动按钮"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }


    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: root.height
        Rectangle {
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: parent.verticalCenter
            color: "green"
        }
    }


    Item {
        id: content_item
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom

        Rectangle {
            id: rect
            width: 50; height: 50
            color: "red"
            opacity: (600.0 - rect.x) / 600

            MouseArea {
                anchors.fill: parent
                drag.target: rect
                drag.axis: Drag.XAndYAxis
                drag.minimumX: 0
                drag.maximumX: content_item.width - rect.width
                drag.minimumY: 0
                drag.maximumY: content_item.height - rect.height
                onClicked: {
                    console.log("click........")
                }
            }
        }
    }
}

