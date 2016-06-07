
#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//人人SDK头文件
#import <RennSDK/RennSDK.h>

#import <APOpenApi.h>

#include <QObject>
#include <QMap>
#include "ksharesdklistenner.h"

static NSDictionary* s_platforms = @{
                                     @"SinaWeibo":@(ShareTypeSinaWeibo)
                                     ,@"TencentWeibo":@(ShareTypeTencentWeibo)
                                     ,@"QZone":@(ShareTypeQQSpace)
                                     ,@"Wechat":@(ShareTypeWeixiSession)
                                     ,@"WechatMoments":@(ShareTypeWeixiTimeline)
                                     ,@"WechatFavorite":@(ShareTypeWeixiFav)
                                     ,@"QQ":@(ShareTypeQQ)
                                     ,@"Facebook":@(ShareTypeFacebook)
                                     ,@"Twitter":@(ShareTypeTwitter)
                                     ,@"Renren":@(ShareTypeRenren)
                                     ,@"KaiXin":@(ShareTypeKaixin)
                                     ,@"Email":@(ShareTypeMail)
                                     ,@"ShortMessage":@(ShareTypeSMS)
                                     ,@"Douban":@(ShareTypeDouBan)
                                     ,@"YouDao":@(ShareTypeYouDaoNote)
                                     ,@"Evernote":@(ShareTypeEvernote)
                                     ,@"LinkedIn":@(ShareTypeLinkedIn)
                                     ,@"GooglePlus":@(ShareTypeGooglePlus)
                                     ,@"FourSquare":@(ShareTypeFoursquare)
                                     ,@"Pinterest":@(ShareTypePinterest)
                                     ,@"Flickr":@(ShareTypeFlickr)
                                     ,@"Tumblr":@(ShareTypeTumblr)
                                     ,@"Dropbox":@(ShareTypeDropbox)
                                     ,@"VKontakte":@(ShareTypeVKontakte)
                                     ,@"Instagram":@(ShareTypeInstagram)
                                     ,@"Yixin":@(ShareTypeYiXinSession)
                                     ,@"YixinMoments":@(ShareTypeYiXinTimeline)
                                     ,@"Mingdao":@(ShareTypeMingDao)
                                     ,@"Line":@(ShareTypeLine)
                                     ,@"KakaoTalk":@(ShareTypeKaKaoTalk)
                                     ,@"KakaoStory":@(ShareTypeKaKaoStory)
                                     ,@"WhatsApp":@(ShareTypeWhatsApp)
                                     ,@"Pocket":@(ShareTypePocket)
                                     ,@"Instapaper":@(ShareTypeInstapaper)
                                     ,@"Alipay":@(ShareTypeAliPaySocial)
                                     };


static NSMutableArray* s_default_platform_list = nil; // 默认分享列表，根据connect调用的顺序排序
static NSString* s_appName = nil;

NSString* platformNameByType(ShareType type)
{
    NSArray* keys = [s_platforms allKeys];
    for (NSString*key in keys) {
        if ([[s_platforms objectForKey:key] intValue] == type) {
            return key;
        }
    }
}

void handler_platform_result(ShareType type,SSResponseState state, KShareSDKListenner* listenner)
{
    
    if (listenner) {
        if (state == SSResponseStateSuccess) {
            [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                Q_UNUSED(error);
                if (result) {
                    NSString* uId = [userInfo uid];
                    NSString* uName = [userInfo nickname];
                    NSString* uIcon = [userInfo profileImage];
                    NSString* token = [[userInfo credential] token];
                    NSString* tokenSecret = [[userInfo credential] secret];
                    long long expired = [[userInfo credential] expired].timeIntervalSince1970;
                    emit listenner->platformComplete(platformNameByType(type).UTF8String, uId.UTF8String, uName.UTF8String, uIcon.UTF8String, token.UTF8String, tokenSecret.UTF8String, expired);
                } else {
                    emit listenner->platformError(platformNameByType(type).UTF8String);
                }
            }];
        } else if (state == SSResponseStateFail) {
            emit listenner->platformError(platformNameByType(type).UTF8String);
        } else {
            emit listenner->platformCancel(platformNameByType(type).UTF8String);
        }
        
    }
}

id<ISSShareActionSheetItem> getShareItemWithType(ShareType type)
{
    return [[ShareSDK getShareListWithType:type, nil] objectAtIndex:0];
}

void sharesdk_init(QString appName, QString appkey)
{
    [ShareSDK registerApp:appkey.toNSString()];
    s_appName = [appName.toNSString() retain];
    s_default_platform_list = [[NSMutableArray alloc] init];
}

void sharesdk_setPlatformDevInfo(QString name, QMap<QString, QString> info)
{
    Q_UNUSED(name);
    Q_UNUSED(info);
}

