.pragma library
.import "../toolsbox/api.js" as Api

////-----界面操作-----////
///......Window/MainForm.....///
var mainWindow = null
var mainForm = null
function setMainWindow(win){    //main--Window
    mainWindow = win;
}
//设置窗口显示/隐藏
function setWindowShow(show) {
    mainWindow.setWindowShow(show)
}
//设置窗口可获取焦点/不可获取焦点
function setMainWindowEnable(enable) {
    mainWindow.setEnabled(enable)
}

function setMainForm(form){     //initialItem--mainForm
    mainForm = form;
}

///......BusyView.....///
var _mainBusyView = null
var _busyCount = 0

function registMainBusy(busy) {
    _mainBusyView = busy
}

function busyRunning() {    //busy状态
    return _mainBusyView.running
}

//显示busy，可通过x, y设置遮罩位置
function showBusy(x, y) {
    x = x || 0
    y = y || 0
    _mainBusyView.x = x
    _mainBusyView.y = y

    _busyCount++;
    if(!_mainBusyView.running){
        _mainBusyView.running = true
    }
    console.log("busy---show: ", _busyCount)
}

function hidenBusy(){ //隐藏busy
    if(_busyCount > 0)
        _busyCount--
    if(_busyCount <= 0)
        _mainBusyView.running = false
    console.log("busy---hide: ", _busyCount)
}

///......TipView.....///
var _mainTip = null;
function registMainTip(tip){
    _mainTip = tip
}

function showTip(tipString){
    tipString = tipString || ""      //tipString未有定义时，初始化为""
    if(tipString === "")
        return
    _mainTip.content = tipString;
    _mainTip.show();
}


///......StackView.....///
var mainStackView = null;
function registMainStack(stack) {
    mainStackView = stack
}

var stackView = null;
function registStack(stack){
    stackView = stack
}








/////////-------时间操作函数-------/////////
//JS 日期格式化
//调用方法: var time1 = new Date().format("yyyy-MM-dd HH:mm:ss");
//调用方法: var time2 = new Date().format("yyyy-MM-dd");
Date.prototype.format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月份--this: Date()
        "d+": this.getDate(), //日
        "h+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    //正则表达式，测试fmt时间格式有"y"-年 RegExp.$1正则表达式中，第一个被括号包含的部分，此处即为 y+
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

//1.将时间转换为想要的格式
//日期格式化：0000/00/00 00:00:00
function dateFormatStr(d) {
    if(!dateString)
        return "0001-01-01"
    var ret = d.getFullYear() + "/"
    ret += ("00" + (d.getMonth() + 1)).slice(-2) + "/"
    ret += ("00" + d.getDate()).slice(-2) + " "
    ret += ("00" + d.getHours()).slice(-2) + ":"
    ret += ("00" + d.getMinutes()).slice(-2) + ":"
    ret += ("00" + d.getSeconds()).slice(-2)
    return ret;
}
//日期格式化：yyyy-MM-dd
function formatDate(dateString) {
    if(!dateString)
        return "0001-01-01"
    var date = new Date(dateString)
    return date.format("yyyy-MM-dd")
}
//日期格式化：yyyy年MM月dd日
function formatDates(dateString) {
    if(!dateString)
        return "0001-01-01"
    var date = new Date(dateString)
    return date.format("yyyy年MM月dd日")
}
//日期格式化：yyyy年MM月dd日 hh:mm:ss
function formatTimes(dateString) {
    if(!dateString)
        return "0001-01-01"
    var date = new Date(dateString)
    return date.format("yyyy年MM月dd日 hh:mm:ss")
}
//日期格式化：yyyy-MM-dd hh:mm:ss
function formatTime(dateString) {
    if(!dateString)
        return "0001-01-01 00:00:00"
    var date = new Date(dateString)
    return date.format("yyyy-MM-dd hh:mm:ss")
}

//获取根据时间获得星期几
function timeGetWeek(time) {
    var week = time.getDay();
    var weekday = [qsTr("日"), qsTr("一"), qsTr("二"), qsTr("三"), qsTr("四"), qsTr("五"), qsTr("六")]
    return qsTr("星期") + weekday[week]
}

