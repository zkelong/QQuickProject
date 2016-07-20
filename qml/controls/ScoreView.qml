import QtQuick 2.0
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl

//评分系统视图
Rectangle {
    id: root
    width: row.width
    height: row.height
    color:Color.Clear
    property int num:5
    property int max:5
    property int imgWidth;
    property string imgUrl:"qrc:/res/start_yellow.png";
    property string imgUrl2:"qrc:/res/start_yellowE.png";
    property alias spacing:row.spacing
    property bool isSelect:false
    property var stars:[]

    Component.onCompleted: {
        if(num>=0){
            for(var i=0;i<max;i++){
                var item =star.createObject(row,{id:i,imgWidth:imgWidth})
                stars.push(item)
            }
        }
    }

    Row{
        id:row
        spacing:2
    }

    MouseArea{
        anchors.fill: parent
        visible: row.width&&isSelect
        propagateComposedEvents:true
        property var oldnum;
        onMouseXChanged: {
            num=Math.ceil(mouseX/(imgWidth+spacing))
            if(num<1){
               num=1
            }
        }
        onPressed: {
            oldnum = num
        }
        onReleased: {
            if(oldnum==num){
                num--
            }
            if(num<1){
               num=1
            }
        }
    }

    Component{
        id:star
        Rectangle{
            property int imgWidth:Utl.dp(13)
            property int id:0
            width: imgWidth
            height: width
            color:Color.Clear
            Image {
                anchors.fill: parent
                source: id<num?imgUrl:imgUrl2
            }
        }
    }
}

