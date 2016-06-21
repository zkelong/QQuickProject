import QtQuick 2.0
import QtQuick.Controls 1.3

import "../../controls"

View {
    id: root

    //年龄
    property int age:0;
    property int select_year: thisYear
    property int select_month: 1;
    property int select_day: 1;
    //今夕是何年
    property var date : new Date()
    property int thisYear: date.getFullYear()
    //是否是闰年
    property bool isleapyear;

    Rectangle{
        anchors.top: titleBar.bottom
        width: parent.width
        height: parent.height - titleBar.height
        anchors.left: parent.left
        color: "transparent"

        Component.onCompleted:{
            loadList()
        }
        Rectangle{
            id: year;
            width: parent.width/3
            height: parent.height
            anchors.left: parent.left
            anchors.top: parent.top
            color: "transparent"

            VLineScalePathView{
                id: years_pathview;
                delegate: delegate;
                model: years;
                Component.onCompleted:{
                    years_pathview.currentIndex = 18 //默认选择项
                }
                onCurrentIndexChanged: {
                    //今年-index，获得年份
                    var m = thisYear - years_pathview.currentIndex
                    age = years_pathview.currentIndex
                    select_year = m
                    if (m % 4 == 0)
                    {
                        if (m % 100 == 0)
                        {
                            if (m % 400 == 0) {   //能被400整除的,是闰年
                                isleapyear = true;
                            } else {  //能被100整除,但不能被400整除的,不是闰年
                                isleapyear = false;
                            }
                        } else {   //能被4整除,但不能被100整除的,不是闰年
                            isleapyear = true;
                        }
                    } else {  //不能被4整除的,不是闰年
                        isleapyear = false;
                    }
                }
            }
        }
        Rectangle{
            id: month;
            width: parent.width/3
            height:parent.height
            anchors.left: year.right
            anchors.top: parent.top
            color: "transparent"
            VLineScalePathView{
                id: month_pathview;
                delegate: delegate;
                model: months;
                onCurrentIndexChanged: {
                    select_month=month_pathview.currentIndex+1
                    //根据月份不同,对应的日期可选范围发生变化
                    if(1 == month_pathview.currentIndex){
                        if(isleapyear){
                            days.remove(30)
                            days.remove(29)
                        }else{
                            days.remove(30)
                            days.remove(29)
                            days.remove(28)
                        }
                    }if(3 == month_pathview.currentIndex
                            ||5 == month_pathview.currentIndex
                            ||8 == month_pathview.currentIndex
                            ||10 == month_pathview.currentIndex){
                        if(days.count == 31){
                            days.remove(30)
                        }
                    }if(0 == month_pathview.currentIndex
                            ||2 == month_pathview.currentIndex
                            ||4 == month_pathview.currentIndex
                            ||6 == month_pathview.currentIndex
                            ||7 == month_pathview.currentIndex
                            ||9 == month_pathview.currentIndex
                            ||11 == month_pathview.currentIndex){
                        if(days.count == 30){
                            days.append({list: "31日"})
                        }
                        if(days.count == 29){
                            days.append({list: "30日"})
                            days.append({list: "31日"})
                        }
                        if(days.count == 28){
                            days.append({list: "29日"})
                            days.append({list: "30日"})
                            days.append({list: "31日"})
                        }
                    }
                }
            }
        }
        Rectangle{
            id: day;
            width: parent.width/3
            height:parent.height
            anchors.right: parent.right
            anchors.top: parent.top
            color: "transparent"
            VLineScalePathView{
                id: days_pathview;
                delegate: delegate;
                model: days;
                onCurrentIndexChanged: {
                    select_day=days_pathview.currentIndex+1
                }
            }
        }
        Component {
            id: delegate
            Rectangle {
                id: root
                width: parent.width
                height: 20
                color: "transparent"
                z: PathView.zOrder;
                scale: PathView.itemScale;
                property bool isCurrentItem: root.PathView.isCurrentItem

                Text {
                    id:_text
                    anchors.centerIn: parent;
                    font.pointSize: 12
                    text: list;
                    color: isCurrentItem ? "#363636" : "#b3b3b3";
                }
            }
        }


        function loadList() {
            for(var y = thisYear; y > thisYear-151; y--){
                years.append({list:y+"年"})
            }
            for(var m = 1;m <= 12; m++){
                months.append({list:m+"月"})
            }
            for(var d = 1; d <= 31; d++){
                days.append({list:d+"日"})
            }
        }
        ListModel {
            id: years
        }
        ListModel {
            id: months
        }
        ListModel {
            id: days
        }
    }

    TitleBar {
        id: titleBar
        anchors.top: parent.top; anchors.left: parent.left
        onClicked: {
            root.navigationView.pop()
        }
    }
}
