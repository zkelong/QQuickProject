.pragma library
.import "network.js" as JSNet
.import "storage.js" as Storage
.import "code.js" as Code


//服务器地址
var ServerUrl = ""
//文件上传地址
var UploadUrl = ServerUrl + "/service/file/up"
//头像文件的访问地址
var HeadVisitkUrl = ""

//配置信息--公司电话、qq...
var appConfig = null
var userToken = null    //token--Api.qml赋值
var loginedUserInfo = null  //用户登录信息--Api.qml赋值
var userAppInfo = null  //用户应用信息-余额等
//var accountId = null //账号


//登陆中HTTP请求前处理
JSNet.preHandle = function (http) {
    if (userToken) {
        http.setRequestHeader("token", userToken)
    }
}

var _mainForm = null
JSNet.endHandle = function (http) {
    if (http.status == 403) {   //登陆权限-掉线？？
        loginOut()
        //_mainForm.showLogin()
    }
}

//获取系统配置信息
function appGetConfig(callback) {
    if (appConfig) {
        if (callback)
            callback(appConfig)
        return
    }
    JSNet.sendParamsByGET(ServerUrl + "/service/config?pl=" + Qt.platform.os, function (code, http) {
        var obj = http.json()
        if (obj) {
            appConfig = obj
        }
        if (callback)
            callback(appConfig)
    })
}

//////////// ------ 用户基本资料模块 ----放到Api.qml中去了------ ////////////
////获取模拟验证码--应用数据服务器
//function userSimulatedCode(phone, callback) {
//    JSNet.sendParamsByGET(ServerUrl + "/service/randcode/" + phone, function (code, http) {
//        callback(http.json())
//    })
//}


//用户是否已登陆
function isLogined() {
    return (userToken != null && loginedUserInfo != null)
}

//////////// ------ 用户应用数据模块 ---------- ////////////
//获取指定用户的详细信息
function userGetInfo(callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/" + loginedUserInfo.id, function (code, http) {
        var obj = http.json();
        if(obj && obj.d){
            for(var key in obj.d){
                loginedUserInfo[key] = obj.d[key];
            }
        }
        callback(obj)
    })
}

//更新用户信息
function userUpdate(data, callback) {
    JSNet.sendJson(ServerUrl + "/user/update", data, function (code, http) {
        callback(http.json())
    })
}

//获取用户下单记录winlist
function getUseroder(pg,callback){
    JSNet.sendParamsByGET(ServerUrl + "/user/invests/" + pg,function (code,http){
        callback(http.json())
    })
}
//获取用户中奖记录
function getUserwin(pg,callback){
    JSNet.sendParamsByGET(ServerUrl + "/user/winlist/" + pg,function (code,http){
        callback(http.json())
    })
}
//提交反馈信息（lemon）
function userInvestoFeedback(data, callback) {
    JSNet.sendJson(ServerUrl + "/user/userfeedback", data, function (code, http) {
        callback(http.json())
    })
}
//用户签到
function getUserSigns(callback){
    JSNet.sendParamsByGET(ServerUrl + "/user/signin" ,function (code,http){
        callback(http.json())
    })
}
//获取用户签到记录
function getUserSign(ud,ye,mot,callback){
    JSNet.sendParamsByGET(ServerUrl + "/service/signlist/" +ud+"/" + ye +"/" + mot ,function (code,http){
        callback(http.json())
    })
}
//获得用户发布的项目
function getUserproject(ud,pg,callback){
    JSNet.sendParamsByGET(ServerUrl + "/user/projects/" +ud+"/"+pg,function (code,http){
        callback(http.json())
    })
}
//获得用户关注的项目
function getUserfocusPro(ud,pg,callback){
    JSNet.sendParamsByGET(ServerUrl + "/project/focuslist/" +ud +"/"+pg,function (code,http){
        callback(http.json())
    })
}
//获得用户项目消息
function getUserprojectMessge(pg,callback){
    JSNet.sendParamsByGET(ServerUrl + "/question/mystayask/" +pg,function (code,http){
        callback(http.json())
    })
}
//获取系统消息
function getSystemMessge(tid, page, callback){
    JSNet.sendParamsByGET(ServerUrl + "/chat/listc/" +tid +"/" + page,function (code,http){
        callback(http.json())
    })
}
//获取项目待回复/question/mystayask/
function getUserSystemMessge(pg,callback){
    JSNet.sendParamsByGET(ServerUrl + "/question/mystayask/" +pg,function (code,http){
        callback(http.json())
    })
}
//发送回复/question/answer
function setanser(data, callback) {
    JSNet.sendJson(ServerUrl + "/question/answer", data, function (code, http) {
        callback(http.json())
    })
}

