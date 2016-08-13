import QtQuick 2.0
import "../controls"
import "../toolsbox/tools.js" as Tools
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property var sourceD: []
    property var leftD: []
    property int showN: 7


    Component.onCompleted: {
        for(var i = 0; i < 32; i++) {
            var str = "测" + i
            sourceD.push(str)
        }
        leftD = [].concat(sourceD)
        source_t.text = JSON.stringify(leftD)
    }

    Item {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom

        Button {
            id: btn
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Utl.dp(15)
            anchors.horizontalCenter: parent.horizontalCenter
            width: Utl.dp(80)
            height: Utl.dp(35)
            border.width: Utl.dp(2)
            border.color: Color.Blue
            label.text: qsTr("换一批")
            onClicked: {
                showNext()
            }
        }

        Text {
            id: source_t
            anchors.top: parent.top
            anchors.topMargin: Utl.dp(10)
            width: parent.width - Utl.dp(20)
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: FontUtl.FontSizeSmallF
            wrapMode: Text.WrapAnywhere
        }

        Text {
            id: show_t
            anchors.top: source_t.bottom
            anchors.topMargin: Utl.dp(10)
            width: parent.width - Utl.dp(20)
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: FontUtl.FontSizeSmallF
            wrapMode: Text.WrapAnywhere
            color: "#454545"
        }
    }

    NavigationBar {
        id: navbar
        title: "RandomSelect"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    function showNext() {
        var nS = []
        console.log("length....", leftD.length)
        var showL = Math.min(leftD.length, showN)
        for(var i = 0; i < showL; i++) {
            var index = Math.floor(Math.random() * leftD.length)
            console.log("index...", index, leftD.length)
            nS.push(leftD[index])
            JSON.stringify("leftD....", index, JSON.stringify(leftD))
            leftD.pop(index)
        }
        if(nS.length)
            show_t.text += JSON.stringify(nS) + "\n"
        if(leftD.length == 0) {
            leftD = [].concat(source_t)
            console.log("sourD///" + JSON.stringify(sourceD))
        }
    }
}