//时间加上天数，获得新的时间
function timeAddDays(time, days) {
    var millSeconds = Math.abs(time) + (days * 24 * 60 * 60 * 1000);
    return new Date(millSeconds)
}

//时间减去天数，获得新的时间
function timeSubDays(time, days) {
    var millSeconds = Math.abs(time) - (days * 24 * 60 * 60 * 1000);
    return new Date(millSeconds)
}

//计算日期差值，返回差值毫秒数
function timeSubtraction(time1, time2) {
    return time1.getTime() - time2.getTime()
}

/**日期相差的天，时，分，秒
  * retDate {
        difType: 大小类型，前一个数大(1)，还是后一个数大(0)
        difDays: 相差天数
        difHour: 相差小时数
        difMunute: 相差分钟数
        difSecond: 相差秒钟数
        difMilliScond: 相差毫秒数
    }
  *
  */
function dateSubtion(time1, time2) {
    var rData = {} //返回数据
    var difTime = timeSubtraction(time1, time2) //相差毫秒数
    if(difTime < 0) {
        rData.difType = 0
    } else {
        rData.difType = 1
    }
    rData.difDays = Math.floor(difTime/(24*3600*1000))  //相差的天数

    var leaveTime1 = difTime % (24*3600*1000) //计算天数后剩余的毫秒数
    rData.difHour = Math.floor(leaveTime1/(3600*1000)) //相差的小时数

    var leaveTime2 = leaveTime1%(3600*1000) //计算小时后剩余的毫秒数
    rData.difMunite = Math.floor(leaveTime2/(60*1000))  //相差的分钟数

    var leaveTime3 = leaveTime1%(60*1000) //计算分钟后剩余的毫秒数
    rData.difSecond = Math.floor(leaveTime3/1000)  //相差的秒钟数

    var leaveTime4 = leaveTime1%(1000) //计算分钟后剩余的毫秒数
    rData.difMilliScond = Math.floor(leaveTime3/1000)  //相差的秒钟数
    return rData
}

//获取一年的天数
function getYearDays(year) {
    var days =  new Date(year, 2, 0).getDate();    //2月份的天数，日传0，上个月的最后一天
    console.log(days, year,new Date(year, 1, 0))
    if(days == 29)
        return 366
    return 365
}

//获取年月的天数
function getYearMonthDyas(year, month) {
    return new Date(year, month, 0).getDate()
}

//根据年算农历属相
function getAnimalZodiac(year) {
    var animalZodiac = [qsTr("鼠"), qsTr("牛"), qsTr("虎")
                        ,qsTr("兔"), qsTr("龙"), qsTr("蛇")
                        ,qsTr("马"), qsTr("羊"), qsTr("猴")
                        ,qsTr("鸡"), qsTr("狗"), qsTr("猪")]
    var zodiac = Math.abs((year - 1984)) % 12   //84年是鼠年
    console.log(year, zodiac)
    return animalZodiac[zodiac]
}

/////////-------对象判断-------/////////
//判断对象是否为空--true: 为空， falsed: 不为空
function chekObjectEmpty(obj) {
    if(obj === null)
        return true
    var ret = true
    for(var item in obj) {
        ret = false
        break
    }
    return ret
}

/////////-------取值操作-------/////////
//取int
//v 原值
//scale 如原有值将会返回 v/scale
function getInt(v,scale){
    v = v || 0      //v未有定义时，初始化为0
    if(typeof v === "string")
        v = parseInt(v)
    if(scale){
        v = parseInt(v/scale)
    }
    return v
}

function getNumber(v){
    v = v || 0  //v未有定义时，初始化为0
    return v
}

function getString(v){
    v = v || ""
    return v
}

//取小数
//v 原值
//decimal 保留小数位数
function getFloat(v,decimal){
    if(!v)
        return 0
    var dv = parseFloat(v)
    if(decimal !== undefined){
        dv = parseFloat(dv.toFixed(decimal)) //.toFixed还四舍五入
    }
    return dv
}