//////////// ------ 一元众筹模块 ---------- ////////////

//获取一元众筹项目列表
function getoneyuanList(pg,callback){
    JSNet.sendParamsByGET(ServerUrl + "/v2/project/yiyuan/list/" + pg,function (code,http){
        callback(http.json())
    })
}

//获取一元众筹项目详情
function getoneyuanDetail(pd,callback){
    JSNet.sendParamsByGET(ServerUrl + "/project/yiyuan/"+ pd,function (code,http){
        callback(http.json())
    })
}

//获取一元众筹晒单列表
function getoneyuanTop(pd,callback){
    JSNet.sendParamsByGET(ServerUrl + "/project/yiyuan/winner/list/"+ pd,function (code,http){
        callback(http.json())
    })
}
//一元众筹晒单详情
function getoneyuanTopDetail(tid,callback){
    JSNet.sendParamsByGET(ServerUrl + "/project/yiyuan/winner/detail/"+ tid, function (code,http){
        callback(http.json())
    })
}

//获取单个一元众筹参与记录
function getoneyuanpeople(pid,pg,callback){
    JSNet.sendParamsByGET(ServerUrl + "/project/yiyuan/recording/" + pid+"/" + pg,function (code,http){
        callback(http.json())
    })
}

//上传一元夺宝订单
function setorder(bd,callback) {
    JSNet.sendJson(ServerUrl + "/user/bidyiyuan", bd,function (code, http) {
        callback(http.json())
    })
}


//////////// ------ 项目模块 ---------- ////////////

//条件筛选项目列表
function projectFilter(data, page, callback) {
    JSNet.sendJson(ServerUrl + "/project/filter/" + page, data,
                 function (code, http) {
                     callback(http.json())
                 })
}

//关注一个项目
function projectFocus(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/focus/" + id,
                        function (code, http) {
                            callback(http.json())
                        })
}

//取消关注一个项目
function projectCancelFocus(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/cancelfocus/" + id,
                        function (code, http) {
                            callback(http.json())
                        })
}
//////////// ------ 主播/粉丝模块 ---------- ////////////

//查询当红主播列表
function fansHotData(page, num, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/hot/list/" + page, num, function (code,http){
        callback(http.json())
    })
}

//查询主播项目详情
function fansProDetail(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/" + id, function (code,http){
        callback(http.json())
    })
}

//主播项目参与记录
function fansProJoinRecord(id, page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/join/zhubo/" + id + "/" + page, function (code,http){
        callback(http.json())
    })
}


//投资主播众筹
function fansJoinProject(data, callback) {
    JSNet.sendJson(ServerUrl + "/project/investment/new", data, function (code,http){
        callback(http.json())
    })
}

//发布主播项目
function fansPublishProject(data, callback) {
    JSNet.sendJson(ServerUrl + "/project/new", data, function (code, http) {
        callback(http.json())
    })
}

//更新主播项目
function fansUpdateProject(id, data, callback) {
    JSNet.sendJson(ServerUrl + "/project/update/" + id, data,
                 function (code, http) {
                     callback(http.json())
                 })
}

//获取主播项目回报信息
function fansGetRewardList(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/return/list/" + id, function (code,http){
        callback(http.json())
    })
}

//主播项目新增回报
function fansNewReward(data, callback) {
    JSNet.sendJson(ServerUrl + "/project/return/new", data,
                 function (code, http) {
                     callback(http.json())
                 })
}

//主播项目回报信息更新
function fansUpdateReward(rid, data, callback) {
    JSNet.sendJson(ServerUrl + "/project/return/upd/" + rid, data,
                 function (code, http) {
                     callback(http.json())
                 })
}

//主播项目删除回报信息
function fansDeleteReward(pid, rid, callback) {
    JSNet.sendJson(ServerUrl + "/project/return/del/" + pid + "/" + rid,
                 function (code, http) {
                     callback(http.json())
                 })
}

//////////// ------ 用户收货地址管理 ---------- ////////////

//收货地址列表
function addressGetList(callback){
    JSNet.sendParamsByGET(ServerUrl + "/user/address/list", function (code,http){
        callback(http.json())
    })
}

//新增收货地址
function addressAddNew(data, callback) {
    JSNet.sendJson(ServerUrl + "/user/address/add", data, function(code, http){
        callback(http.json())
    })
}

