import QtQuick 2.0
import QtQuick.Controls 1.1
import ColorMaker 1.0
import "./controls"

Rectangle {
    id: root

    ScrollTextEdit {
        id: scroll
        width: parent.width
        height: parent.height / 2
        property int lastCurPos: 0
        property string lastText: ""
        property bool change: false
        onCursorPositionChanged: {
            if(lastText === text) {
                lastCurPos = cursorPosition
            }
        }
        onTextChanged: {
            if(change || cursorPosition == 0) {
                if(lastCurPos > 0 && change)
                    cursorPosition = lastCurPos - 1
                else
                    cursorPosition = lastCurPos
                change = false
            }
            if(text.charAt(cursorPosition - 1) === '\n') {
                change = true
                text = lastText
            }
            lastText = text
            lastCurPos = cursorPosition
        }
    }

    Rectangle {
        width: parent.height
        height: 50
        anchors.bottom: parent.bottom
        color: "red"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(scroll.text.length > 2) {
                    scroll.cursorPosition = 1
                }
            }
        }
    }
}
