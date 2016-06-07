import QtQuick 2.0
import "../def"

QtObject {
    id : theme

    property var colorPrimary : "#BBDEFB" // blue 100
    property var colorPrimaryDark : "#1565C0" // blue 800
    property var textColorPrimary : Color.black87
    property var windowBackground: "#EFEFEF"
    property var navigationBarColor : "#FFFFFF"
    property int popupDefaultDuration: 220
    property int popupShortDuration: 150

    property color black87 : Color.black87
    property color black54 : Color.black54
    property color black12 : Color.black12
    property color white87 : Color.white87
    property color white38 : Color.white38
    property color alertBtnText: Color.lightBlue

    // Normal test style
    property TextStyle text : TextStyle {
        textSize: FontDef.midC
        textColor : textColorPrimary
    }

    property TextStyle smallText : TextStyle {
        textSize: FontDef.smallA
        textColor : textColorPrimary
    }

    property TextStyle mediumText : TextStyle {
        textSize: FontDef.midB
        textColor : textColorPrimary
    }

    property TextStyle largeText : TextStyle {
        textSize: FontDef.bigC
        textColor : textColorPrimary
    }

    property TextInputStyle textInput : TextInputStyle {
        background : "#00000000"
        textStyle : mediumText
        textSelectHandle : Qt.resolvedUrl("../drawable-xxhdpi/text_select_handle_middle.png")
    }

    property DialogStyle dialog : DialogStyle {
        windowEnterAnimation : Qt.resolvedUrl("../anim/GrowFadeIn.qml")
        windowExitAnimation: Qt.resolvedUrl("../anim/ShrinkFadeOut.qml")
    }

    // Allow to place children under Theme.
    default property alias children: theme.__children
    property list<QtObject> __children: [QtObject {}]
}
