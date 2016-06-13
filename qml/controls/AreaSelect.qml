import QtQuick 2.0
import "../toolsbox/color.js" as Color
import "../toolsbox/font.js" as FontUtl
import "../toolsbox/config.js" as Config

/**
  *选择省市信息--众筹星球里用的那个
  *
  */
Rectangle {
    id: root
    clip: true
    anchors.fill: parent
    color: "#15000000"
    visible: false

    /*用户选择，idx-0取消；1-确定--返回数据
      *idx: 返回的操作编号
      *proId: 省份id
      *proName: 省份名称
      *cityId: 市的名称
      *cityName: 市的名字
      */
    signal itemSelected(int idx, int proId, string proName, int cityId, string cityName);

    //选择的省市
    property int preSelectProId: -1     //预选的省id
    property string preSelectProName: ""    //预选的省名称
    property int preSelectIdCity: -1        //预选得市id
    property string preSelectNameCity: ""   //预选得市名称
    property var locationData: ({})         //加载已选好的数据
    property int provenceCurrentIndex: 0    //已选好的省行
    property int cityCurrentIndex: 0        //已选好的市行

    property string selectPlace: ""         //省市名字
    property int marginSize: Utl.dp(10)
    property int cellHeight: Utl.dp(45)
    property int radiusSize: Utl.dp(8)

    function show() {   //显示
        root.visible = true
    }

    function hide() {   //隐藏
        root.visible = false
    }

    Component.onCompleted: {
        loadProvince()
    }

    onVisibleChanged: {
        _listViewProvince.currentIndex = -1
        listCity.clear()
        selectPlace = ""
        root.preSelectProId = -1
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    Rectangle{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: _choiceButton.bottom
        anchors.bottom: parent.bottom

        Rectangle { //省
            id: _province
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width / 3
            color: "#f6f6f6"

            ListView{
                id: _listViewProvince
                anchors.fill: parent
                clip: true
                currentIndex: -1

                model: listProvince
                delegate: delegate_listViewProvince
            }
        }

        Rectangle { //市
            id: _city
            anchors.top: parent.top
            anchors.left: _province.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: "#eeeeee"

            ListView{
                id: _listViewCity
                anchors.fill: parent
                clip: true
                currentIndex: -1

                model: listCity
                delegate: delegate_listViewCity
            }
            //进度条
            BusyView{
                id:buyview1
            }
        }
    }

    ListModel {
        id: listProvince
    }

    ListModel {
        id: listCity
    }

    Component { //省 列表
        id: delegate_listViewProvince
        Rectangle{
            id:_section1
            anchors.left: parent.left
            anchors.right: parent.right
            height: cellHeight
            color: Color.White

            //选中时的背景
            Image {
                anchors.fill: parent
                source: (_listViewProvince.currentIndex == index) ? "qrc:/res/area_provence.jpg" : ""
            }

            Text{
                id: _cellText
                width: parent.width - marginSize
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: marginSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pointSize: FontUtl.ListShowFontSize
                color: (_listViewProvince.currentIndex == index) ? "#be6239" : Color.Black
                elide: Text.ElideRight
                text: provinceName
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    _listViewProvince.currentIndex = index
                    loadCity(provinceId)
                    _listViewCity.currentIndex = -1
                    root.preSelectProName = provinceName
                    root.preSelectProId = provinceId
                    root.preSelectIdCity = -1
                    selectPlace = ""
                    selectPlace = _cellText.text
                    locationData = {}
                }
            }

            Line {
                anchors.right: parent.right
                height: parent.height
                width: Utl.dp(1)
            }

            Line {
                anchors.bottom: parent.bottom
                color: "#d5d3d3"
            }
        }
    }

    Component { //市 列表
        id: delegate_listViewCity
        Rectangle{
            id:_section1
            anchors.left: parent.left
            anchors.right: parent.right
            height: cellHeight
            color: "transparent"

            //选中时的背景
            Image {
                anchors.fill: parent
                source: (_listViewCity.currentIndex == index) ? "qrc:/res/area_city.jpg" : ""
            }

            Text{
                id: _cellText
                width: parent.width - marginSize
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: marginSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pointSize: FontUtl.ListShowFontSize
                color: (_listViewCity.currentIndex == index) ? "#be6239" : Color.Black
                elide: Text.ElideRight
                text: cityName
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    _listViewCity.currentIndex = index
                    root.preSelectIdCity = cityId
                    root.preSelectNameCity = cityName
                    selectPlace = ""
                    selectPlace = root.preSelectProName + qsTr(" ") + root.preSelectNameCity
                }
            }
        }
    }

    //加载省份信息
    function loadProvince() {
        buyview.running = true
        Api.addressGetProvince(function(obj) {
            buyview.running = false
            if(obj && obj.d) {
                for(var i = 0; i < obj.d.length; i++) {
                    listProvince.append({provinceId:obj.d[i].id, provinceName:obj.d[i].pn})
                    //设置已选择好的省信息
                    if(locationData && locationData.provenceId == obj.d[i].id) {
                        provenceCurrentIndex = i;
                        preSelectProId = obj.d[i].id;
                        preSelectProName = obj.d[i].pn;
                    }
                }
            } else {
                tip.content = qsTr("加载失败")
                tip.show()
            }

            //加载市信息
            if(locationData && locationData.provenceId) {
                console.log("locationDate*********")
                _listViewProvince.currentIndex = provenceCurrentIndex
                loadCity(locationData.provenceId)
            } else {
                console.log("locationDate*********1111111111111111111111111")
            }
        })
    }
    //加载市的信息
    function loadCity(pid) {
        buyview1.running = true
        listCity.clear()
        Api.addressGetCity(pid, function(obj){
            buyview1.running = false
            if(obj && obj.d) {
                for(var i = 0; i < obj.d.length; i++) {
                    listCity.append({cityId:obj.d[i].id, cityName:obj.d[i].cn})
                    //设置已选择好的市信息
                    if(locationData && locationData.cityId == obj.d[i].id) {
                        cityCurrentIndex = i;
                        preSelectIdCity = obj.d[i].id;
                        preSelectNameCity = obj.d[i].cn;
                    }
                }
            } else {
                tip.content = qsTr("加载失败")
                tip.show()
            }
            if(locationData && locationData.cityId) { //设置选择好的市信息
                _listViewCity.currentIndex = cityCurrentIndex
            }
        })
    }

    //按钮
    Rectangle {
        id: _choiceButton
        width: parent.width
        height: Utl.dp(50)
        anchors.top: parent.verticalCenter
        anchors.left: parent.left

        Button {
            id: btnCancel
            height: parent.height
            width:parent.width / 2
            anchors.left: parent.left
            label.text: qsTr("取消")
            label.color: Color.White//"#919191"
            font.pointSize: 21
            color: "#aaaaaa"

            onPressed: btnCancel.color = "#989898"
            onReleased: btnCancel.color = "#aaaaaa"

            onClicked: {
                buyview1.running = false
                itemSelected(0,0,"",0,"")
            }
        }

        Button {
            id: btnSure
            height: parent.height
            anchors.right: parent.right
            width: parent.width / 2
            label.text: qsTr("确定")
            font.pointSize: 21
            label.color: Color.White
            color: "#b83c09"

            onPressed: btnSure.color = "#8e3209"
            onReleased: btnSure.color = "#b83c09"

            onClicked: {
                if(root.preSelectProId == -1 || root.preSelectIdCity == -1) {
                    tip.content = qsTr("请选择完整地区")
                    tip.show()
                    return
                }
                itemSelected(1,preSelectProId,preSelectProName,preSelectIdCity,preSelectNameCity)
            }
        }

        Line {
            anchors.bottom: parent.bottom
            color: "#999898"
        }
        Line {
            anchors.top: parent.top
            color: "#999898"
        }
    }

    //上阴影
    Image {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: _choiceButton.bottom
        height: Utl.dp(3)
        source: "qrc:/res/area_top.png"
    }

    //右阴影
    Image {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: _choiceButton.bottom
        width: Utl.dp(3)
        source: "qrc:/res/area_right.png"
    }

    TipView{
        id:tip
    }

    //进度条
    BusyView{
        id:buyview
    }
}

