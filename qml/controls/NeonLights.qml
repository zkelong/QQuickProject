import QtQuick 2.0
import "./color.js" as Color

/**
* 霓虹灯
*/

Rectangle {
    id: root
    height: Utl.dp(5)

    property var points: []
    //windows取root.width==0
    property int pointsNum: Qt.platform.os === "windows" ? Utl.dp(320)/(pointSize*2)+1 : parent.width/(pointSize*2)+1
    property int redNum: 3
    property int redPlace: 0
    property int pointSize: Utl.dp(3)

    Component.onCompleted: {
        for(var i = 0; i < pointsNum; i++) {
            var objItem = point.createObject(row)
            points.push(objItem)
        }
        for(var j = 0; j < redNum; j++) {
            points[j].colorShow = Color.Red;
        }
        runTimer.start()
    }

    Timer {
        id: runTimer
        interval: 100; running: true; repeat: true
        onTriggered: {
            points[redPlace].colorShow = "#e2e2e2"
            if(redPlace > pointsNum-redNum-1) {
                points[redNum + redPlace - pointsNum].colorShow = "#e04026"
            } else {
                points[redPlace + redNum].colorShow = "#e04026"
            }
            if(redPlace < pointsNum - 1)
                redPlace++
            else
                redPlace = 0
        }
    }

    Row {
        id: row
        width: parent.width
        height: pointSize
        anchors.verticalCenter: parent.verticalCenter
    }

    Component {
        id: point
        Rectangle {
            width: pointSize*2
            height: pointSize
            property alias colorShow: pointin.color
            Rectangle {
                id: pointin
                width: pointSize
                height: width
                radius: width/2
                color: "#e2e2e2"
            }
        }
    }
}

