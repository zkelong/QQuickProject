.pragma library

var StatusOk = 200;

var debug = false

var preHandle = null //发送前的预处理函数 function(http)
var endHandle = null //数据返回后的处理函数

/*
使用get方式发送http请求
@param callback function(status, http)
*/
function sendParamsByGET(url, obj, callback){
    if (typeof obj == "function"){
        callback = obj;
        obj = null;
    }

    var http = _createRequest(callback);
    http.open("GET", url);
    http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    if(preHandle){
        preHandle(http)
    }

    if(obj){
        if(url.indexOf("?") == -1){
            url += "?"
        } else {
            url += "&"
        }
        var first = true;
        for(var key in obj){
            if(first){
                first = false;
            } else {
                url += "&"
            }

            url += key + "=" + encodeURIComponent(obj[key])
        }
    }
    if(debug)
        console.log("GET: " + http.id + " " + url)
    http.send(null);
    return http;
}

//使用post方式发送http请求
function sendParamsByPOST(url, obj, callback){
    if (typeof obj == "function"){
        callback = obj;
        obj = null;
    }

    var http = _createRequest(callback);
    http.open("POST", url);
    http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    if(preHandle){
        preHandle(http)
    }

    var data = null;
    if(obj){
        data = ""
        var first = true;
        for(var key in obj){
            if(first){
                first = false;
            } else {
                data += "&"
            }

            data += key + "=" + encodeURIComponent(obj[key])
        }
    }
    if(debug)
        console.log("POST: " + http.id + " " + url + "\n" + data)
    http.send(data);
    return http;
}

//发送json数据
function sendJson(url, obj, callback){
    if (typeof obj == "function"){
        callback = obj;
        obj = null;
    }
    if(debug)
        for(var key in obj){
            console.log(key + ":" + obj[key])
        }

    var http = _createRequest(callback);
    http.open("POST", url);
    http.setRequestHeader("Content-Type", "application/json");
    if(preHandle){
        preHandle(http)
    }
    if(debug)
        console.log("JSON: " + http.id + " " + url + "\n" + obj?JSON.stringify(obj):"")
    http.send(JSON.stringify(obj));
    return http;
}

//发送原始数据
function sendRaw(url, data, callback){
    if (typeof data == "function"){
        callback = obj;
        data = null;
    }

    var http = _createRequest(callback);
    http.open("POST", url);
    http.setRequestHeader("Content-Type", "application/octet-stream");
    if(preHandle){
        preHandle(http)
    }
    if(debug)
        console.log("RAW: " + http.id + " " + url + "\n" + data)
    http.send(data);
    return http;
}

function _createRequest(callback){
    var http = new XMLHttpRequest();
    http.id = Date.now().valueOf();
    http.onreadystatechange = function(){
        if (http.readyState === XMLHttpRequest.OPENED ){
            http.setRequestHeader("platform", Qt.platform.os);
        } else if (http.readyState === XMLHttpRequest.DONE){
            if(endHandle){
                endHandle(http)
            }

            if(debug){
                console.log("\n\n================================\n")
                console.log("RESPONSE: " + http.status + " id:" + http.id + " LEN:" + http.responseText.length)
                console.log(http.responseText)
                console.log("headers :" + JSON.stringify(http.getAllResponseHeaders()))
                console.log("\n================================\n\n")
            }

            if(callback){
                callback(http.status, http)
            }
        }
    }
    http.json = function(){
        if(http.responseText){
            return JSON.parse(http.responseText)
        }
        return null;
    }

    http.text = function(){
        return http.responseText;
    }

    return http;
}

