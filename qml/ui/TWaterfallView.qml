import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../controls"
import "../toolsbox/config.js" as Config
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/color.js" as Color

View {
    id: root

    NavigationBar {
        id: navbar
        title: "ButtonGroup"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    WaterfallView {
        id: _waterfall
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
    }
}

