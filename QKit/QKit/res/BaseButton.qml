import QtQuick 2.0
import "./def"

Rectangle {
    id:root
    width: 100
    height: 62

    signal clicked(var sender)

    color:"transparent"
    property alias label: text
    property alias title: text.text
    property bool pressed: false

    Text{
        id:text
        width: parent.width
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        font.pointSize:FontDef.smallA
        elide: Text.ElideRight
    }

    MouseArea{
        anchors.fill: parent
        onClicked: root.clicked(root)
        onPressed: root.pressed = true;
        onReleased: root.pressed = false;
        onCanceled: root.pressed = false;
        onExited: root.pressed = false;
    }
}

