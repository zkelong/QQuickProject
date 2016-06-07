import QtQuick 2.0
import "../style"

ParallelAnimation {
    id : anim
    property var target

    PropertyAnimation{
        target : anim.target
        property : "opacity"
        from : 0
        to : 1
        duration : Style.theme.popupDefaultDuration;
    }

    PropertyAnimation {
        target : anim.target
        property : "scale"
        from : 0.9
        to : 1
        duration : Style.theme.popupShortDuration;
    }

}
