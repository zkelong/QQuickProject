import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    PullFlickable {
        id: pf
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        Rectangle {
            id: _rect
            anchors.top: parent.top
            width: parent.width
            height: root.height-500
            color: "#aacc00"
            Text {
                id: _txt
                anchors.centerIn: parent
                text: pf.loading ? "loading" : "over"
            }
        }
        onReload: {
            startLoading(true)
            _timer.start()
        }
    }

    NavigationBar {
        id: navbar
        title: "PullFlickable"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Timer {
        id: _timer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            if(_rect.color === "aacc00")
                _rect.color = "#cc0099"
            else
                _rect.color = "#aacc00"
            pf.stopLoading(true)
        }
    }
}

