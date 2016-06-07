import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QKit 1.0

Rectangle {
    id:root
    signal clicked(var sender)
    property alias imageSource: _img.source
    property alias image: _img

    color: "transparent"
    width: K.dp(100)
    height: K.dp(62)

    Image{
        id:_img
        anchors.fill: parent
    }

    MouseArea{
        id:ms
        anchors.fill: parent
        onPressed: {
            shade.visible = true;
        }

        onReleased: {
            shade.visible = false;
        }

        onCanceled: {
            shade.visible = false;
        }

        onExited: {
            shade.visible = false;
        }

        onClicked: {
            if(!root.enabled)
                return;
            root.clicked(root)
        }
    }


    Rectangle{
        id:shade
        anchors.fill: parent
        color: "#88000000"
        visible: false
    }
}

