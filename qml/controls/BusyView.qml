import QtQuick 2.0
import QtQuick.Controls 1.3

/**
  *忙碌显示
  */
Rectangle{
    id:root
    width: parent.width
    height: parent.height
    color: "#55000000"
    visible: running

    property alias running: busy.running

    BusyIndicator {
        id: busy
        anchors.centerIn: parent
        running: false
    }

    MouseArea{  //截获鼠标操作
        anchors.fill: root
        onClicked: {
        }
    }
}


