.pragma library

//1.返回状态码
var StNotFound           = 600 //指定数据不存在
var StAlreadyExists      = 601 //数据已存在(重复)
var StUserAliasInvalid   = 602 //用户昵称无效
var StUserNameInvalid    = 603 //用户姓名无效
var StAccountEmpty       = 604 //邮箱，手机必须有一个非空
var StInvalidEmail       = 605 //邮箱格式不合法
var StInvalidPhone       = 606 //手机格式不合法
var StInvalidPhoneCode   = 607 //手机验证码不正确
var StPhoneCodeInterval  = 608 //验证码发送时间间隔太短
var StInvalidUUID        = 609 //设备号不合法
var StInvalidPassword    = 610 //密码不能小于6个字符
var StAuthFailure        = 611 //用户id或密码错误
var StInvalidOldPassword = 612 //原密码错误
var StTokenExpired       = 613 //token已过期
var StAlreadyBinding     = 614 //已经绑定过了
var StAlreadyUsed        = 615 //所提供的邮箱、手机、第三方账号已经被使用
var StFileTooLarge       = 616 //文件太大
var StFileNotFound       = 617 //上传的文件未收到

var StOK          = 200
var StParamsError = 400 //参数错误
var StNoAccess    = 403 //无权访问
var StServerError = 500 //服务器内部错误


//2.众筹状态
var CrowdStatusAll        = 0 //不限,未设置
var CrowdStatusWaitReview = 1                   //等待审核
var CrowdStatusInReview   = 2                   //正在审核
var CrowdStatusPreheating = 3                   //已通过
var CrowdStatusSwing      = 4                   //进行中
var CrowdStatusFinished   = 5                   //已完成
var CrowdStatusFailure    = -1                  //失败


//3.行业分类
var IndustryTypeNone                        = 0 //不限,未设置
var IndustryTypeOther                       = 1    //其他
var IndustryTypeMobileInternet              = 2    //移动互联网
var IndustryTypeGreen                       = 3    //节能环保
var IndustryTypeCulture                     = 4    //文化传媒
var IndustryTypeNewMaterial                 = 5    //新材料
var IndustryTypeNewEnergy                   = 6    //新能源
var IndustryTypePharmacy                    = 7    //生物制药
var IndustryTypeConsumption                 = 8    //消费服务
var IndustryTypeIT                          = 9    //信息技术


//4.项目的会员级别
var ProMemberTypeNone                    = 0  //不限
var ProMemberTypeNot                     = 1  //非会员
var ProMemberTypeRegular                 = 2  //普通会员
var ProMemberTypeVip                     = 3  //vip会员
var ProMemberTypeSVip                    = 4  //svip会员


//5.投资状态
var InvestmentStatusNone                      = 0    //无
var InvestmentStatusIntent                    = 1    //意向投资
var InvestmentStatusContract                  = 2    //拟订合同
var InvestmentStatusRemit                     = 3    //汇款中
var InvestmentStatusPartinto                  = 4    //部分到账
var InvestmentStatusFinished                  = 5    //已完成

//6.男女标识
var GenderUnknown               = 0 //未设置
var GenderMale                  = 1 //男
var GenderFemale                = 2 //女


//7.投资者类型
var InvestorUnknown                      = 0 //未认证投资者
var InvestorInReview                     = 1 //认证中
var InvestorPersonal                     = 2 //个人投资者
var InvestorOrganization                 = 3 //机构投资者


//8.审核状态
var ReviewStatusWait                  = 0    //等待审核
var ReviewStatusInReview              = 1    //审核中
var ReviewStatusPassed                = 2    //审核通过
var ReviewStatusReject                = -1   //被拒绝


//9.客服跟进状态
var InvestmentFollowupNone                          = 0    //未跟进
var InvestmentFollowuping                           = 1    //跟进中
var InvestmentFollowupDone                          = 2    //已完成跟进


//11.团队类型
var TeamTypeNone                   = 0    //未设置，不限
var TeamTypeTechnology             = 1    //创始人有技术背景
var TeamTypeExp                    = 2    //有成功经验
var TeamTypeAbroad                 = 3    //创始人有留学背景
var TeamTypeTopManager             = 4    //大公司高管
var TeamTypeComplementary          = 5    //创始团队互补
var TeamTypeProficient             = 6    //对行业深刻理解