void sharesdk_connectSinaWeibo(QString appkey, QString appSecret, QString redirectUri, bool useSSO)
{
    if (useSSO) {
        [ShareSDK connectSinaWeiboWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString() weiboSDKCls:[WeiboSDK class]];
    } else {
        [ShareSDK connectSinaWeiboWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString()];
    }
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeSinaWeibo)];
}

void sharesdk_connectTencentWeibo(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectTencentWeiboWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeTencentWeibo)];
}

void sharesdk_connectQZone(QString appkey, QString appSecret,bool useSSO)
{
    if (useSSO) {
        [ShareSDK connectQZoneWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
        
    } else {
        [ShareSDK connectQZoneWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() ];
    }
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeQQSpace)];
}

void sharesdk_connectQQ(QString appkey, QString appSecret)
{
    Q_UNUSED(appSecret)
    [ShareSDK connectQQWithQZoneAppKey:appkey.toNSString()
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeQQ)];
    
}

static BOOL  s_weixin_init = NO;

void sharesdk_connectWeChat(QString appkey, QString appSecret)
{
    if (!s_weixin_init) {
        [ShareSDK connectWeChatWithAppId:appkey.toNSString() appSecret:appSecret.toNSString() wechatCls:[WXApi class]];
        s_weixin_init = YES;
    }
    
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeWeixiSession)];
}

void sharesdk_connectWeChatMoments(QString appkey, QString appSecret)
{
    if (!s_weixin_init) {
        [ShareSDK connectWeChatWithAppId:appkey.toNSString() appSecret:appSecret.toNSString() wechatCls:[WXApi class]];
        s_weixin_init = YES;
    }
    
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeWeixiTimeline)];
}

void sharesdk_connectWeChatFavorite(QString appkey, QString appSecret)
{
    if (!s_weixin_init) {
        [ShareSDK connectWeChatWithAppId:appkey.toNSString() appSecret:appSecret.toNSString() wechatCls:[WXApi class]];
        s_weixin_init = YES;
    }
    
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeWeixiFav)];
}

void sharesdk_connectFacebook(QString appkey, QString appSecret, QString redirectUri)
{
    Q_UNUSED(redirectUri);
    [ShareSDK connectFacebookWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeFacebook)];
}

void sharesdk_connectTwitter(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectTwitterWithConsumerKey:appkey.toNSString() consumerSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeTwitter)];
}

void sharesdk_connectRenRen(QString appkey, QString appSecret)
{
    [ShareSDK connectRenRenWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeRenren)];
    
}

void sharesdk_connectRenRen(QString appId, QString appkey, QString appSecret)
{
    [ShareSDK connectRenRenWithAppId:appId.toNSString()
                              appKey:appkey.toNSString()
                           appSecret:appSecret.toNSString()
                   renrenClientClass:[RennClient class]];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeRenren)];
    
}

void sharesdk_connectKaiXin(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectKaiXinWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeKaixin)];
}

void sharesdk_connectShortEmail()
{
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeMail)];
}

void sharesdk_connectShortMessage()
{
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeSMS)];
}

void sharesdk_connectDouban(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectDoubanWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeDouBan)];
}

void sharesdk_connectYouDaoNote(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectYouDaoNoteWithConsumerKey:appkey.toNSString() consumerSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeYouDaoNote)];
}

void sharesdk_connectEvernote(int type, QString appkey, QString appSecret)
{
    [ShareSDK connectEvernoteWithType:(SSEverNoteType)type consumerKey:appkey.toNSString() consumerSecret:appSecret.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeEvernote)];
}

void sharesdk_connectFourSquare(QString appkey, QString appSecret, QString redirectUri)
{
    Q_UNUSED(appkey);
    Q_UNUSED(appSecret);
    Q_UNUSED(redirectUri);
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeFoursquare)];
}

void sharesdk_connectFlickr(QString appkey, QString appSecret, QString redirectUri)
{
    Q_UNUSED(redirectUri);
    [ShareSDK connectFlickrWithApiKey:appkey.toNSString() apiSecret:appSecret.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeFlickr)];
}

void sharesdk_connectTumblr(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectTumblrWithConsumerKey:appkey.toNSString() consumerSecret:appSecret.toNSString() callbackUrl:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeTumblr)];
}

void sharesdk_connectDropbox(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectDropboxWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() callbackUrl:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeDropbox)];
}

void sharesdk_connectVKontakte(QString appkey, QString appSecret)
{
    [ShareSDK connectVKontakteWithAppKey:appkey.toNSString() secretKey:appSecret.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeVKontakte)];
}

void sharesdk_connectInstagram(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectInstagramWithClientId:appkey.toNSString() clientSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeInstagram)];
}

void sharesdk_connectMingdao(QString appkey, QString appSecret, QString redirectUri)
{
    [ShareSDK connectMingDaoWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString() redirectUri:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeMingDao)];
}

