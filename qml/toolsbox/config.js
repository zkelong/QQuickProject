.pragma library
.import "code.js" as Code
//.import QUmengQml 1.0 as Umeng

//默认图片
var DefaultImage = "qrc:/res/defalutImage.png"
//头像默认图片
var DefaultAvatar = "qrc:/res/defaultAvatar.png"

//限制电话格式正则表达式
var CheckPhoneNum = /^((\+?86)|(\(\+86\)))?(13[0123456789][0-9]{8}|14[57][0-9]{8}|15[012356789][0-9]{8}|17[0678][0-9]{8}|18[0123456789][0-9]{8})$/;
//var CheckPhoneNum = /^1[3|5|7|8][0-9]\d{4,8}$/
//限制数字输入正则表达式
var CheckNum = /^[0-9]*$/
//正整数
var CheckPositiveNum = /^\+?[1-9][0-9]*$/
//密码必须为字母加数字
var checkPassword = /^(?=.*?[a-zA-Z])(?=.*?[0-9])[a-zA-Z0-9]{6,}$/

//var SnsNames = [Umeng.QUmengQml.QUMShareToWechatSession,
//                Umeng.QUmengQml.QUMShareToWechatTimeline,
//                Umeng.QUmengQml.QUMShareToQQ,
//                Umeng.QUmengQml.QUMShareToQzone,
//                Umeng.QUmengQml.QUMShareToSina,
//                Umeng.QUmengQml.QUMShareToTencent,
//                Umeng.QUmengQml.QUMShareToEmail,
//                Umeng.QUmengQml.QUMShareToSms];

//分享平台信息
var ShareInfoWX = {Id:"1",SortId:"1",AppId:"wx9ee2c7939c49e046",AppSecret:"c349571cf3abd953d9eddc2cb72a9c6e",BypassApprova:true,Enable:true}
var ShareInfoQQ = {Id:"3",SortId:"3",AppId:"1105217696",AppKey:"VNN1I6BmcTlavmAh",ShareByAppClient:true,Enable:true}
var ShareInfoSina = {Id:"4",SortId:"4",AppKey:"4131958479",AppSecret:"cf37da53d90cdf6bd76b86ebe91a924c",RedirectUrl:"https://api.weibo.com/oauth2/default.html",ShareByAppClient:true,Enable:true}


//签到规则描述
var signvuls = "1.每5天为一个周期，每天签到一次，连续签到5天后即可提现，获取充值话费2元，若中断，将从头再参与"

//积分与钱的兑换比例 1积分 * PointsExchangeToMoney = 1元
var PointsExchangeToMoney = 1600





//项目类型/众筹状态
var CrowdStatus = [
            {name: "活动中", value: Code.CrowdStatusSwing},
            {name: "已结束", value: Code.CrowdStatusFinished}
        ]


//行业分类
var Industries = [
            {name:"移动互联网", value:Code.IndustryTypeMobileInternet, tagText:"IT", colorDefine:"#8BBCE5"},
            {name:"节能环保", value:Code.IndustryTypeGreen, tagText:"节能", colorDefine:"#CAF98F"},
            {name:"文化传媒", value:Code.IndustryTypeCulture, tagText:"文化", colorDefine:"#EB885F"},
            {name:"新材料" ,value:Code.IndustryTypeNewMaterial, tagText:"材料", colorDefine:"#E8B05B"},
            {name:"新能源", value:Code.IndustryTypeNewEnergy, tagText:"能源", colorDefine:"#E0AAC1"},
            {name:"生物制药", value:Code.IndustryTypePharmacy, tagText:"制药", colorDefine:"#ABD2CD"},
            {name:"消费服务", value:Code.IndustryTypeConsumption,tagText:"服务", colorDefine:"#C1ADDE"},
            {name:"信息技术", value:Code.IndustryTypeIT, tagText:"信息", colorDefine:"#EFA0A0"},
            {name:"其他", value:Code.IndustryTypeOther, tagText:"其他", colorDefine:"#ADE1ED"}
        ]

//项目类型
var ProjectType = [
            {name: "一元众筹", value: Code.ProjectTypeYiyuan, available: false},
            {name: "主播众筹", value: Code.ProjectTypeFans, available: true},
            {name: "广告众筹", value: Code.ProjectTypeAd, available: false}
        ]
