import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root

    property string source1: "qrc:/res/x.png"
    property string source2: "qrc:/res/h1.jpg"
    property string source3: "qrc:/res/l1.jpg"

    Component.onCompleted: {
        setSource(source1)
    }

    NavigationBar {
        id: navbar
        title: "ImageFillMode"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }

    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: _col.height

        Column {
            id: _col
            width: parent.width
            height: childrenRect.height

            Row {
                id: _row1
                width: parent.width
                height: parent.width / 3
                Item {
                    height: parent.height
                    width: height
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: Utl.dp(5)
                        text: "Stretch(default)"
                    }
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Utl.dp(15)
                        border.width: 1
                        Image {
                            id: _img1
                            anchors.fill: parent
                            fillMode: Image.Stretch
                        }
                    }
                }
                Item {
                    height: parent.height
                    width: height
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: Utl.dp(5)
                        text: "PreserveAspectFit"
                    }
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Utl.dp(15)
                        border.width: 1
                        Image {
                            id: _img2
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Item {
                    height: parent.height
                    width: height
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: Utl.dp(5)
                        text: "PreserveAspectCrop"
                    }
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Utl.dp(15)
                        border.width: 1
                        Image {
                            id: _img3
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }
            Row {
                id: _row2
                width: parent.width
                height: parent.width / 3
                Item {
                    height: parent.height
                    width: height
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: Utl.dp(5)
                        text: "Tile"
                    }
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Utl.dp(15)
                        border.width: 1
                        Image {
                            id: _img4
                            anchors.fill: parent
                            fillMode: Image.Tile
                        }
                    }
                }
                Item {
                    height: parent.height
                    width: height
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: Utl.dp(5)
                        text: "TileVertically"
                    }
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Utl.dp(15)
                        border.width: 1
                        Image {
                            id: _img5
                            anchors.fill: parent
                            fillMode: Image.TileVertically
                        }
                    }
                }
                Item {
                    height: parent.height
                    width: height
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: Utl.dp(5)
                        text: "TileHorizontally"
                    }
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Utl.dp(15)
                        border.width: 1
                        Image {
                            id: _img6
                            anchors.fill: parent
                            fillMode: Image.TileHorizontally
                        }
                    }
                }
            }
            Row {
                id: _row
                width: parent.width
                height: parent.width / 3
                Item {
                    height: parent.height
                    width: height
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: Utl.dp(5)
                        text: "Pad"
                    }
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Utl.dp(15)
                        border.width: 1
                        Image {
                            id: _img7
                            anchors.fill: parent
                            fillMode: Image.Pad
                        }
                    }
                }
            }
        }

        Button {
            width: parent.width/2
            height: Utl.dp(30)
            anchors.top: _col.bottom
            anchors.topMargin: Utl.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            label.text: "ChageSource"
            border.width: 1
            onClicked: changeSource()
        }
    }

    function changeSource() {
        if(_img1.source == source1) {
            setSource(source2)
        } else if(_img1.source == source2){
           setSource(source3)
        } else {
            setSource(source1)
        }
    }
    function setSource(source) {
        _img1.source = source
        _img2.source = source
        _img3.source = source
        _img4.source = source
        _img5.source = source
        _img6.source = source
        _img7.source = source
    }
}

