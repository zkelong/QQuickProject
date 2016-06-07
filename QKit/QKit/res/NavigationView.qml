import QtQuick 2.0
import QtQuick.Controls 1.2

Item {
    id:root

    signal pushed( )
    // When the user taps, the navigationBar & toolbar will be hidden or shown, depending on the visibale state of the navigationBar.
    property bool hidesBarsOnTap: false

    width: parent.width
    height: parent.height

    function push(source,options) {
        var view;
        var destroyOnPop = false;
        var comp = null;
        if (typeof source === "string") {
            comp = Qt.createComponent(source);
            if (comp.status === Component.Error) {
                console.warn("Error loading QML source: ",source);
                console.warn(comp.errorString());
                return;
            }

        } else {
            comp = source;
        }

        var box = boxCmp.createObject(root);

        view = comp.createObject(box,options || {});
        if (view === null) {
            console.warn(source.errorString());
            box.destroy();
            return;
        }
        view.anchors.top = Qt.binding(function(){
            return box.nav.bottom;
        });


        stack.push({item:box, destroyOnPop:destroyOnPop});
    }


    function pop() {
        if (stack.depth == 1)
            return;
        stack.pop();
    }

    function get(idx,dontLoad){
        var box = stack.get(idx)
        if(box){
            return box.content;
        }
        return box;
    }

    StackView{
        id:stack
        width: parent.width
        height: parent.height

        delegate: StackViewDelegate{
            function transitionFinished( properties){
                root.pushed()
            }
        }
    }


    Component{
        id:boxCmp
        property alias nav: _nav
        property var content: null

        Item{
            id:_contentBox
            anchors.fill: parent

            NavigationBar{
                id:_nav
            }
        }
    }

}