//删除收货地址
function addressDelete(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/address/del/" + id, function (code,http){
        callback(http.json())
    })
}

//修改收货地址
function addressUpdate(data, callback) {
    JSNet.sendJson(ServerUrl + "/user/address/upd", data, function(code, http){
        callback(http.json())
    })
}

//默认收货地址
function addressDefault(callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/defaddress/get", function(code, http){
        callback(http.json())
    })
}

//////////// ------ 地址服务 ---------- ////////////

//获取省份信息
function addressGetProvince(callback) {
    JSNet.sendParamsByGET(ServerUrl + "/address/province/getlist",
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取市信息
function addressGetCity(pid, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/address/city/getlist/" + pid,
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取市信息
function addressGetCounty(cid, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/address/district/getlist/" + cid,
                        function (code, http) {
                            callback(http.json())
                        })
}

//////////// ------ 评论模块 ---------- ////////////

//评论
//@param pid 项目id
//@param content 评论内容
function projectComment(pid, content, callback) {
    JSNet.sendJson(ServerUrl + "/question/ask", {
                     pd: pid,
                     cn: content
                 }, function (code, http) {
                     callback(http.json())
                 })
}

//指定项目的问题列表
//@param pid int64 项目id
//@param page int 页码,从0开始
function questionGetProjectList(pid, page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/question/project/" + pid + "/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//////////// ------ 积分商城模块 ---------- ////////////
//商城商品列表
function pointsGetHomeList(min, max, page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/service/goods/list/" + min + "/" + max + "/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//商城商品列表筛选条件
function pointsGoodsScreen(callback) {
    JSNet.sendParamsByGET(ServerUrl + "/service/goods/condition",
                        function (code, http) {
                            callback(http.json())
                        })
}

//个人兑换记录
function pointsPersonalRecord(page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/exchange/list/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//兑换商品
function pointsExchangeGoods(data, callback) {
    JSNet.sendJson(ServerUrl + "/user/exchange", data,
                        function (code, http) {
                            callback(http.json())
                        })
}

//资讯列表--首页跑马灯
//@param category int 所属栏目
//@param page int 页码,从0开始
function newsGetList(category, page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/news/list/" + category + "/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//////////// ------ 文件管理模块 ---------- ////////////
//查询服务器文件地址--http://192.168.2.182:3001/service/file/info/214,213  这个接口可以查询
function getFilesUrl(filesIdStr, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/service/file/info/" + filesIdStr,
                        function (code, http) {
                            callback(http.json())
                        })
}
































//--------------下面为众创创星球Api------------------


//////////// ------ 社区模块 ---------- ////////////

////取得我约谈的回话列表
function meChatList(page,callback){
    JSNet.sendParamsByGET(ServerUrl +"/project/mymeet/"+page,function(code,http){
        callback(http.json())
    })
}

//发表一条帖子
function publishNote(data, callback) {
    JSNet.sendJson(ServerUrl + "/bbs/add", data, function (code, http) {
        callback(http.json())
    })
}

//取帖子的评论
function getCommunityPostComments(postId, page, callback){
    JSNet.sendParamsByGET(ServerUrl +"/bbs/comment/list/bbspost/"+ postId+"/"+page,function(code, http){
        callback(http.json())
    })
}

//////////// ------ 用户模块 ---------- ////////////

//获取投资人认证信息
function getInvestor(uid, callback){
    JSNet.sendParamsByGET(ServerUrl + "/user/investorreview/get/"+uid,function (code, http){
        callback(http.json())
    })
}

//使用邮箱注册新用户
function userRegisterByEmail(data, callback) {
    JSNet.sendJson(ServerUrl + "/user/register/email", data,
                 function (code, http) {
                     callback(http.json())
                 })
}

//绑定手机号(lemon)
function bindPhone(phonNum, code, callback) {
    JSNet.sendParamsByGET(
                ServerUrl + "/user/binding/phone/" + phonNum + "/" + code,
                function (code, http) {
                    callback(http.json())
                })
}


//获取用户发布的项目列表
function userGetOwnProjects(uid, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/projects/" + uid,
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取用户投资的项目列表,分页从0开始,每页20条,
function userGetInvestmentsProjects(uid, page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/investments/" + uid + "/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//提交投资者认证
function userInvestorReview(data, callback) {
    JSNet.sendJson(ServerUrl + "/user/investor/review", data,
                 function (code, http) {
                     callback(http.json())
                 })
}


//发送手机验证码(lemon)
function getSecurityCode(num, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/service/phone/code/" + num,
                        function (code, http) {
                            callback(http.json())
                        })
}


//查询用户的推送消息
function userGetPushList(page, callback){
    JSNet.sendParamsByGET(ServerUrl + "/user/push/list/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}


//检查用户是否有未读消息
function userUnreadInfo(callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/check/unread",
                        function (code, http) {
                            callback(http.json())
                        })
}


//////////// ------ 项目模块 ---------- ////////////

//获取项目详细信息
function projectGetDetail(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/v2/project/" + id, function (code, http) {
        callback(http.json())
    })
}

//获取项目详细介绍
function projectGetIntroduce(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/introduce/" + id,
                        function (code, http) {
                            callback(http.text())
                        })
}


//获取用户关注的项目列表
function projectGetFocusList(uid, page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/focuslist/" + uid + "/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//约谈一个项目
function projectMeet(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/meet/" + id,
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取用户约谈的项目列表
function projectGetMeetList(uid, page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/meetlist/" + uid + "/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}



//拉取项目筛选条件
function projectGetFilterItem(callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/get/filters/",
                        function (code, http) {
                            callback(http.json())
                        })
}

//提交投资意向
function projectInvestment(data, callback) {
    JSNet.sendJson(ServerUrl + "/project/investment/new", data,
                 function (code, http) {
                     callback(http.json())
                 })
}

//获取项目的投资人列表
function projectGetInvestors(pid, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/get/investors/" + pid,
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取用户投资的项目列表(lemon)
function usergetProjectList(pid, page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/investments/" + pid + "/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}
//获取用户发布项目列表（lemon）
function projectgetTranslation(pid, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/user/projects/" + pid,
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取我邀请的投资人信息
//@param page int 页码
function projectRecommendInvestors(page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/invitations/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//////////// ------ 资讯模块 ---------- ////////////


//取得信息详情
//@param id 新闻id
function newsGetDetail(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/news/get/" + id, function (code, http) {
        callback(http.json())
    })
}

//////////// ------ 问答模块 ---------- ////////////


//回答
//@param pid 项目id
//@param content 回答内容
function questionAnswer(pid, content, callback) {
    JSNet.sendJson(ServerUrl + "/question/answer", {
                     pd: pid,
                     as: content
                 }, function (code, http) {
                     callback(http.json())
                 })
}

//我提问的问题列表
//@param page int 页码,从0开始
function questionGetMyAskList(page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/question/myqs/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//我回答的问题列表
//@param page int 页码,从0开始
function questionGetMyAnswerList(page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/question/myanswer/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//////////// ------ 活动/会议模块 ---------- ////////////

//获取会议列表
function activeMeetingGetList(page, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/meeting/list/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取会议详情
function activeMeetingGetDetail(id, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/meeting/get/" + id,
                        function (code, http) {
                            callback(http.json())
                        })
}

//报名参加会议
function activeMeetingRegistration(data, callback) {
    JSNet.sendJson(ServerUrl + "/meeting/signup", data, function (code, http) {
        callback(http.json())
    })
}

//报名赞助会议
function activeMeetingSponsor(data, callback) {
    JSNet.sendJson(ServerUrl + "/meeting/sponsor", data, function (code, http) {
        callback(http.json())
    })
}

//////////// ------ 聊天/约谈 ---------- ////////////

//发送聊天消息
//@param targetId 目标用户id
//@param content 聊天内容
function sendChatMessage(targetId, content, callback) {
    JSNet.sendJson(ServerUrl + "/chat/add", {
                     td: targetId,
                     cn: content
                 }, function (code, http) {
                     callback(http.json())
                 })
}

//获取聊天消息记录(正向，从早到晚)
//@param targetId 目标用户id
//@param beginId 上一条消息id,会获取此id之后的消息，传0则取最老的
function getChatMessagesA(targetId, beginId, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/chat/lista/" + targetId + "/" + beginId,
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取聊天消息记录(反向，从晚到早)
//@param targetId 目标用户id
//@param beginId 上一条消息id,会获取此id之前的消息，传0则取最新的
function getChatMessagesB(targetId, beginId, callback) {
    JSNet.sendParamsByGET(ServerUrl + "/chat/listb/" + targetId + "/" + beginId,
                        function (code, http) {
                            callback(http.json())
                        })
}

//获取约谈了我的用户列表
//@param 页数
function getChatMeList(page,callback) {
    JSNet.sendParamsByGET(ServerUrl + "/project/meetme/" + page,
                        function (code, http) {
                            callback(http.json())
                        })
}
