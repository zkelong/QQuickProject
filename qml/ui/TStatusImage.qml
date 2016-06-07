import QtQuick 2.0
import "../controls"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl

View {
    id: root

    property int cellHeight: Utl.dp(50)

    NavigationBar {
        id: navbar
        title: "TestStatusImage"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Item {
        id: item_left
        width: parent.width/2
        height: parent.height/2
        anchors.top: navbar.bottom
        Text {
            id: text_left
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: FontUtl.FontSizeSmallE
            text: qsTr("只有normalSource")
        }
        StatusImage {
            id: st_left
            width: parent.width/2
            height: width
            anchors.centerIn: parent
            normalSource: "qrc:/res/0.png"
            selected: false
        }
    }
    Item {
        id: item_right
        width: parent.width/2
        height: parent.height/2
        anchors.right: parent.right
        anchors.top: navbar.bottom
        Text {
            id: text_right
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: FontUtl.FontSizeSmallE
            text: qsTr("有normalSource\nselectedSource\ndisableSource")
        }
        StatusImage {
            id: st_right
            width: parent.width/2
            height: width
            anchors.centerIn: parent
            normalSource: "qrc:/res/0.png"
            selectedSource: "qrc:/res/1.png"
            disableSource: "qrc:/res/2.png"
            selected: false
        }
    }

    Item {
        width: parent.width
        anchors.top: item_left.bottom
        anchors.bottom: parent.bottom
        Rectangle {
            width: parent.width/4
            height: 120
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Utl.dp(10)
            border.width: Utl.dp(1)
            Text {
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeSmallE
                text: "selected(true)"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    st_left.enabled = true
                    st_left.selected = true
                    st_right.enabled = true
                    st_right.selected = true
                }
            }
        }

        Rectangle {
            width: parent.width/4
            height: 120
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            border.width: Utl.dp(1)
            Text {
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeSmallE
                text: "selected(false)"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    st_left.enabled = true
                    st_left.selected = false
                    st_right.enabled = true
                    st_right.selected = false
                }
            }
        }


        Rectangle {
            width: parent.width/4
            height: 120
            anchors.verticalCenter: parent.verticalCenter
            border.width: Utl.dp(1)
            anchors.right: parent.right
            anchors.rightMargin: Utl.dp(10)
            Text {
                anchors.centerIn: parent
                font.pointSize: FontUtl.FontSizeSmallE
                text: "enabled(false)"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    st_left.enabled = false
                    st_right.enabled = false
                }
            }
        }
    }
}

