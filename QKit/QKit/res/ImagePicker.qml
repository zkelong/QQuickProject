import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QKit 1.0
import "./style"
import "./def"

Rectangle {
    id:root

    /*
      selectedItems 选中的照相信息数组，其元素包含以下属性
      preview: 预览图id
      path: 原图路径
    */
    signal doneSelected(var selectedItems)
    signal cameraClicked();

    property bool multipleSelected: false //是否支持多选
    property alias navigationBar: topBar
    property bool showCameraBtn: false    //是否显示相机按钮
    property alias cancelButton:_cancelBtn
    property alias doneButton: _doneBtn
    property alias titleLabel: _title
    property string selectedIcon: "./drawable-xxhdpi/img_check1.png"
    property string unSelectedIcon: "./drawable-xxhdpi/img_check0.png"
    property string cameraIconSource: "./drawable-xxhdpi/camera.png"

    QtObject{
        id:pri
        property int __itemWidth: contentBox.width/4
    }

    Component.onCompleted: {
        if(visible && _model.count == 0){
            reLoadPictures();
        }
    }

    onVisibleChanged: {
        if(visible && _model.count == 0){
            reLoadPictures();
        } else {
            _model.clear();
        }
    }

    function reLoadPictures(){
        _model.clear();
        if(showCameraBtn){
            _model.append({src: root.cameraIconSource, ph:"CM", selected:false});
        }

        fecther.photoGroups();
    }

    PhotoFecther{
        id:fecther
        onPhotoGroupCallback:{
            if(!group) return;
            console.log("group.name=" + group.name + " group.url=" + group.url)
            fecther.photosWithGroupUrl(group.url);
        }
        onPhotoCallback:{
            if(photoUrl.length == 0)
                return;
            var path = "image://picker/thumb/" + photoUrl;
            _model.append({src: path, ph: photoUrl, selected:false});
        }

    }

    Component{
        id:itemCmp
        Item{
            width: pri.__itemWidth; height: width
            ImageButton{
                image.fillMode: Image.PreserveAspectCrop
                image.asynchronous: true
                color: "#15000000"

                imageSource: src
                anchors.fill: parent
                anchors.margins: K.dp(2)

                Image{
                    width: K.dp(15); height: width
                    visible: root.multipleSelected && ph !== "CM"
                    source: selected? root.selectedIcon : root.unSelectedIcon
                    anchors.left: parent.left; anchors.leftMargin: K.dp(5)
                    anchors.bottom: parent.bottom; anchors.bottomMargin: K.dp(5)
                }

                onClicked: {
                    if(ph === "CM"){
                        root.cameraClicked();
                        return;
                    }

                    if(!multipleSelected){
                       root.doneSelected( [ {preview:src, path:FileTools.readablePath(ph)} ] );
                    } else {
                        selected = !selected;
                        _model.get(index).selected = !selected;
                    }
                }
            }
        }
    }


    Rectangle{
        id:topBar
        width: parent.width
        height: K.isTranslucentStatusBar()?K.dp(60): K.dp(40)
        color: "#242424"

        Item{
            anchors.bottom: parent.bottom
            width: parent.width
            height: K.isTranslucentStatusBar() ? parent.height - K.dp(20) : parent.height

            Text{
                id:_title
                text:"图片库"
                anchors.centerIn: parent
                color:"white"
                font.pointSize: FontDef.midD
            }

            Button{
                id:_cancelBtn
                anchors.left: parent.left; anchors.leftMargin: K.dp(2)
                anchors.verticalCenter: parent.verticalCenter
                width: K.dp(60); height: K.dp(40)
                text: qsTr("取消")
                style: ButtonStyle{
                    background:Item{}
                    label: Text{
                        text:_cancelBtn.text
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color:"white"
                        font.pointSize: FontDef.midD
                    }
                }

                onClicked: {
                    root.doneSelected([]);
                }
            }

            Button{
                id:_doneBtn
                anchors.right: parent.right; anchors.rightMargin: K.dp(2)
                anchors.verticalCenter: parent.verticalCenter
                width: K.dp(60); height: K.dp(40)
                text: qsTr("确定")
                style: ButtonStyle{
                    background:Item{}
                    label: Text{
                        text:_doneBtn.text
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color:"white"
                        font.pointSize: FontDef.midD
                    }
                }
                onClicked: {
                    var items = [];
                    for(var i = 0; i < _model.count; ++i){
                        var m = _model.get(i)
                        if(m.selected){                            
                            items.push({preview:m.src, path: FileTools.readablePath(m.ph)})
                        }
                    }
                    root.doneSelected(items);
                }
            }
        }

    }

    GridView{
        id:contentBox
        anchors.left: parent.left;
        anchors.top: topBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        cellWidth: pri.__itemWidth
        cellHeight: cellWidth

        model: _model
        delegate: itemCmp

        ListModel{
            id:_model
        }
    }
}

