import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../controls"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl

View {
    id: root

    NavigationBar {
        id: navbar
        title: "TestHurSturation"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Image {
        id: img
        visible: false
        width: parent.width - Utl.dp(30)
        fillMode: Image.Image.PreserveAspectFit
        anchors.centerIn: parent
    }

    HueSaturation {
        anchors.fill: img
        source: img
        hue: -0.3
        saturation: 0.5
        lightness: -0.1
    }


//    Rectangle {
//        width: parent.width
//        height: 300
//        Rectangle {
//            x: 30; y: 30
//            width: 300; height: 240
//            color: "lightsteelblue"

//            MouseArea {
//                anchors.fill: parent
//                drag.target: parent;
//                drag.axis: "XAxis"
//                drag.minimumX: 30
//                drag.maximumX: 150
//                drag.filterChildren: true

//                Rectangle {
//                    color: "yellow"
//                    x: 50; y : 50
//                    width: 100; height: 100
//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: console.log("Clicked")
//                    }
//                }
//            }
//        }
//    }

}

