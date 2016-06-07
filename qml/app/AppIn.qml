import QtQuick 2.0
import QtQuick.Window 2.2
import "../controls"
import "../.."
import "../toolsbox/tools.js" as Tools

View {
    id: root
    Text {
        anchors.centerIn: parent
        text: "APP"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("click....", nText.text)
            newW.show()
//            newW.requestActivate()
        }
    }

    Window {
        id: newW
        width: Utl.dp(200)
        height: Utl.dp(200)
        color: "red"
        onVisibleChanged: {
            console.log("visible.....", visible)
            if(visible)
                Tools.setMainWindowEnable(false)
            else
                Tools.setMainWindowEnable(true)
        }
        Text {
            id: nText
            text: "new window, nText!"
        }
    }

    Component {
        id: app
        AppMain {}
    }
}

