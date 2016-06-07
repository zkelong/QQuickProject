import QtQuick 2.0
import QKit 1.0
import KHttp 1.0
pragma Singleton

QtObject {
    id:root

    property var preHandle: null //发送前的预处理函数 function(http)
    property var endHandle: null //数据返回后的处理函数 function(http)

    /*
      使用get方式发送http请求
      @param callback function(status, http)
      */
    function sendParamsByGET(url, obj, callback){
        if (typeof obj == "function"){
            callback = obj;
            obj = null;
        }
        var http;
        var opt = {
            headers:{"content-type":"application/x-www-form-urlencoded; charset=utf-8"},
            params:obj,
            stateChangeCallback:function(http){
                if(http.state === Http.Opened){
                    if(root.preHandle) root.preHandle(http);
                } else if(http.state === Http.Done){
                    if(root.endHandle) root.endHandle(http);
                }
            },
            finishedCallback:function(http){
                console.log("\n\n================================\n")
                console.log("URL:"+url)
                console.log("RESPONSE: " + http.status + " LEN:" + http.responseText.length)
                console.log(http.responseText)
                console.log("\n================================\n\n")
                if(callback) callback(http.status, http);
            }
        };

        http = Request.get(url, opt);
        return http;
    }


    //使用post方式发送http请求
    function sendParamsByPOST(url, obj, callback){
        if (typeof obj == "function"){
            callback = obj;
            obj = null;
        }
        var http;
        var opt = {
            headers:{"content-type":"application/x-www-form-urlencoded; charset=utf-8"},
            params:obj,
            stateChangeCallback:function(http){
                if(http.state === Http.Opened){
                    if(root.preHandle) root.preHandle(http);
                } else if(http.state === Http.Done){
                    if(root.endHandle) root.endHandle(http);
                }
            },
            finishedCallback:function(http){
                console.log("\n\n================================\n")
                console.log("URL:"+url)
                console.log("RESPONSE: " + http.status + " LEN:" + http.responseText.length)
                console.log(http.responseText)
                console.log("\n================================\n\n")
                if(callback) callback(http.status, http);
            }
        };

        http = Request.post(url, opt);
        return http;
    }

    /**
     * 上传文件
     * @param url
     * @param params 附加参数
     * @param files  要上传的文件,key为字段名 value为文件路径 {name: path}
     * @param callback
     */
    function uploadFile(url, params, files, callback){

        var http;
        var opt = {
            params:params,
            files:files,
            stateChangeCallback:function(http){
                if(http.state === Http.Opened){
                    if(root.preHandle) root.preHandle(http);
                } else if(http.state === Http.Done){
                    if(root.endHandle) root.endHandle(http);
                }
            },
            finishedCallback:function(http){
                console.log("\n\n================================\n")
                console.log("URL:"+url)
                console.log("RESPONSE: " + http.status + " LEN:" + http.responseText.length)
                console.log(http.responseText)
                console.log("\n================================\n\n")
                if(callback) callback(http.status, http);
            }
        };

        http = Request.post(url, opt);
        return http;
    }

    //发送json数据
    function sendJson(url, obj, callback){
        if (typeof obj == "function"){
            callback = obj;
            obj = null;
        }
        for(var key in obj){
            console.log(key + ":" + obj[key])
        }
        var http;
        var opt = {
            headers:{"content-type":"application/json; charset=utf-8"},
            body:JSON.stringify(obj),
            stateChangeCallback:function(http){
                if(http.state === Http.Opened){
                    if(root.preHandle) root.preHandle(http);
                } else if(http.state === Http.Done){
                    if(root.endHandle) root.endHandle(http);
                }
            },
            finishedCallback:function(http){
                console.log("\n\n================================\n")
                console.log("URL:"+url)
                console.log("RESPONSE: " + http.status + " LEN:" + http.responseText.length)
                console.log(http.responseText)
                console.log("\n================================\n\n")
                if(callback) callback(http.status, http);
            }
        };

        http = Request.post(url, opt);
        return http;
    }
}

