import QtQuick 2.0
import "../controls"
import "../toolsbox/tools.js" as Tools

View {
    id: root
    hidenTabbarWhenPush: true

    Flickable {
        id: flick
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom

        Column {
            id: _col
            width: parent.width
            height: childrenRect.height
            Text {
                id: txt1

            }

        }
    }

    NavigationBar {
        id: navbar
        title: "Time"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
}
