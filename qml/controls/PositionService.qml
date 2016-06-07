import QtQuick 2.4
import QtPositioning 5.4
import QtLocation 5.4
import "./network.js" as JSNet

/* 地址服务
{
"city": "北京市",
"country": "中国",
"direction": "附近",
"distance": "7",
"district": "海淀区",
"province": "北京市",
"street": "中关村大街",
"street_number": "27号1101-08室",
"country_code": 0
}
*/

//取得经纬度
PositionSource {
    id: posSrc
    property bool geocoding: false  //是否在取得经纬度后编码再取得地址信息
    property var fullAddress: null  //完整地址
    property var address: null  //格式见上面注释
    property bool loading: false    //是否正在加载中

    updateInterval: 1200000
    active: false

    onPositionChanged: {
        var coord = posSrc.position.coordinate;
        if(geocoding && (coord.longitude || coord.latitude)){
            posSrc.doGeocoding(coord.longitude,coord.latitude)
        }
        console.log("Coordinate:", coord.longitude, coord.latitude);
    }

    //将经纬度反编码为地址信息
    function doGeocoding(longitude,latitude){
        if(loading)
            return;
        loading = true;
        //坐标转换API Web服务API
        var url = "http://api.map.baidu.com/geocoder/v2/?ak=o6QG2MnnE5myqLUA5uvb0RGW&output=json&pois=0&location=" + latitude + "," + longitude
        JSNet.sendParamsByGET(url, function(code,http){
            loading = false;
            var obj = http.json();
            if(obj && obj.status === 0){
                posSrc.fullAddress = obj.result.formatted_address;
                posSrc.address = obj.result.addressComponent;
            }
        });
    }
}
