import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true


    property int listViewHeight: root.height / 2
    property int listCellHight: root.height/4

    Component.onCompleted: {
        for(var i = 0; i < 10; i++) {
            var item = {picUrl: Config.testPicUrl[i]}
            listModel.append(item)
        }
    }

    NavigationBar {
        id: navbar
        title: "ListAnimation"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable {
        id: flick
        width: parent.width
        anchors.top: navbar.bottom;
        anchors.bottom: parent.bottom
        contentHeight: _column.height + Utl.dp(20)
        clip: true

        Column {
            id: _column
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height
            spacing: 10

            Rectangle {  //滑动动画: 滑动-小变大
                anchors.left: parent.left
                anchors.right: parent.right
                height: childrenRect.height

                Text {
                    id: txt1
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                    font.bold: true
                    text: qsTr("滑动-小变大")
                }
                ListView {
                    anchors.top: txt1.bottom
                    anchors.topMargin: 5
                    width: parent.width
                    height: listViewHeight
                    clip: true
                    model: listModel
                    delegate: normalDelegate
                }
            }

            Rectangle {  //滑动动画: 滑动-左到右
                anchors.left: parent.left
                anchors.right: parent.right
                height: childrenRect.height

                Text {
                    id: txt2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                    text: qsTr("滑动-左到右")
                }
                ListView {
                    anchors.top: txt2.bottom
                    anchors.topMargin: 5
                    width: parent.width
                    height: listViewHeight
                    clip: true
                    model: listModel
                    delegate: normalDelegate1
                }
            }
        }
    }

    //样式1
    Component { //加载动画: 滑动-小变大
        id: normalDelegate
        Rectangle {
            id: rect
            width: root.width;
            height: listCellHight
            color: "skyBlue"
            border.color: "black"
            radius: 3
            scale: 0.6   //缩放动画
            property int currentIndex: 0

            Component.onCompleted: {
                sa.start()
            }
            ImageLoader {
                anchors.fill: parent
                anchors.margins: Utl.dp(15)
                fillModel: Image.Pad
                defaultSource: Config.DefaultImage
                source: picUrl
            }
            NumberAnimation {
                id:sa
                target: rect
                property: "scale"
                duration: 800
                to: 1
                easing.type: Easing.InOutQuad
            }
        }
    }

    //样式2
    Component { //加载动画: 滑动-小变大
        id: normalDelegate1
        Rectangle {
            id: rect
            width: root.width; height: listCellHight
            x: root.width  //x位置动画
            color: "skyBlue"
            border.color: "black"
            radius: 3
            property int currentIndex: 0

            Component.onCompleted: {
                sa.start()
            }
            Image {
                anchors.fill: parent
                anchors.margins: Utl.dp(15)
                fillMode: Image.Pad
                source: picUrl
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentIndex = index
                }
            }
            NumberAnimation {
                id:sa
                target: rect
                property: "x"
                duration: 800
                to:0
                easing.type: Easing.InOutQuad
            }
        }
    }

    //数据源
    ListModel {
        id:listModel
    }
}

