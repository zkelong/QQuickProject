import QtQuick 2.0
pragma Singleton

QtObject {
    id:root
    property var _taker: null
    property NumberAnimation animation: NumberAnimation {
        target: _taker
        property: "y"
        duration: 300
        running: false
        easing.type: Easing.InOutQuad
        onStopped: {
            if(animation.to != 0){
                _taker.destroy();
            }
        }
    }


    function showImageTaker(callback){
        if(_taker){
            console.error("ImageTakerHelper.showImageTaker(): taker already created, please close it and retry!")
            return;
        }

        var mainWindow = K.mainWindow();
        var ty = mainWindow.height;
        _taker = Qt.createComponent("./ImageTaker.qml").createObject(mainWindow,{properties:{y:ty, visible:false}});
        _taker.doneSelected.connect(function(selectedItems){
            animation.from = 0;
            animation.to = ty;
            animation.start();
            if(callback)callback(selectedItems);
        });
        animation.from = ty;
        animation.to = 0;
        animation.start();
    }

}

