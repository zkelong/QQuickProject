import QtQuick 2.0
import KHttp 1.0
pragma Singleton

QtObject {
    id:root


    property Component httpCmp: Component{
        Http{
            id:http
            function json(){
                if(http.responseText){
                    return JSON.parse(http.responseText)
                }
                return null;
            }

            function text(){
                return http.responseText;
            }

            function getResponseHeader(name){
                return http.responseHeader(name)
            }

            function setRequestHeader(name, header){
                http.setHeader(name, header);
            }
        }
    }


    /**
      * 创建一个http请求
      * @param options [可选]可选配置，如果是函数则为完成后的回调函数，如果是对象，则可设置以下属性
      {
        params: [可选]要发送的query参数 key,value对象
        body: [可选]要发送的原始body字符串,如果设置将会忽略params和files
        files: [可选]要上传的文件，{name:path}，name对应字段名,path对应文件路径
        headers: [可选]要添加的header key,value对象
        stateChangeCallback: [可选]状态变化的回调 function(http)
        finishedCallback: [可选]请求完成后的回调 function(http)
      }
    */
    function createRequest(method, url, options){
        var params = null;
        var body = null;
        var files = null;
        var headers = null;
        var finishedCallback = null;
        var stateChangeCallback = null;

        if(options){
            var t = typeof options;
            if(t === "function"){
                finishedCallback = options;
            } else if(t === "object") {
                finishedCallback = options["finishedCallback"];
                stateChangeCallback = options["stateChangeCallback"];
                headers = options["headers"];
                params = options["params"];
                body = options["body"];
                files = options["files"];
            }
        }

        var http = httpCmp.createObject();

        http.stateChanged.connect(function(){
            if(stateChangeCallback) stateChangeCallback(http);
            if(http.state === Http.Done){
                if(finishedCallback) finishedCallback(http);
                http.destroy();
            }
        });

        http.open(method, url);

        var k;
        if(headers){
            for(k in headers){
                http.setHeader(k, headers[k]);
            }
        }

        if(body){
            http.setBody(body);
        } else {
            if(params){
                for(k in params){
                    http.addField(k, params[k]);
                }
            }

            if(files){
                for(k in files){
                    http.addFile(k, files[k]);
                }
            }
        }



        return http;
    }


    /**
      * 发送get请求
      * @param options [可选]可选配置，如果是函数则为完成后的回调函数，如果是对象，则可设置以下属性
      {
        params: [可选]要发送的query参数 key,value对象
        headers: [可选]要添加的header key,value对象
        finishedCallback: [可选]请求完成后的回调
      }
    */
    function get(url, options){
        var http = createRequest("get",url, options);
        http.send();
    }


    /**
      * 发送post请求
      * @param options [可选]可选配置，如果是函数则为完成后的回调函数，如果是对象，则可设置以下属性
      {
        params: [可选]要发送的query参数 key,value对象
        body: [可选]要发送的原始body字符串,如果设置将会忽略params和files
        files: [可选]要上传的文件，{name:path}，name对应字段名,path对应文件路径
        headers: [可选]要添加的header key,value对象
        finishedCallback: [可选]请求完成后的回调
      }
    */
    function post(url, options){
        var http = createRequest("post", url, options);
        http.send();
    }

}

