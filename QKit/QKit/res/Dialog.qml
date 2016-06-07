// Dialog interface
import QtQuick 2.0
import QtQuick.Window 2.1
import "./style"

Drawable {
    id: dialog
    opacity: 0
    enabled: false

    signal selected(int index);

    property int selectedIndex : -1;

    property bool active: false

    property bool closeWhenTapBg: true //点击背景时是否自动关闭

    property DialogStyle style : DialogStyle {
        windowEnterAnimation: Style.theme.dialog.windowEnterAnimation
        windowExitAnimation:  Style.theme.dialog.windowExitAnimation
    }

    function open() {
        active = true
    }

    function close() {
        active = false;
    }

    function done(code) {
        selectedIndex = code;
        selected(code);
        active = false;
    }

    Rectangle {
        id : mask
        anchors.centerIn: parent
        opacity: 0.5
        width: Screen.width
        height: Screen.height
        scale : 1 / dialog.scale
        z: -10000
        color : "#000000"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(closeWhenTapBg)
                    dialog.active = false
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -100
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back ||
            event.key === Qt.Key_Escape) {
            dialog.active = false;
            event.accepted = true;
        }
    }

    states: [
        State {
            name: "Active"
            when : active

            PropertyChanges {
                target : dialog
                opacity : 1
                focus: true
                enabled : true
            }
        }
    ]

    AnimationLoader {
        id : enterAnimation
        transition: fromNullToActive
        source : dialog.style.windowEnterAnimation
        target: dialog
    }

    AnimationLoader{
        id : exitAnimation
        transition: fromActiveToNull
        source : dialog.style.windowExitAnimation
        target: dialog
    }

    transitions: [Transition {
            id: fromNullToActive
            from: ""
            to: "Active"
        },
        Transition {
            id: fromActiveToNull
            from: "Active"
            to: ""
        }
    ]

}
