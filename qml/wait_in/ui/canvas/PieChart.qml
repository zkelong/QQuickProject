import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"

View {
    id: root

    property var chartElement: [];

    Component.onCompleted: {
        chartElement.push({name: "测试长的名字多长就这么吧0", value: 0.01})
        chartElement.push({name: "测试长的名字多长就这么吧1", value: 0.01})
        chartElement.push({name: "测试长的名字多长就这么吧2", value: 0.02})
        chartElement.push({name: "测试长的名字多长就这么吧3", value: 0.04})
        chartElement.push({name: "测试长的名字多长就这么吧4", value: 0.05})
        chartElement.push({name: "测试长的名字多长就这么吧5", value: 0.05})
        chartElement.push({name: "测试长的名字多长就这么吧6", value: 0.08})
        chartElement.push({name: "测试长的名字多长就这么吧7", value: 0.1})
        chartElement.push({name: "测试长的名字多长就这么吧8", value: 0.1})
        chartElement.push({name: "测试长的名字多长就这么吧9", value: 0.52})
    }

    function drawPie() {

    }

    Rectangle {
        width: parent.width * 2 / 3
        height: width
        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {

            }
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