void sharesdk_connectLine()
{
    [ShareSDK connectLine];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeLine)];
}

void sharesdk_connectKakaoTalk(QString appkey)
{
    Q_UNUSED(appkey);
    [ShareSDK connectKaKaoTalk];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeKaKaoTalk)];
}

void sharesdk_connectKakaoStory(QString appkey)
{
    Q_UNUSED(appkey);
    [ShareSDK connectKaKaoStory];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeKaKaoStory)];
}

void sharesdk_connectWhatsApp()
{
    [ShareSDK connectWhatsApp];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeWhatsApp)];
}


void sharesdk_connectPocket(QString appkey, QString redirectUri)
{
    [ShareSDK connectPocketWithConsumerKey:appkey.toNSString() redirectUri:redirectUri.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypePocket)];
}

void sharesdk_connectInstapaper(QString appkey, QString appSecret)
{
    [ShareSDK connectInstapaperWithAppKey:appkey.toNSString() appSecret:appSecret.toNSString()];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeInstapaper)];
}

void sharesdk_connectAlipay(QString appkey)
{
    [ShareSDK connectAliPaySocialWithAppID:appkey.toNSString() openApiCls:[APOpenAPI class] mediaMessageCls:[APMediaMessage class] shareTextObjectCls:[APShareTextObject class] shareImgObjectCls:[APShareImageObject class] shareWebObjectCls:[APShareWebObject class] sendMessageToAPReqCls:[APSendMessageToAPReq class]];
    [s_default_platform_list addObject:getShareItemWithType(ShareTypeAliPaySocial)];
}

void sharesdk_showShare(QString title, QString text, QString url, QString imagePath, bool showEdit, KShareSDKListenner* listenner)
{
    id<ISSCAttachment> img = nil;
    if (imagePath.length()) {
        if (imagePath.indexOf("http")) {
            img = [ShareSDK imageWithUrl:imagePath.toNSString()];
        } else {
            img = [ShareSDK imageWithPath:imagePath.toNSString()];
        }
    }
    
    
    //1、构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:text.toNSString()
                                       defaultContent:nil
                                                image:img
                                                title: title.toNSString()
                                                  url: url.toNSString()
                                          description:text.toNSString()
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    [authOptions setPowerByHidden:YES];
    
    NSMutableArray* list = [NSMutableArray arrayWithArray:s_default_platform_list];
    
    if (!showEdit) {
        id<ISSShareActionSheetItem> sinaItem =
        [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                           icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                   clickHandler:^{
                                       [ShareSDK shareContent:publishContent
                                                         type:ShareTypeSinaWeibo
                                                  authOptions:authOptions
                                                statusBarTips:YES
                                                       result:^(ShareType type, SSResponseState state,
                                                                id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                           Q_UNUSED(type);
                                                           Q_UNUSED(statusInfo);
                                                           Q_UNUSED(end);
                                                           if (state == SSPublishContentStateSuccess)
                                                           {
                                                               NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                           }
                                                           else if (state == SSPublishContentStateFail)
                                                           {
                                                               NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                           }
                                                       }];
                                   }];
        
        for (NSUInteger i = 0; i < [list count]; ++i) {
            NSObject* item = [list objectAtIndex:i];
            if ([item isKindOfClass:[NSNumber class]] && [(NSNumber*)item intValue] == ShareTypeSinaWeibo) {
                [list replaceObjectAtIndex:0 withObject:sinaItem];
                break;
            }
        }
        
    }
    
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:list
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                Q_UNUSED(statusInfo)
                                Q_UNUSED(error)
                                Q_UNUSED(end)
                                handler_platform_result(type, state, listenner);
                            }];
}

void sharesdk_doShare(QString platform, QString title, QString text, QString url, QString imagePath, KShareSDKListenner* listenner)
{
    
    id<ISSCAttachment> img = nil;
    if (imagePath.length()) {
        if (imagePath.indexOf("http")) {
            img = [ShareSDK imageWithUrl:imagePath.toNSString()];
        } else {
            img = [ShareSDK imageWithPath:imagePath.toNSString()];
        }
    }
    
    
    //1、构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:text.toNSString()
                                       defaultContent:nil
                                                image:img
                                                title: title.toNSString()
                                                  url: url.toNSString()
                                          description:text.toNSString()
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:publishContent type:(ShareType)[s_platforms[platform.toNSString()] intValue] authOptions:nil shareOptions:nil statusBarTips:true  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        Q_UNUSED(statusInfo)
        Q_UNUSED(error)
        Q_UNUSED(end)
        handler_platform_result(type, state, listenner);
    }];
}

void sharesdk_doLogin(QString platform, KShareSDKListenner* listenner)
{
    handler_platform_result((ShareType)[s_platforms[platform.toNSString()] intValue], SSResponseStateSuccess, listenner);
}
