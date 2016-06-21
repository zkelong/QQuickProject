import QtQuick 2.0
import "../controls"
import "../toolsbox/storage.js" as Storage
import "../toolsbox/tools.js" as Tools
import "../toolsbox/api.js" as JSApi
pragma Singleton

/**
*用户接口
*功能：
*1.用户注册
*2.用户登录
*3.获取用户基础信息
*4.更新用户基础信息
*基础信息内容：
*int64      "id"    //"用户id"
*int64      "ad"    //"来自于哪个app"
*string     "un"    //"用户名,用于登录"
*string     "em"    //"邮箱,用于登录"
*string     "ph"    //"手机号"
**string     "-"      //"密码"
*OSType     "rs"     //"注册时的平台"
*OSType     "ls"     //"最后一次登录的平台"
*UserStatus "st"     //"用户状态"
*string     "nk"     //"用户昵称"
*string     "hd"     //"用户头像"
*SexType    "sx"     //"性别"
*Timestamp  "bd"     //"生日"
*string     "pr"     //"所在省名"
*string     "ci"     // "所在市名"
*[]float64  "lo"     //"纬度/经度"
}
*/

QtObject{
    id:root


 ////////////////////////////////////////////////////////////////////
    //个人信息服务器地址--注册、登陆、用户头像
    property string serverUrl: ""
    //头像文件上传地址
    property string headServerUrl: ""

    //token
    property var userToken: null
    //用户账号
    property var accountId: null
    //用户信息-登录信息：{id: 用户id唯一标识(string), tk: token(string), fl: (bool)第一次登录,第三方登录有效}
    //用户信息-基本信息：头像等
    property var userLoginInfo: null

    onUserTokenChanged: {   //两边token一致
        JSApi.userToken = userToken
    }


    Component.onCompleted: {
        Net.preHandle = function (http) {
            if (userToken) {
                http.setRequestHeader("tk", userToken)
            }
        }
        Net.endHandle = function (http) {
            if (http.status === 403) {
                loginOut()
                //JSApi._mainForm.showLogin()
            }
        }
    }

    ///////////----登陆模块----///////////

    //退出登陆
    function loginOut() {
        userToken = null
        userLoginInfo = null
        JSApi.loginedUserInfo = null
        if(accountId) //保存账号信息
            Storage.setValue("account", {id: accountId})
        else
            Storage.setValue("account", null)
        //用户的一起搞应用账户信息清除
    }

    //加载用户上次登陆信息
    function loadLoginUser(callback) {
        Storage.getValue("account", function (value) {
            if (value && value.ac && value.pw) {
                accountId = value.ac
                userLogin(value.os, value.ac, value.pw, callback)   //登陆
            }
        })
    }

    //获取短信验证码
    function userMessageCode(data, callback) {
        Net.sendJson(serverUrl + "/service/phone/verify", data, function (code, http) {
            callback(http.json())
        })
    }

    //使用手机注册新用户
    function userRegisterByPhone(data, callback) {
        Net.sendJson(serverUrl + "/user/register/phone", data,
                     function (code, http) {
                         callback(http.json())
                     })
    }

    //登录
    function userLogin(osType, account, password, callback) {
        Net.sendJson(serverUrl + "/user/login/account", {
                         os: osType,
                         ac: account,
                         pw: password
                     }, function (code, http) {
                         var ret = http.json()  //{"id":597***53713,"tk":"7bcncg***p8el6m8g","fl":false}
                         if (ret) {
                             userToken = ret.tk  //token
                             userLoginInfo = ret  //{id: 用户id唯一标识(string), tk: token(string), fl: (bool)第一次登录,第三方登录有效}
                             if(JSApi.loginedUserInfo == null)  //JSApi.loginedUserInfo包含有App应用数据
                                 JSApi.loginedUserInfo = userLoginInfo
                             else {
                                 JSApi.loginedUserInfo.id = userLoginInfo.id
                             }
                             accountId = account
                             Storage.setValue("account", {  //保存登陆信息
                                                  os: osType,
                                                  ac: account,
                                                  pw: password
                                              })
                             //console.log("userLoginInfo...", JSON.stringify(JSApi.loginedUserInfo))
                         }
                         callback(ret)
                     })
    }

    //重置密码
    function userResetPassWord(data, callback) {
        Net.sendJson(serverUrl + "/user/pwd/phone", data, function (code, http) {
            callback(http.json())
        })
    }

    //修改密码
    function userUpdatePassword(data, callback) {
        Net.sendJson(serverUrl + "/user/changepw", data, function (code, http) {
            callback(http.json())
        })
    }

    //获取用户登陆资料
    function userGetInfo(callback) {
        Net.sendParamsByGET(serverUrl + "/user/profile/get/" + userLoginInfo.id, function (code, http) {
            var obj = http.json();
            callback(obj) //手机注册用户：{id: 59774053713, ph: "18328406490", st: 1}
        })
    }

    //获取用户的基础资料资料
    function userGetBaseInfo(callback) {
        Net.sendParamsByGET(serverUrl + "/user/profile/base/" + userLoginInfo.id, function (code, http) {
            var obj = http.json();
            if(obj){
                for(var key in obj){
                    JSApi.loginedUserInfo[key] = obj[key]    //用户信息存起来
                }
                //console.log("userLoginInfo...", JSON.stringify(JSApi.loginedUserInfo))
            }
            callback(obj)
        })
    }

    //更新用户信息
    function userUpdate(data, callback) {
        console.log("updateUrl...", serverUrl + "/user/profile/update")
        Net.sendJson(serverUrl + "/user/profile/update", data, function (code, http) {
            callback(http.json())
        })
    }

    //上传文件
    //callback function(url)
    function uploadHeadImage(filePath, callback){
        Net.sendParamsByGET(serverUrl + "/service/upload/token", function(code, http){//先取token
            if(code !== 200){
                return callback(null);
            }
            var tokenx = http.text();
            Net.uploadFile(headServerUrl, {token:tokenx}, {file:filePath}, function(code, http){
                if(http) {
                    callback(http.json())
                } else {
                    callback(null)
                }
            });
        });
    }

    /////////////////////----下面的是嗒嗒的东西----//////////////////////
/*

    function loadLoginUser() {
        //        appGetConfig()
        Storage.getValue("userLoginInfo", function (value) {
            if(value){
                userLoginInfo=value.userLoginInfo
            }
        })
        Storage.getValue("account", function (value) {
            if(value && value.type){
                console.log("自动进行第三方登录")
                userSocialLogin(value.type,value.sid,value.token,value.expire,function(obj){})
            }
            if(value && value.uname && value.pwd){
                console.log("自动进行登录")
                userLogin(value.uname,value.pwd,function(obj){
                    if(!obj){
                        console.log("自动登录失败")
                        platformType=null
                        loginOut()
                        Tools.userView.updataSideView()
                        Tools.getMainWindow().navigationView.push("qrc:/qml/login/Login.qml")
                        Tools.showTip(qsTr("网络错误,请重新登录"))
                        return;
                    }
                    if(obj.uid){
                        console.log("自动登录成功")
                        userGetInfo(function(){})
                    }else if(obj.statusCode==500){
                        console.log("自动登录失败")
                        platformType=null
                        loginOut()
                        Tools.userView.updataSideView()
                        Tools.getMainWindow().navigationView.push("qrc:/qml/login/Login.qml")
                        Tools.showTip(qsTr("服务器错误，请重新登录"))
                        return;
                    }
                })
            }
        })
    }


    //////////// ------ 用户模块 ---------- ////////////
    //使用手机注册新用户
    function userRegisterByPhone(data, callback) {
        Net.sendParamsByPOST(serverUrl + "/user/signup/phone", data,
                             function (code, http) {
                                 callback(http.json())
                             })
    }

    //修改用户密码
    function userChangePw(Phone,Code,Password, callback) {
        Net.sendParamsByPOST(serverUrl + "/user/changepw",{
                                 phone: Phone,
                                 verifyCode: Code,
                                 password: Password,
                             },
                             function (code, http) {
                                 callback(http.json())
                             })
    }

    //更新用户信息
    function userUpdate(data, callback) {
        Net.sendParamsByPOST(serverUrl + "/user/info/update", data, function (code, http) {
            var ret = http.json()
            if(code === 200){
                userGetInfo(function(obj){
                    if(obj && obj.userId){
                        callback(ret)
                    }else{
                        callback(obj)
                    }
                })
            }else{
                callback(ret)
            }
        })
    }


    //获取用户资料
    function userGetInfo(callback) {
        Net.sendParamsByGET(serverUrl + "/user/info/get", function (code, http) {
            var ret = http.json()
            if (code === 200) {
                console.log("head:ret.head," + ret.head)
                userLoginInfo = ({
                                       userId:ret.userId,
                                       nickname:ret.nickname,
                                       head:ret.head,
                                       sex:ret.sex,
                                       birthday:ret.birthday,
                                       countryId:ret.countryId,
                                       district:ret.district,
                                       latitude:ret.latitude,
                                       longitude:ret.longitude,
                                   })

                console.log("获取用户资料时accountPhone" +accountPhone + "##" +ret.phone)
                Tools.userView.updataSideView()
                Storage.setValue("userLoginInfo", {
                                     userLoginInfo:userLoginInfo
                                 })
            }
            callback(ret)
        })
    }

    //获取指定用户资料
    function callUserGetInfo(id,callback) {
        console.log("获取来电用户资料")
        Net.sendParamsByGET(serverUrl + "/user/info/get?id="+id,function (code, http) {
            if(code === 200){
                callback(http.json())
            }else{
                callback(null)
            }
        })
    }

    //登录
    function userLogin(Phone,password, callback) {
        Net.sendParamsByPOST(serverUrl + "/user/login/phone", {
                                 platform:Qt.platform.os,
                                 phone: Phone,
                                 password: password
                             }, function (code, http) {
                                 var ret = http.json()

                                 if (ret && ret.uid) {
                                     accountPhone=Phone
                                     console.log( Phone +"登录成功==========用户ID:" + ret.uid + " accountPhone="+accountPhone)
                                     Storage.setValue("account", {
                                                          uname: Phone,
                                                          pwd: password,
                                                      })

                                     userLoginProcessing(http)
                                 }
                                 callback(ret)
                             })
    }

    //处理登录信息
    function userLoginProcessing(http){
        var ret = http.json()
        accountId = ret.uid
        isSeller = ret.isSeller
        isAcceptOrder=ret.isAcceptOrder
        userToken = http.getResponseHeader("token")
        console.log("userToken: "+userToken)
        loginedUserSip = ({
                              sip_user:ret.uid,
                              sip_init:ret.init,
                              sip_password:ret.password,
                              sip_host:ret.host,
                              sip_port:ret.port
                          })
        Tools.userView.updataSideView()
        Tools.sellerView.getsellerProfile()
        QSip.registerAccount(ret.uid,ret.password,ret.host+":"+ret.port);
        updateUserStatus(1,function(){})
        JPush.setAlias(accountId.toString())
        sysmsgGetInfoNum()
    }

    // 第三方帐号登录
    function userSocialLogin(type,sid,token,expire,callback) {
        Net.sendParamsByPOST(serverUrl + "/user/social/login",
                             {
                                 platform:Qt.platform.os,
                                 type:type,
                                 sid:sid,
                                 token:token,
                                 expire:expire,
                             },
                             function (code, http) {
                                 var ret = http.json()
                                 if (ret && ret.uid) {
                                     platformType = type
                                     accountPhone=ret.phone
                                     console.log(ret.phone + "第三方登录成功==========用户ID:" + ret.uid)
                                     Storage.setValue("account", {
                                                          type:type,
                                                          sid:sid,
                                                          expire:expire,
                                                          token:token
                                                      })
                                     userLoginProcessing(http)
                                 }
                                 callback(ret)
                             })
    }

    //第三方 手机绑定
    function bindingUserSocial(phone,verifyCode,callback){
        Net.sendParamsByPOST(serverUrl + "/user/social/binding",
                             {
                                 phone:phone,
                                 verifyCode:verifyCode,
                             },
                             function (code, http){
                                 console.log("第三方绑定手机号:---"  + phone)
                                 accountPhone=phone
                                 callback(http.json())
                             })
    }

    //更新用户的在线状态
    function updateUserStatus(status,callback){
        Net.sendParamsByPOST(serverUrl + "/user/status",
                             {status:status},
                             function (code, http){
                                 console.log("更改用户的在线状态:---" + status)
                                 callback(http.json())
                             })
    }

    //获取消费者余额和可提现金额
    function buyerGetBalance(callback){
        Net.sendParamsByGET(serverUrl + "/user/balance/get",
                            function (code, http) {
                                if(code===200){
                                  callback(http.json())
                                }else{
                                  callback(null)
                                }
                            })
    }

    //获取收支明细
    function buyerGetDetail(page,size,callback){
        Net.sendParamsByGET(serverUrl + "/user/balance/detail?page="+page+"&size="+size,
                            function (code, http) {
                                callback(http.json())
                            })
    }

    //////////// ------ 服务模块 ---------- ////////////

    //发送手机验证码(lemon)
    function userCodeByPhone(type,Phone, callback) {
        Net.sendParamsByPOST(serverUrl + "/service/verifyCode",{
                                 type:type,
                                 phone: Phone,
                             },
                             function (code, http) {
                                 callback(http.json())
                             })
    }
    //检查手机验证码
    function userServiceCheckCode(type,Phone,Code, callback) {
        Net.sendParamsByPOST(serverUrl + "/service/checkCode",{
                                 type:type,
                                 phone: Phone,
                                 verifyCode:Code,
                             },
                             function (code, http) {
                                 callback(http.json())
                             })
    }
    //获取地区信息接口
    function serviceGetDistrict(province, callback) {
        Net.sendParamsByPOST(serverUrl + "/service/district",province,
                             function (code, http) {
                                 if(code===200){
                                     console.log("获取地区信息成功")
                                     callback(http.json())
                                 }else{
                                     callback(null)
                                 }
                             })
    }
    //提交反馈信息接口
    function serviceFeedbackSend(content, callback) {
        Net.sendParamsByPOST(serverUrl + "/service/feedback",{content:content},
                             function (code, http) {
                                 if(code===200){
                                     console.log("提交反馈信息成功")
                                     callback(http.json())
                                 }else{
                                     callback(null)
                                 }
                             })
    }
    //举报投诉
    function complaintPost(targetId,content, callback) {
        Net.sendParamsByPOST(serverUrl + "/seller/complaint",
                             {sellerId:targetId,content:content},
                             function (code, http) {
                                 if(code===200){
                                     console.log("举报成功")
                                     callback(http.json())
                                 }else{
                                     callback(null)
                                 }
                             })
    }
    //上传文件
    //callback function(url)
    function uploadFile(filePath, callback){
        Net.sendParamsByGET(serverUrl + "/service/uptoken", function(code, http){//先取token
            if(code !== 200){
                return callback(null);
            }
            var token = http.json().token;
            Net.uploadFile("http://upload.qiniu.com", {token:token}, {file:filePath}, function(code, http){
                if(code === 200){
                    console.log("http://static.dada.17cxq.com/" + http.json().key);
                    callback("http://static.dada.17cxq.com/" + http.json().key);
                }else {
                    callback(null);
                }
            });

        });
    }

    //////////// ------ 充值模块 ---------- ////////////
    //获取充值项目列表
    function rechargeGetItems(id,callback){
        Net.sendParamsByGET(serverUrl + "/recharge/items?type="+id,
                            function (code, http) {
                                if(code===200){
                                   console.log("获取充值项目列表成功")
                                   callback(http.json())
                                }else{
                                   callback(null)
                                }
                            })
    }

    //生成订单
    function rechargeOrderPost(id, callback) {
        Net.sendParamsByPOST(serverUrl + "/recharge/order",
                             {id:id},
                             function (code, http) {
                                 if(code===200){
                                     console.log("生成订单成功")
                                     callback(http.json())
                                 }else{
                                     callback(null)
                                 }
                             })
    }

    //检查充值结果
    function rechargeCheckPost(data, callback) {
        Net.sendJson(serverUrl + "/recharge/check",data,
                             function (code, http) {
                                 if(code===200){
                                     console.log("检查充值结果成功")
                                     callback(http.json())
                                 }else{
                                     console.log("检查充值结果失败")
                                     callback(null)
                                 }
                             })
    }
    //获取充值记录
    function rechargeGetList(page,size,callback){
        Net.sendParamsByGET(serverUrl + "/recharge/list?page="+page+"&size="+size,
                            function (code, http) {
                                if(code===200){
                                   console.log("获取充值项目列表成功")
                                   callback(http.json())
                                }else{
                                   callback(null)
                                }
                            })
    }
    */
}

