import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"
import "../net"

View {
    id: root

    Column {
        id: content
        anchors.top: titleBar.bottom
        anchors.left: parent.left; anchors.right: parent.right

        Rectangle {
            width: parent.width
            height: 120
            color: "black"
//            MouseArea{
//                anchors.fill: parent
//                onClicked : {
//                    console.log("out..........")

//                }
//            }

            SectorGraph {
                id: sector
                width: parent.height
                height: width
                anchors.centerIn: parent
            }

//            MouseArea {
//                id: mouseA
//                anchors.fill: sector
//                onClicked: {
//                    console.log("sector...........in")
//                }
//            }
        }


    }


    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
