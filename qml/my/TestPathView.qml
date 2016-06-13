import QtQuick 2.3
import QtQuick.Controls 1.2
import "../controls"

View {
    id: root

    Component.onCompleted: {
        for(var a=1;a<20;a++){
            listView.append({})
        }

    }
    property string delegate_text;

    Component {
        id: rectDelegate;
        Item {
            id: wrapper;
            z: PathView.zOrder;
            opacity: PathView.itemAlpha;
            scale: PathView.itemScale;
            Rectangle {
                width: 100;
                height: 60;
                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
                border.width: 2;
                border.color: wrapper.PathView.isCurrentItem ? "red" : "lightgray";
                Text {
                    anchors.centerIn: parent;
                    font.pixelSize: 28;
                    text: index;
                    color: Qt.lighter(parent.color, 2);
                }
            }
        }
    }

    Component{
        id:delegate
        Rectangle{
            id:tt
            width: 100
            height: 30
            color:Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
            z: PathView.zOrder;
            opacity: PathView.itemAlpha;
            scale: PathView.itemScale;

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    pathView.currentIndex = index
                    console.log(tt.color + "~" + index)
                }
            }
        }
    }

    ListModel{
        id:listView
    }
    PathView {
        id: pathView;
        width: parent.width
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        anchors.fill: parent;
        //interactive: true;
        pathItemCount: 7;
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightRangeMode: PathView.StrictlyEnforceRange;
        delegate: delegate;
        model: listView;
        path:Path {
            startX: 10;
            startY: 100;
            PathAttribute { name: "zOrder"; value: 0 }
            PathAttribute { name: "itemAlpha"; value: 0.1 }
            PathAttribute { name: "itemScale"; value: 0.6 }
            //               PathQuad { x: 120; y: 25; controlX: 260; controlY: 75 }
            //               PathQuad { x: 120; y: 100; controlX: -20; controlY: 75 }
            PathLine {
                x: root.width/2 - 40;
                y: 100;
            }
            PathAttribute { name: "zOrder"; value: 10 }
            PathAttribute { name: "itemAlpha"; value: 1.1 }
            PathAttribute { name: "itemScale"; value: 1.2 }
            PathLine {
                relativeX: root.width/2 - 60;
                relativeY: 0;
            }
            PathAttribute { name: "zOrder"; value: 0 }
            PathAttribute { name: "itemAlpha"; value: 0.1 }
            PathAttribute { name: "itemScale"; value: 0.6 }
        }

        focus: true;
        Keys.onLeftPressed: decrementCurrentIndex();
        Keys.onRightPressed: incrementCurrentIndex();
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
