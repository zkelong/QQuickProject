import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl


View {
    id: root

    NavigationBar {
        id: navbar
        title: "RaderMarry"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    property var wavesAnimation: []
    Component.onCompleted: {
        wavesAnimation.push(animation0)
        wavesAnimation.push(animation1)
        wavesAnimation.push(animation2)
        wavesAnimation.push(animation3)
        wavesAnimation.push(animation4)
        waveStart.start()
    }

    onWidthChanged: {
        if(width > 0)
            waveWidthE = root.width - Utl.dp(20)
    }

    //波浪
    property real waveWidthB: Utl.dp(40);
    property real waveWidthE: waveWidthB*8
    property string waveColor: "#96c2df"
    property int aTime: 5000 //波浪动画时间
    Item {
        width: parent.width
        height: parent.width
        anchors.centerIn: parent

        Rectangle {
            id: wave0
            width: waveWidthB
            height: width
            radius: width
            border.color: waveColor
            border.width: Utl.dp(6)
            anchors.centerIn: parent
        }
        Rectangle {
            id: wave1
            width: waveWidthB
            height: width
            radius: width
            border.color: waveColor
            border.width: Utl.dp(6)
            anchors.centerIn: parent
        }
        Rectangle {
            id: wave2
            width: waveWidthB
            height: width
            radius: width
            border.color: waveColor
            border.width: Utl.dp(6)
            anchors.centerIn: parent
        }
        Rectangle {
            id: wave3
            width: waveWidthB
            height: width
            radius: width
            border.color: waveColor
            border.width: Utl.dp(6)
            anchors.centerIn: parent
        }
        Rectangle {
            id: wave4
            width: waveWidthB
            height: width
            radius: width
            border.color: waveColor
            border.width: Utl.dp(6)
            anchors.centerIn: parent
        }
    }

    ParallelAnimation {
        id: animation0
        running: false
        loops: Animation.Infinite
        NumberAnimation {target: wave0; property: "width"; to: waveWidthE; duration: aTime }
        NumberAnimation {target: wave0; property: "opacity"; to: 0; duration: aTime}
        ScriptAction {script: {wave0.width = waveWidthB; wave0.opacity = 1}}
    }

    ParallelAnimation {
        id: animation1
        running: false
        loops: Animation.Infinite
        NumberAnimation {target: wave1; property: "width"; to: waveWidthE; duration: aTime }
        NumberAnimation {target: wave1; property: "opacity"; to: 0; duration: aTime}
        ScriptAction {script: {wave1.width = waveWidthB; wave1.opacity = 1}}
    }

    ParallelAnimation {
        id: animation2
        running: false
        loops: Animation.Infinite
        NumberAnimation {target: wave2; property: "width"; to: waveWidthE; duration: aTime }
        NumberAnimation {target: wave2; property: "opacity"; to: 0; duration: aTime}
        ScriptAction {script: {wave2.width = waveWidthB; wave2.opacity = 1}}
    }

    ParallelAnimation {
        id: animation3
        running: false
        loops: Animation.Infinite
        NumberAnimation {target: wave2; property: "width"; to: waveWidthE; duration: aTime }
        NumberAnimation {target: wave2; property: "opacity"; to: 0; duration: aTime}
        ScriptAction {script: {wave2.width = waveWidthB; wave2.opacity = 1}}
    }

    ParallelAnimation {
        id: animation4
        running: false
        loops: Animation.Infinite
        NumberAnimation {target: wave3; property: "width"; to: waveWidthE; duration: aTime }
        NumberAnimation {target: wave3; property: "opacity"; to: 0; duration: aTime}
        ScriptAction {script: {wave3.width = waveWidthB; wave3.opacity = 1}}
    }

    property int startIndex: 0
    Timer {
        id: waveStart
        interval: aTime/6
        running: false
        repeat: true
        onTriggered: {
            console.log("what....")
            if(startIndex === wavesAnimation.length) {
                waveStart.stop()
            } else {
                wavesAnimation[startIndex].start()
            }
            startIndex++
        }
    }

    //随机位置
    RandarMarryPoints {
        width: parent.width
        height: parent.width
        anchors.centerIn: parent
    }
}

