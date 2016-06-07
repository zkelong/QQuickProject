import QtQuick 2.4

/*
  {
    source:string(图片地址)
  }
*/

Rectangle{
    id:box

    property int currentIndex: 0 //当前页索引
    property bool autoScroll: false //是否自动滚动


    //添加一个视图
    //@param viewCompent 视图组件
    //@param properties 附加属性，可选
    function addItem(viewCompent, properties){
         var obj = viewCompent.createObject(contanier, properties)
        root.items.push(obj)

        var c = circle.createObject(circles);
        if(root.items.length == 1) c.color = "red"
    }

    //移除指定索引位置的视图
    function removeItem(index){
        if(index >= root.items.length) return;
        items[index].destroy();
        items.splice(index,1)

        _removeCircle(index)
    }


    //移除所有视图
    function removeAll(){
        for(var i = 0; i < root.items.length; ++i){
            root.items[i].destroy();
        }

        var chs = circles.children
        for(i = 0; i < chs.length; ++i){
            chs[i].destroy();
        }
        root.items = [];
    }

    function getItem(index){
        return root.items[index]
    }

    Flickable{
        id:root
        anchors.fill: parent
        contentWidth: contanier.childrenRect.x + contanier.childrenRect.width
        maximumFlickVelocity:1

        property bool userPress: false //用户按下，用户按下时不自动滚动
        property var items: []  //所有视图元素


        //设置当前正在显示的状态
        function _setCurrentCircle(index){
            var chs = circles.children
            if(chs.length === 0)
                return
            for(var i = 0; i < chs.length; ++i){
                chs[i].color = "white"
            }
            chs[index].color = "red"
        }

        function _removeCircle(index){
            circles.children[index].destroy();
        }

        //显示下一张
        function doNext(){
            if(currentIndex + 1 == items.length){
                currentIndex = 0
            } else {
                currentIndex++
            }
            if(currentIndex < 0) currentIndex = 0;
            else if(currentIndex >= items.length) currentIndex = items.length - 1;

            am.to = currentIndex * root.width
            am.start()
        }

        Timer {
            id:timer
            running: autoScroll && root.visible && !root.userPress
            interval: 4000; repeat: true
            onTriggered: root.doNext()
        }

        NumberAnimation {
            id:am
            target: root
            property: "contentX"
            duration: 200
            easing.type: Easing.InOutQuad
            onStopped: {
                root._setCurrentCircle(currentIndex)
            }
        }

        Row {
            id:contanier
            height: parent.height
        }

        onDraggingHorizontallyChanged: {
            if(draggingHorizontally || items.length === 0)
                return
            var xdis = contentX - currentIndex * root.width

            var dis = root.width/3

            if(xdis > dis){
                currentIndex++
            } else if(xdis < -dis){
                currentIndex--
            }

            if(currentIndex < 0) currentIndex = 0;
            else if(currentIndex >= items.length) currentIndex = items.length - 1;
            am.to = currentIndex * root.width
            am.start()
        }
    }

    Component { //圆点
        id:circle
        Rectangle{
            width: Utl.dp(8); height: width
            radius: width/2
            color:"white"
        }
    }

    Row {
        id:circles
        spacing: Utl.dp(8)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom; anchors.bottomMargin: Utl.dp(10)
    }
}