/////////-------正则表达式-------/////////
//email地址
var EmailRegExp = /[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?/
//正整数
var PositiveInteger = /^[1-9]\d*$/
//负整数
var NagtiveInteger = /^-[1-9]\d*$/
//整数
var Integer = /^-?[1-9]\d*$/
//非负整数
var NotNagtiveInteger = /^[1-9]\d*|0$/
//非正整数
var NotPositiveInteger = /^-[1-9]\d*|0$/
//正浮点数--只能是小数，整数不行
var PositiveNumber = /^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$/
//负浮点数--只能是小数，整数不行
var NegtiveNumber = /^-[1-9]\d*\.\d*|-0\.\d*[1-9]\d*$/

//验证是否为有效的邮箱
function isEmail(email){
    var re = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/
    if(re.test(email)){
        return true
    }
    return false
}

/** 初始化时间
 * new Date(),
 * new Date(2006,0,12,22,19,35),   //(年, 月(0-11), 日, 时, 分, 秒)
 * new Date(2006,0,12),    //(年, 月(0-11), 日)
 * new Date(1137075575000))    //1970年1月1日之间相差的毫秒数
 */

/** 字符串截取
 * stringObject.slice(start,end)--slice()方法可提取字符串的某个部分，并以新的字符串返回被提取的部分。
 * start: 必需。要抽取的片断的起始下标。如果是负数，则该参数规定的是从字符串的尾部开始算起的位置。也就是说，-1 指字符串的最后一个字符，-2 指倒数第二个字符，以此类推。
 * end: 紧接着要抽取的片段的结尾的下标。若未指定此参数，则要提取的子串包括 start 到原字符串结尾的字符串。如果该参数是负数，那么它规定的是从字符串的尾部开始算起的位置。
 * 可以直接用为：stringObject.slice(start) //正数从前边取，负数从尾部开始取，长度均为start
 */

/** 字符串截取
 * stringObject.substr(start,length)方法可在字符串中抽取从 start 下标开始的指定数目的字符。
 * start: 必需。要抽取的子串的起始下标。必须是数值。如果是负数，那么该参数声明从字符串的尾部开始算起的位置。也就是说，-1 指字符串中最后一个字符，-2 指倒数第二个字符，以此类推。
 * end: 可选。子串中的字符数。必须是数值。如果省略了该参数，那么返回从 stringObject 的开始位置到结尾的字串。
 */

/** 字符串替换
 * stringObject.replace(regexp/substr,replacement)方法用于在字符串中用一些字符替换另一些字符，或替换一个与正则表达式匹配的子串。
 * regexp/substr: 必需。规定子字符串或要替换的模式的 RegExp 对象。请注意，如果该值是一个字符串，则将它作为要检索的直接量文本模式，而不是首先被转换为 RegExp 对象。
 * replacement: 必需。一个字符串值。规定了替换文本或生成替换文本的函数。
 */




























//获取用户头像
function getHeadImage(url) {
    if(url.indexOf("http") === 0)
        return url
    return Api.HeadVisitkUrl + url
}

//------------ UI 功能 ----------------------//



function checkLogin(){
    if(!Api.isLogined()){
        showLogin()
        return false
    }
    return true
}

function showLogin(){
    mainForm.showLogin()
}

function hidenLogin(){
    mainForm.hidenLogin()
}



//地址服务
function getPositionService(){
    return mainWindow.positionService;
}

//获取当前的经纬度
function getCurrentCoordinate(){
    if(mainWindow.positionService.position){
        return mainWindow.positionService.position.coordinate;
    } else {
        return {longitude:0, latitude:0};
    }
}

//获取当前的地址信息
function getCurrentAddress(){
    return mainWindow.positionService.address;
}

//------------ 配置检索 ----------------------//

//根据行业Id获取行业名称
function getIndustryById(id) {
//    for(var i = 0; i < Config.Industries.length; i++) {
//        if(Config.Industries[i].value == id)
//            return Config.Industries[i].name
//    }
    return qsTr("未设置")
}

//根据阶段名称获取阶段名称
function getPhaseById(id) {
    for(var i = 0; i < Config.stageType.length; i++) {
        if(Config.stageType[i].value == id)
            return Config.stageType[i].name
    }
    return qsTr("未设置")
}
