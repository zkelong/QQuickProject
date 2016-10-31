import QtQuick 2.0
import "../../controls"
import "../../toolsbox/config.js" as Config
import "../../toolsbox/font.js" as FontUtl
import "../../toolsbox/color.js" as Color

View {
    id: root
    hidenTabbarWhenPush: true

    property int cellHight: Utl.dp(60)

    NavigationBar {
        id: navbar
        title: "TextShow"
        onButtonClicked: {
            root.navigationView.pop()
        }
    }
    Flickable {
        width: parent.width
        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        contentHeight: _col.y + _col.height
        clip: true

        Column {
            id: _col
            spacing: Utl.dp(10)
            width: parent.width
            height: childrenRect.height

            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    font.family: "Helvetica"
                    text: qsTr("字体-Helvetica")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    font.italic: true
                    text: qsTr("是否斜体")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    font.strikeout: true
                    text: qsTr("是否删除线")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    font.underline: true
                    text: qsTr("是否下划线")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    font.bold: true
                    text: qsTr("是否粗体")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    font.wordSpacing: 30
                    text: qsTr("字的间距：words spacing")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    font.letterSpacing: 30
                    text: qsTr("为单个字母之间的距离-font letter spacing")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    style: Text.Outline //还有几种样式
                    text: qsTr("style定义文本的样式,styleColor定义文本样式所使用的辅助色,styleColor被用作文本的轮廓颜色，凸起或凹陷的文字阴影颜色。如果没有指定样式，则不起作用。")
                    styleColor: "red"
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    text: qsTr("设置为大小写:Font.MixedCase-正常情况;Font.AllUppercase-设置为大写字母;Font.AllLowercase-设置为小写字母;Font.SmallCaps-设置为小型大写字母;Font.Capitalize-每一个单词的第一个字母大写")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    text: "See the Qt Project website."
                    onLinkActivated:  Qt.openUrlExternally("qrc:/ui/properties/TStates.qml")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    color: "black"
                    text: "Text " + "<font color='#aa2356'>" + "HTML" + "</font>" + qsTr("样式")
                }
            }
            Item {
                width: parent.width
                height: cellHight
                Text {
                    width: parent.width - Utl.dp(18)
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: FontUtl.FontSizeSmallA
                    color: "black"
                    text: "Text Rich" + "<img width='" + Utl.dp(30)+"' height='"+Utl.dp(28)+"' src='"+ "qrc:/res/a2.jpg" +"'>" + qsTr("图片")
                }
            }
        }
    }
}