//12.产品类型
var ProductTypeNone                   = 0    //未设置，不限
var ProductTypeDemand                 = 1    //刚性需求
var ProductTypePower                  = 2    //有独特资源
var ProductTypeVerifiable             = 3    //有可供验证的产品和服务



//13.市场类型
var MarketTypeNone               = 0    //未设置，不限
var MarketTypeGreat              = 1    //广阔的市场空间
var MarketTypeLead               = 2    //已获得市场领先
var MarketTypeProfit             = 3    //已盈利
var MarketTypeExpand             = 4    //扩张能力
var MarketTypeBigUser            = 5    //已获得大量用户


//14.上市预期
var IPOTypeNone                = 0
var IPOTypeBrokerEnter         = 1 //券商入驻
var IPOTypeShareReform         = 2 //已经股改
var IPOTypeOneYear             = 3 //一年内IPO


//15.回报率类型
var RoaTypeNone             = 0    //未设置，不限
var RoaType50Less           = 1    //50%以下
var RoaType50To100          = 2    //50% - 100%
var RoaType100To200         = 3    //100% - 200%
var RoaType200To500         = 4    //200% － 500%
var RoaType500More          = 5    //500%以上


//16.可提供帮助类型
var HelpTypeNone                  = 0    //未设置，不限
var HelpTypeFunds                 = 1    //资金支持
var HelpTypeFinanceLegal          = 2    //财务法务
var HelpTypeMedia                 = 3    //媒体资源
var HelpTypeOperation             = 4    //运营经验
var HelpTypePolicy                = 5    //政策利好
var HelpTypeHR                    = 6    //人力资源
var HelpTypeUpstream              = 7    //上游产业资源
var HelpTypeDownstream            = 8    //下游产业资源
var HelpTypeOther                 = 9    //其他支持(具体说明)


//17.用户分组
var UserGroupBase                = 0    //普通用户
var UserGroupAdmin               = 1    //管理员


//18.项目排序方式
var PSortTypeDefault            = 0    //默认方式
var PSortTypeHot                = 1    //按热门
var PSortTypeNew                = 2    //按最新发布
var PSortTypeProgress           = 3    //按融资进度

//19.资讯栏目
var NewsTypeRecommend           = 1 // 推荐/最新
var NewsTypeHot                 = 2 // 热点
var NewsTypeRule                = 3 // 交易规则
var NewsTypeMarquee             = 4 // 跑马灯
var NewsTypeNotifications       = 5 // 公告
var NewsTypeInvesmentAgreement  = 6 // 投资协议

//20.活动状态
var MeetingStatusPreheating  = 0 //预热中
var MeetingStatusUnderway    = 1 //进行中
var MeetingStatusEnded       = 2 //已结束

//21.会议报名者类型
var MUserTypeCompany    = 1 //企业
var MUserTypeOrg        = 2 //投资机构
var MUserTypePersonal   = 3 //个人
var MUserTypeMedia      = 4 //媒体
var MUserTypeFinancial  = 5 //金融

//22.项目所属阶段
var PStageTypeNone    = 0 //未设置
var PStageTypeSeed    = 1 //种子期
var PStageTypeGrowth  = 2 //成长期
var PStageTypeExpand  = 3 //扩张期
var PStageTypeAutumn  = 4 //成熟期

//23.项目类型
var ProjectTypeYiyuan   = 1   //一元
var ProjectTypeFans     = 2   //主播
var ProjectTypeAd       = 3   //广告

//账户变更类型
var AccountCashIn = 1       //存入现金
var AccountCashOut= 2       //支出现金
var AccountPointsIn = 3     //增加积分
var AccountPointsOut = 4    //支出积分
var AccountAll = 0          //全部

//验证码类型
var VerifyCodeTypeRegister                     = 1 //注册
var VerifyCodeTypeResetPassword                = 2 //修改密码
var VerifyCodeTypeBindingPhone                 = 3 //绑定手机号
var VerifyCodeTypeBindingCard                  = 4 //绑定银行卡/支付宝
var VerifyCodeTypeWechat                       = 5 //微信

//操作系统类型
var OSiOS              = 1
var OSAndroid          = 2
var OSWeb              = 3
var OSWindows          = 4
var OSMac              = 5
