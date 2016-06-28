import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

RoundImage{
    id: _img
    source: "qrc:/res/a2.jpg"

    SequentialAnimation {
        id: picAni
        running: true
        loops: Animation.Infinite
        NumberAnimation { target: _img; property: "scale";from: 1;to: 0; duration: 1300;}
        NumberAnimation { target: _img; property: "scale";from: 0;to: 0; duration: 300;}
        NumberAnimation { target: _img; property: "scale";from: 0;to: 1; duration: 1300;}
    }

    function startAnimation() {
        picAni.start()
    }
}

