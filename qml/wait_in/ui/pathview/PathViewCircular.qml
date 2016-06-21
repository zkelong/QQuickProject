import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"

View {
    id: root

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
