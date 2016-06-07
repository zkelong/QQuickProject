//
//  QUmeng.h
//  UmengQt
//
//  Created by fu yuming on 5/19/15.
//  Copyright (c) 2015 fu yuming. All rights reserved.
//

#ifndef __UmengQt__QUmeng__
#define __UmengQt__QUmeng__

#include <map>
#include <string>
#include <vector>
#include <list>
#include <functional>
#include <memory>


#if defined(Q_CC_RVCT)
template <typename T>
inline void qUnused(T &x) { (void)x; }
#  define UNUSED(x) qUnused(x);
#else
#  define UNUSED(x) (void)x;
#endif

class QError {
public:
    QError(int c, std::string msg){ code = c, message = msg;}
    int code;
    std::string message;
};


class QUmeng {
    
    
public:

    static QUmeng* instance();
    
    //获取以及添加tag的回调
    typedef std::function<void(std::shared_ptr<std::vector<std::string>> responseTags, int remain, std::shared_ptr<QError> error)> TagCallback;
    
    //普通请求回调
    typedef std::function<void(std::shared_ptr<QError> error)> ReqCallback;
    
    typedef enum {
        QUMShareToSina = 0, //新浪微博
        QUMShareToTencent, //腾讯微博
        QUMShareToRenren, //人人网
        QUMShareToDouban, //豆瓣
        QUMShareToQzone, //QQ空间
        QUMShareToEmail,//邮箱
        QUMShareToSms, //短信
        QUMShareToWechatSession, //微信好友
        QUMShareToWechatTimeline, //微信朋友圈
        QUMShareToWechatFavorite, //微信收藏
        QUMShareToQQ, //手机QQ
        QUMShareToFacebook, // Facebook
        QUMShareToTwitter, //Twitter
        QUMShareToYXSession, //易信好友
        QUMShareToYXTimeline, //易信朋友圈
        QUMShareToLWSession, //来往好友
        QUMShareToLWTimeline, //来往朋友圈
        QUMShareToInstagram, //分享到Instragram
        QUMShareToWhatsapp, //分享到Whatsapp
        QUMShareToLine, //分享到Line
        QUMShareToTumblr, //分享到Tumblr
        QUMShareToPinterest, //分享到Pinterest
        QUMShareToKakaoTalk, //分享到KakaoTalk
        QUMShareToFlickr, //分享到Flickr
    }QUMengShare;

    
    typedef enum {
        REALTIME = 0,       //实时发送              (只在测试模式下有效)
        BATCH = 1,          //启动发送
        SEND_INTERVAL = 6,  //最小间隔发送           ([90-86400]s, default 90s)
        
        // deprecated strategy:
        SENDDAILY = 4,      //每日发送              (not available)
        SENDWIFIONLY = 5,   //仅在WIFI下时启动发送   (not available)
        SEND_ON_EXIT = 7    //进入后台时发送         (not avilable, will be support later)
    } RepPolicy;
    
    //=========  统计部分 =======//
    
    /** 初始化友盟统计模块
     @param appKey 友盟appKey.
     @param reportPolicy 发送策略, 默认值为：BATCH，即“启动发送”模式
     @param channelId 渠道名称,为nil或@""时, 默认为@"App Store"渠道
     @return void
     */
    virtual void startWithAppkey(std::string appKey, RepPolicy reportPolicy, std::string channelId) = 0;
    
    /** 当reportPolicy == SEND_INTERVAL 时设定log发送间隔
     @param second 单位为秒,最小90秒,最大86400秒(24hour).
     @return void.
     */
    virtual void setLogSendInterval(double second) = 0;
    
    
    //======== 推送部分 =========//
    
    /** 设置应用的日志输出的开关（默认关闭）
     @param value 是否开启标志，注意App发布时请关闭日志输出
     */
    virtual void setMessageLogEnabled(bool value) = 0;
    
    /** 设置是否允许SDK自动清空角标（默认开启）
     @param value 是否开启角标清空
     */
    virtual void setBadgeClear(bool value) = 0;
    
    /** 手动清空角标 */
    virtual void clearBadge() = 0;
    
    /** 设置是否允许SDK当应用在前台运行收到Push时弹出Alert框（默认开启）
     @warning 建议不要关闭，否则会丢失程序在前台收到的Push的点击统计,如果定制了 Alert，可以使用`sendClickReportForRemoteNotification`补发 log
     @param value 是否开启弹出框
     */
    virtual void setAutoAlert(bool value) = 0;
    
    /** 为某个消息发送点击事件
     @warning 请注意不要对同一个消息重复调用此方法，可能导致你的消息打开率飚升，此方法只在需要定制 Alert 框时调用
     @param userInfo 消息体的NSDictionary，此Dictionary是
     (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo中的userInfo
     */
    //virtual void sendClickReportForRemoteNotification(std::map<std::string,std::string> *userInfo) = 0;
    
    /** 获取当前绑定设备上的所有tag(每台设备最多绑定64个tag)
     @warning 获取列表的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
     @param handle responseTags为绑定的tag
     集合,remain剩余可用的tag数,为-1时表示异常,error为获取失败时的信息(ErrCode:kUMessageError)
     */
    virtual void getTags(TagCallback handle) = 0;
    
