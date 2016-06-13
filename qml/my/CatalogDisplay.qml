import QtQuick 2.0

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"

    GridView {
        id: _grid
        anchors.top: parent.top
        anchors.topMargin: Utl.dp(4)
        width: parent.width
        height: parent.height
        cellHeight: 240
        cellWidth: root.width / 6
        contentHeight: childrenRect.height
        model: _gridModel
        delegate: _gridDelegate
    }

    Component {
        id: _gridDelegate
        Item {
            width: _grid.cellWidth
            height: _grid.cellHeight
            Rectangle { //图片
                id: _rect_img
                width: 140; height: 140
                radius: 3
                anchors.top: parent.top
                anchors.topMargin: 36
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#fff"
                opacity: 0.0  //0.1
            }
            Image {
                width: 100; height: 100
                anchors.centerIn: _rect_img
                fillMode: Image.PreserveAspectCrop
                source: pic  //图片资源
            }
            //还要个播放图标？--根据文件类型显示
            Image {
                //visible: "能播放？" ? true : false
                width: 20
                height: 20
                anchors.centerIn: _rect_img
                source: ""  //图标资源
            }

            Rectangle {
                id: _rect_txt
                width: 170; height: _text.lineCount == 1 ? 40 : 70
                radius: 3
                anchors.top: _rect_img.bottom
                anchors.topMargin: 14
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#fff"
                opacity: 0.0  //0.1
            }
            Text {
                id: _text
                width: _rect_txt - 26
                anchors.centerIn: _rect_txt
                maximumLineCount: 2
                wrapMode: Text.WrapAnywhere
                elide: Text.ElideRight
                color: "#e5e9ef"
                font.pointSize: 14
                text: fileName  //文字说明
            }
            MouseArea {
                height: parent.height
                width: 170
                anchors.centerIn: parent
                onPressed: {
                    _rect_img.opacity = 0.1
                    _rect_txt.opacity = 0.1
                }
                onReleased: {
                    _rect_img.opacity = 0.0
                    _rect_txt.opacity = 0.0
                }
                onCanceled: {
                    _rect_img.opacity = 0.0
                    _rect_txt.opacity = 0.0
                }

                onClicked: {    //点击操作--开文件夹，或其他
                    console.log("点击操作--开文件夹，或其他")
                }
            }
        }
    }

    ListModel {
        id: _gridModel
        ListElement {
            pic: "http://img4.duitang.com/uploads/blog/201403/28/20140328105625_Hfaxm.png"
            fileName: "文件夹1"
        }
        ListElement {
            pic: "http://pic41.nipic.com/20140526/9159693_165138680000_2.jpg"
            fileName: "图片"
        }
        ListElement {
            pic: "http://img4.duitang.com/uploads/blog/201403/28/20140328105625_Hfaxm.png"
            fileName: "文件夹1"
        }
        ListElement {
            pic: "http://pic41.nipic.com/20140526/9159693_165138680000_2.jpg"
            fileName: "图片"
        }
        ListElement {
            pic: "http://img4.duitang.com/uploads/blog/201403/28/20140328105625_Hfaxm.png"
            fileName: "文件夹1"
        }
        ListElement {
            pic: "http://pic41.nipic.com/20140526/9159693_165138680000_2.jpg"
            fileName: "图片"
        }
        ListElement {
            pic: "http://pic41.nipic.com/20140526/9159693_165138680000_2.jpg"
            fileName: "图片"
        }
        ListElement {
            pic: "http://pic41.nipic.com/20140526/9159693_165138680000_2.jpg"
            fileName: "图片"
        }
    }
}

