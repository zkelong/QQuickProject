import QtQuick 2.0
import "controls"
import "./home"
import "./oneyuan"
import "./fans"
import "./common"
import "./payment"
import "./userinfo"
import "./login"
import "./integral"
import "./signin"
import "./api"      //用户登录信息
import "./tools.js" as Tools
import "./api.js" as JSApi  //应用的项目信息
import "./code.js" as Code

View {
    id: root
    specialBack: true

    property var topComp: null
    property double topCompHeight: 0

    property bool appExit: false   //退出app
    property var newsData: null  //跑马灯
    property var noticeData: null //公告
    //用户信息
    property var accountData: ({})
    //列表加载页数
    property int page: 0
    property int touchX;
    property alias listLoading: listView.loading //是否正处于加载中

    property var sxData: ({})

    onWidthChanged: {
        if(width > 0 && topComp == null) {
            //topCompHeight = root.width*0.78+Utl.dp(110)
            Tools.setMainForm(root)
            loadListTop()
            loadHeadData();
            autoLogin()
            loadListData()
        }
    }

    //个人信息，跑马灯等
    Component {
        id: homeTop
        HomeTopSection {
            width: root.width
            onInfoClicked: {
                sidebar.show()
            }
            onSectionClicked: {
                root.enabled = false
                switch(sectionId) {
                case 0: //一元
                    root.navigationView.push(oneYuan)
                    break;
                case 1: //粉丝
                    root.navigationView.push(fansHome)
                    break;
                case 2: //广告
                    root.navigationView.push(integral)
                    break;
                case 3: //签到
                    if(Tools.checkLogin()) {
                        root.navigationView.push({item:signin, properties:{nowPoints: accountData.points}})
                    }
                    break;
                default:
                    root.enabled = true
                }
            }
            onNoticeClicked: {
                root.enabled = false
                root.navigationView.push({item:newsDetailCmp, properties:{baseData: noticeData[index]}})
            }
            onPicClicked: {
                //console.log(JSON.stringify(data))
                handleNewsItem(data)
            }
        }
    }

    PullListView {
        id: listView
        anchors.fill: parent
        spacing: Utl.dp(11)
        delegate: delegate;
        model: listModel
        clip: true
        onReload: {
            page = 0
            //loadAccoutBaseInfo()
            loadAccountAPPInfo()
            loadHeadData();
            loadListData()
        }
        onLoadmore: {
            page += 1
            loadListData()
        }
    }

    Component {
        id: delegate
        CommonListItem {
            isHome: true
            onClicked: {
                root.enabled = false
                if(type == Code.ProjectTypeYiyuan) {  //一元
                    root.navigationView.push({item: yiyuanDetail, properties:{homeListId: id}})
                } else {  //主播/广告
                    root.navigationView.push({item: detail, properties: {proType: type, proId: id}})
                }
            }
        }
    }
    //首页列表数据
    ListModel {
        id: listModel
    }
    //滑动版块入口数据
    ListModel {
        id: sectionListModel
    }

    //侧边栏
    HomeSidebar{
        id: sidebar
        anchors.fill: parent
        mainStackview: root.navigationView
        visible: false
        onLogined: { //登陆成功
            //loadAccoutBaseInfo()
            loadAccountAPPInfo()
        }
        onLoginOuted: { //退出登陆
            accountData = {}
            topComp.userInfo = null
        }
        onInfoChanged: {    //资料有变动
            //loadAccoutBaseInfo()
            loadAccountAPPInfo()
        }
    }
    //一元主页
    Component {
        id: oneYuan
        OneHome{}
    }
    //广告墙主页
    Component {
        id: integral
        IntegralHome{}
    }
    //主播主页
    Component {
        id: fansHome
        FansHome{}
    }
    //项目详情--主播，广告
    Component {
        id: detail
        CommonDetail{}
    }
    //项目详情--一元项目
    Component {
        id: yiyuanDetail
        ProjectDetails{}
    }

    //签到界面
    Component {
        id: signin
        SignIn{
            onInfoChanged: loadAccountAPPInfo() //积分变动
        }
    }

    //登陆界面
    Component{
        id:loginCompent
        Login{
            //加载账户信息
            onLogined: {
                //loadAccoutBaseInfo()
                loadAccountAPPInfo()
            }
        }
    }

    Component{
        id:newsDetailCmp
        NwDetailForm{}
    }

    Timer{  //退出计时器
        id:timer
        running: false; repeat: false; interval: 1500
        onTriggered: {
            appExit = false
        }
    }

    function showLogin(){
        root.navigationView.push(loginCompent)
    }

    function hidenLogin(){
        root.navigationView.pop()
    }

    //加载列表头部
    function loadListTop() {
        topComp = homeTop.createObject(listView.contentItem)
        topComp.y = -topComp.height//-topCompHeight;
        listView.topMargin = topComp.height//topCompHeight;
        listView.oldTopMargin = topComp.height//topCompHeight;
        listView.contentY = -topComp.height//-topCompHeight
    }

    //自动登陆
    function autoLogin() {
        //加载本地用户，登录
        Api.loadLoginUser(function(obj){
            //console.log("loaduser....", JSON.stringify(obj))
            if(obj && obj.id) {   //登陆成功，返回id
                //loadAccoutBaseInfo()
                loadAccountAPPInfo()
            }
        });
    }

    ////获取账户信息(基本信息)
    //function loadAccoutBaseInfo() {
    //    //基本信息--昵称，头像，用户id
    //    Api.userGetBaseInfo(function(obj) {
    //        console.log("accountInfo...", JSON.stringify(obj))
    //        if(obj) {
    //            accountData.id = obj.id  //用户id
    //            accountData.nickName = obj.nk ? obj.nk : Api.accountId   //昵称-没有昵称显示为账号
    //            accountData.headImgUrl = obj.hd ? obj.hd : ""   //头像
    //            sidebar.userInfo = accountData
    //            topComp.userInfo = accountData
    //        } else {
    //            var str = qsTr("获取用户基本信息失败")
    //            Tools.showTip(str)
    //        }
    //    });
    //}

    //获取用户应用的信息
    function loadAccountAPPInfo() {
        if(!Tools.checkLogin()) { //没登录，不加载
            return
        }
        //应用的信息--姓名，电话，金额，积分，排名，任务数...
        JSApi.userGetInfo(function(obj){
            console.log("userInfo....", JSON.stringify(obj))
            if(obj && obj.d) {
                accountData.id = obj.d.id  //用户id
                accountData.nickName = obj.d.nk ? obj.d.nk : Api.accountId   //昵称-没有昵称显示为账号
                accountData.headImgUrl = obj.d.av ? Tools.getHeadImage(obj.d.av) : ""   //头像
                //个人信息
                accountData.phone = obj.d.ph ? obj.d.ph : ""   //手机号
                accountData.name = obj.d.nm ? obj.d.nm : "" //姓名
                accountData.money = obj.d.amt ? obj.d.amt : 0  //金额
                accountData.points = obj.d.mep ? obj.d.mep : 0 //积分
                accountData.rankNum = obj.d.rk ? obj.d.rk : 0    //排名
                accountData.taskNum = 0        //任务数
                sidebar.userInfo = accountData
                topComp.userInfo = accountData
                //console.log("accountData.....", JSON.stringify(accountData))
            } else if(obj && obj.t && obj.t != "") {
                Tools.showTip(obj.t)
            } else {
                Api.loginOut()
                var str = qsTr("获取用户应用信息失败")
                Tools.showTip(str)
            }
        })
    }

    //加载新闻消息
    function loadNews() {
        //新闻信息--跑马灯
        JSApi.newsGetList(Code.NewsTypeMarquee, page, function(obj){
            if(obj && obj.d) {
                if(obj.d.ls) {
                    var array = obj.d.ls
                    newsData = [];
                    for(var i = 0; i < array.length; i++) {
                        var item = {
                            id: Tools.getInt(array[i].id),
                            picUrl: Tools.getString(array[i].tp),
                            title: Tools.getString(array[i].tl),
                            url: Tools.getString(array[i].ul)   //包含"project://"的是项目
                        }
                        newsData.push(item)
                    }
                    topComp.newsData = newsData
                }
            } else if(obj && obj.t && obj.t != "") {
                Tools.showTip(obj.t)
            } else {
                var str = qsTr("获取新闻失败")
                Tools.showTip(str)
            }
        })
    }
    //加载公告
    function loadNotice() {
        JSApi.newsGetList(Code.NewsTypeNotifications,page,function(obj){
            if(obj && obj.d) {
                if(obj.d.ls) {
                    var array = obj.d.ls
                    noticeData = [];
                    for(var i = 0; i < array.length; i++) {
                        var item = {
                            id: Tools.getInt(array[i].id),
                            title: Tools.getString(array[i].tl),
                            url: Tools.getString(array[i].ul)
                        }
                        noticeData.push(item)
                    }
                    topComp.noticeData = noticeData
                }
            } else if(obj && obj.t && obj.t != "") {
                Tools.showTip(obj.t)
            } else {
                var str = qsTr("获取公告失败")
                Tools.showTip(str)
            }
        })
    }
    //加载顶部数据
    function loadHeadData() {
        loadNews()
        loadNotice()
        //版块数据
        var secItem1 = {id: 0, name: qsTr("一元"), picUrl: "qrc:/res/yiyuan.jpg", showText: qsTr("一元一发")};
        var secItem2 = {id: 1, name: qsTr("粉丝"), picUrl: "qrc:/res/fans.jpg", showText: qsTr("相约主播")};
        var secItem3 = {id: 2, name: qsTr("广告"), picUrl: "qrc:/res/adwall.jpg", showText: qsTr("搞积分")};
        var secItem4 = {id: 3, name: qsTr("签到"), picUrl: "qrc:/res/sign.jpg", showText: qsTr("每日一搞")};
        sectionListModel.clear()
        sectionListModel.append(secItem1)
        sectionListModel.append(secItem2)
        sectionListModel.append(secItem3)
        sectionListModel.append(secItem4)
        topComp.sectionListModel = sectionListModel
    }
    //加载列表数据
    function loadListData() {
        listView.startLoading(page==0)
        JSApi.projectFilter(page, sxData, function(obj){
            //console.log("obj...", JSON.stringify(obj))
            if(page == 0) {
                listView.stopLoading(true)
                listModel.clear()
            } else {
                listView.loading = false
            }
            if(obj && obj.d) {
                //当前页码，总页数
                listView.hasMore = obj.d.pg + 1 < obj.d.ct
                if(obj.d.ls) {
                    var array = obj.d.ls
                    for(var i = 0; i < array.length; i++) {
                        var item = {};
                        item.hid = array[i].id //项目id
                        item.titletxt = array[i].tl //标题
                        item.totolAmount = array[i].ta ? Tools.getFloat(array[i].ta, 2) : 0 //目标金额
                        item.raise = array[i].ct ? Tools.getFloat(array[i].ct, 2) : 0  //已筹金额
                        item.raiseNum = Tools.getFloat(array[i].ct, 2) //已筹金额
                        item.percentNum = item.totolAmount == 0 ? 0 : (item.raise / item.totolAmount) //进度
                        item.progress = (item.percentNum * 100).toFixed(2) + "%" //进度
                        item.deadline = array[i].dy ? array[i].dy : 0 //剩余天数
                        item.joinNum = array[i].in //参与人数
                        item.picUrl = array[i].tp //题图
                        item.comment = array[i].qn //评论数
                        var endTime = array[i].et ? Tools.formatDate(array[i].et) :  Tools.formatDate(new Date())   //结束时间
                        var today = Tools.formatDate(new Date())    //今天
                        //项目状态
                        if(array[i].st <= Code.CrowdStatusSwing && endTime >= today) { //进行中
                            item.status = qsTr("进行中")
                        } else { //已完成
                            item.status = qsTr("已结束")
                        }
                        //项目类型
                        item.type = array[i].prs
                        //console.log("items.....", JSON.stringify(item))
                        listModel.append(item);
                    }
                }
            } else if(obj && obj.t && obj.t != "") {
                Tools.showTip(obj.t)
            } else {
                var str = qsTr("获取数据失败")
                Tools.showTip(str)
            }
        })
    }
    //处理新闻的点击事件
    function handleNewsItem(item){
        root.enabled = false
        var url = item.url;
        if(!url || !url.length || url === "static" ) return
        if(url.indexOf("project://") === 0){   //项目
            root.enabled = true
            console.log("项目。。。。。")
            var sub = url.substr(10)
            var data = {id:parseInt(sub)}
            //root.navigationView.push({item:detailView, properties:{detailData:data}})
        } else {
            console.log("新闻。。。。", JSON.stringify(item))
            item.content = item.title
            root.navigationView.push({item:newsDetailCmp, properties:{baseData:item}})
        }
    }

    function keyBackAct() {
        if(sidebar.siShow) {  //返回键处理
            sidebar.hide()
            return
        }
        if(appExit) {
            Qt.quit()
        } else {
            Tools.showTip("再按一次退出程序")
            appExit = true
            timer.start()
        }
    }
}