    /** 绑定一个或多个tag至设备，每台设备最多绑定64个tag，超过64个，绑定tag不再成功，可`removeTag`或者`removeAllTags`来精简空间
     @warning 添加tag的先决条件是已经成功获取到device_token，否则直接添加失败(kUMessageErrorDependsErr)
     @param tag tag标记,可以为单个tag（NSString）也可以为tag集合（NSArray、NSSet），单个tag最大允许长度50字节，编码UTF-8，超过长度自动截取
     @param handle responseTags为绑定的tag集合,remain剩余可用的tag数,为-1时表示异常,error为获取失败时的信息(ErrCode:kUMessageError)
     */
    virtual void addTag(std::string tag,TagCallback handle) = 0;
    
    /** 删除设备中绑定的一个或多个tag
     @warning 添加tag的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
     @param tag tag标记,可以为单个tag（NSString）也可以为tag集合（NSArray、NSSet），单个tag最大允许长度50字节，编码UTF-8，超过长度自动截取
     @param handle responseTags为绑定的tag集合,remain剩余可用的tag数,为-1时表示异常,error为获取失败时的信息(ErrCode:kUMessageError)
     */
    virtual void removeTags(std::vector<std::string> &tags ,TagCallback handle) = 0;
    
    /** 删除设备中所有绑定的tag,handle responseObject
     @warning 删除tag的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
     @param handle responseTags为绑定的tag集合,remain剩余可用的tag数,为-1时表示异常,error为获取失败时的信息(ErrCode:kUMessageError)
     */
    virtual void removeAllTags(TagCallback handle) = 0;
    
    /** 绑定一个别名至设备（含账户，和平台类型）
     @warning 添加Alias的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
     @param name 账户，例如email
     @param type 平台类型，参见本文件头部的`kUMessageAliasType...`，例如：kUMessageAliasTypeSina
     @param handle block返回数据，error为获取失败时的信息
     */
    virtual void addAlias(std::string name, std::string type, ReqCallback callback) = 0;
    
    
    /** 删除一个设备的别名绑定
     @warning 删除Alias的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
     @param name 账户，例如email
     @param type 平台类型，参见本文件头部的`kUMessageAliasType...`，例如：kUMessageAliasTypeSina
     @param handle block返回数据，error为获取失败时的信息，responseObject为成功返回的数据
     */
    virtual void removeAlias(std::string name, std::string type, ReqCallback handle) = 0;
    
    
    
    //======== 社会化部分 =========//
    /**
     设置是否打开log输出，默认不打开，如果打开的话可以看到此sdk网络或者其他操作，有利于调试
     
     @param value 是否打开log输出
     
     */
    virtual void setSocialLogEnabled(bool value) = 0;
    
    /**
     设置微信AppId和url地址
     
     @param app_Id 微信应用Id
     @param url 微信消息url地址
     
     */
    virtual void setWXAppId(std::string app_Id ,std::string appSecret , std::string url) = 0;
    
    
    /**
     设置使用新浪微博SDK来处理SSO授权
     
     @param redirectURL 回调URL
     
     */
    virtual void openSSOWithRedirectURL(std::string redirectURL) = 0;
    
    
    /**
     设置分享到手机QQ和QQ空间的应用ID
     
     @param appId QQ互联应用Id
     @param appKey QQ互联应用Key
     
     @param url 分享URL链接
     */
    virtual void setQQWithAppId(std::string appId, std::string appKey, std::string url) = 0;
    
    /**
     设置在没有安装QQ客户端的情况下，是否支持单独授权到QQ互联
     
     @param supportWebView 是否支持没有安装QQ客户端的情况下，是否支持单独授权
     */
    virtual void setQQSupportWebView(bool supportWebView) = 0;
    
    /**
     设置facebook应用id，和url地址
     
     @param appID facebook应用ID
     @param urlString 分享纯文字用到的url地址
     
     */
    virtual void setFacebookAppID(std::string appID, std::string urlString) = 0;
    
    /**
     使用友盟提供的方法来分享到twitter
     
     */
    virtual void openTwitter() = 0;
    
    
    /**
     弹出一个分享列表的类似iOS6的UIActivityViewController控件
     @param shareText  分享编辑页面的内嵌文字
     @param shareImage 分享内嵌图片完整路径,用户可以在编辑页面删除
     @param snsNames 你要分享到的sns平台类型，该值QUMengShare枚举的数组，对应的是`UMSocialSnsPlatformManager.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
     */
    virtual void presentSnsIconSheetView(std::string shareText,std::string url,std::string shareImage, std::list<int>& snsNames, ReqCallback callback) = 0;
    
    
    /**
     发送微博内容到指定平台
     @param platformTypes    分享到的平台
     @param content          分享的文字内容
     @param image            分享的图片文件完整路径
     @param urlResource      图片、音乐、视频等url资源
     @param callback         回调函数
     */
    virtual void postSNSWithTypes(QUMengShare platformTypes, std::string content, std::string url,std::string imagePath, std::string urlResource, ReqCallback callback) = 0;

    
protected:
    std::string     m_appkey;
};

#endif /* defined(__UmengQt__QUmeng__) */
