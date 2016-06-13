import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl
/**
 *显示版块--一起搞首页--一元、主播、签到那个样式
 *一个图片，图片下加文字--文字可通过showText来设置是否显示
 *可以横向，纵向显示
 */
Rectangle{
    id: root
    color: "transparent"
    //***//显示属性
    //listView
    property alias listView: _listView
    property alias model: _listView.model     //模块的显示数据 {mid: 编号, picUrl: 图片, title: 显示文字}
    property alias interractive: _listView.interactive //可否滑动
    property alias orientation: _listView.orientation   //方向
    property alias spacing: _listView.spacing   //间隔
    //图片
    property int picWidth: _listView.orientation == ListView.Horizontal ? root.height - Utl.dp(10) : root.width - Utl.dp(10)   //图片宽度
    property int picHeight: picWidth   //图片高度
    property int picRadius: picWidth < picHeight ? picWidth/2 : picHeight/2 //图片圆角
    property int picBorderWidth: Utl.dp(1)  //图片边框
    property string picBorderColor: "transparent" //图片边框颜色
    //文字
    property bool showText: true    //是否显示文字
    property int textPointSize: FontUtl.FontSizeSmallC //文字大小
    property string textColor: "#989898"    //文字颜色
    //事件
    signal clicked(var mid); //模块点击

    //版块
    ListView {
        id: _listView
        width: parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        orientation: ListView.Horizontal
        delegate: _lsitDelegate
    }

    Component {
        id: _lsitDelegate
        Rectangle{
            width: picWidth + Utl.dp(10)
            height: showText ? moduleText.y + moduleText.height : rect_pic.height
            color: "transparent"
            Rectangle { //图片
                id: rect_pic
                width: picWidth + Utl.dp(2)
                height: picHeight + Utl.dp(2)
                anchors.right: parent.right
                color: "transparent"
                border.width: picBorderWidth
                border.color: picBorderColor
                ImageLoader {
                    id: img
                    anchors.fill: parent
                    anchors.margins: Utl.dp(2)
                    source: picUrl
                    defaultSource: "qrc:/res/yiyuan.jpg"
                    visible: false
                }
                Rectangle{
                    id:_headmask
                    anchors.fill: img
                    radius: picRadius
                    visible: false
                }
                OpacityMask {
                    anchors.fill: _headmask
                    source: img
                    maskSource: _headmask
                }
            }
            Text {  //文字
                id: moduleText
                visible: showText
                anchors.top: rect_pic.bottom
                anchors.topMargin: Utl.dp(8)
                anchors.horizontalCenter: rect_pic.horizontalCenter
                font.pointSize: textPointSize
                color: textColor
                text: visible ? title : ""
            }
            MouseArea { //点击操作
                anchors.fill: parent
                onClicked: {
                    root.clicked(mid)
                }
            }
        }
    }
}

