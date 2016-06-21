import QtQuick 2.0
import QtQuick.Controls 1.3

import "../controls"
import "listView"
import "pathview"
import "animation"
import "canvas"
import "edit"
import "textShow"

View {
    id: root

    ClassMain {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        listModel: listModel
        onClicked: {
            switch(itemId) {
            case 1:
                root.navigationView.push(txt)
                break;
            case 2:
                root.navigationView.push(img)
                break;
            case 3:
                root.navigationView.push(flickFlip)
                break;
            case 4:
                break;
            case 5:
                root.navigationView.push(list)
                break;
            case 6:
                root.navigationView.push(path)
                break;
            case 7:
                break;
            case 8:
                root.navigationView.push(aimation)
                break;
            case 9:
                root.navigationView.push(canvasView)
                break;
            case 10:
                root.navigationView.push(mouse)
                break;
            case 11:
                root.navigationView.push(rota)
                break;
            case 12:
                root.navigationView.push(tran)
                break;
            case 13:
                root.navigationView.push(tran)
                break;
            case 14:
                root.navigationView.push(ed)
                break;
            default:
                break;
            }
        }
    }

    ListModel {
        id: listModel
        ListElement{itemName: "Text"; itemId: 1}     //文字
        ListElement{itemName: "Image"; itemId: 2}    //图片
        ListElement{itemName: "Flickable/Flipable"; itemId: 3}  //Flickable/Flipable
        ListElement{itemName: "GridView"; itemId: 4}  //GridView
        ListElement{itemName: "ListView"; itemId: 5}  //ListView
        ListElement{itemName: "PathView"; itemId: 6}  //PathView
        ListElement{itemName: "Color"; itemId: 7}     //颜色
        ListElement{itemName: "Animation"; itemId: 8}  //动画
        ListElement{itemName: "Canvas"; itemId: 9}    //Canvas
        ListElement{itemName: "MouseArea"; itemId: 10}
        ListElement{itemName: "Rotation"; itemId: 11}    //旋转
        ListElement{itemName: "Transition"; itemId: 12}
        ListElement{itemName: "Path"; itemId: 13}   //路径
        ListElement{itemName: "文本输入"; itemId: 14}   //文本输入
    }

    Component {   //文字
        id: txt
        MyText {}
    }

    Component {   //图片
        id: img
        ImageM{}
    }

    Component {  //Flickable/Flipable
        id: flickFlip
        FlickableAndFlipable{}
    }

    Component {  //listView
        id: list
        MyListView{}
    }

    Component {  //PathView
        id: path
        MyPathView{}
    }

    Component {  //动画
        id: aimation
        AnimationCase{}
    }

    Component {   //canvas
        id: canvasView
        CanvasView {}
    }

    Component {  //MouseArea测试
        id: mouse
        MouseAreaTest {}
    }
    Component {
        id: rota
        RotationTest {}
    }
    Component {
        id: tran
        TransitionTest {}
    }
    Component {
        id: ed
        EditText{}
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
