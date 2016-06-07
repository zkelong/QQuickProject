import QtQuick 2.0
import "../style"

ParallelAnimation {
    id : anim
    property var target

    PropertyAnimation{
        target : anim.target
        property : "opacity"
        from : 1
        to : 0
        duration : Style.theme.popupDefaultDuration;
    }

    PropertyAnimation {
        target : anim.target
        property : "scale"
        from : 1
        to : 0.9
        duration : Style.theme.popupShortDuration;
    }
}

