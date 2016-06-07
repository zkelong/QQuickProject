//
//  QUmeng_iOS.m
//  UmengQt
//
//  Created by fu yuming on 5/21/15.
//  Copyright (c) 2015 fu yuming. All rights reserved.
//

#include "QUmeng_iOS.h"
#import "SocialSnsDelegate.h"
#import "MessageDelegate.h"

#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialFacebookHandler.h"
#import "UMSocialTwitterHandler.h"
#import "MobClick.h"

NSString* SNS_NAMES[] = {UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToQzone,UMShareToEmail,UMShareToSms,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ,UMShareToFacebook,UMShareToTwitter,UMShareToYXSession,UMShareToYXTimeline,UMShareToLWSession,UMShareToLWTimeline,UMShareToInstagram,UMShareToWhatsapp,UMShareToLine,UMShareToTumblr,UMShareToPinterest,UMShareToKakaoTalk,UMShareToFlickr};


QUmeng* QUmeng::instance()
{
    static QUmeng_iOS s_instance;
    return &s_instance;
}

NSString* toNSString(std::string& str)
{
    return [NSString stringWithUTF8String:str.c_str()];
}


void QUmeng_iOS:: startWithAppkey(std::string appKey, RepPolicy reportPolicy, std::string channelId)
{
    m_appkey = appKey;
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatFavorite,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToTencent]];
    [[MessageDelegate instance] startWithAppkey:toNSString(appKey) reportPolicy:ReportPolicy(reportPolicy) channelId:toNSString(channelId)];
//    [MobClick startWithAppkey:toNSString(appKey) reportPolicy:ReportPolicy(reportPolicy) channelId:toNSString(channelId)];
//    [UMessage startWithAppkey:toNSString(appKey) launchOptions:nil];
//    [UMSocialData setAppKey:toNSString(appKey)];
    
}

void QUmeng_iOS:: setLogSendInterval(double second)
{
    [MobClick setLogSendInterval:second];
}

//======== 推送部分 =========//


void QUmeng_iOS:: setMessageLogEnabled(bool value)
{
    [UMessage setLogEnabled:value];
}

void QUmeng_iOS:: setBadgeClear(bool value)
{
    [UMessage setBadgeClear:value];
}

void QUmeng_iOS:: clearBadge()
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

void QUmeng_iOS:: setAutoAlert(bool value)
{
    [UMessage setAutoAlert:value];
}


void QUmeng_iOS:: getTags(TagCallback handle)
{
    [UMessage getTags:^(NSSet *responseTags, NSInteger remain, NSError *error) {
        if (error) {
            std::string msg = error.localizedDescription.UTF8String;
            std::shared_ptr<QError> err(new QError(int(error.code), msg));
            handle(nullptr,int(remain), err);
        } else {
            std::shared_ptr<std::vector<std::string>> list(new std::vector<std::string>());
            for (NSString*str in responseTags) {
                list->push_back(std::string(str.UTF8String));
            }
            handle(list,int(remain), nullptr);
        }
        
    }];
}

void QUmeng_iOS:: addTag(std::string tag,TagCallback handle)
{
    [UMessage addTag:toNSString(tag) response:^(id responseObject, NSInteger remain, NSError *error) {
        if (error) {
            std::string msg = error.localizedDescription.UTF8String;
            std::shared_ptr<QError> err(new QError(int(error.code), msg));
            handle(nullptr,int(remain), err);
        } else {
            std::shared_ptr<std::vector<std::string>> list(new std::vector<std::string>());
            for (NSString*str in responseObject) {
                list->push_back(std::string(str.UTF8String));
            }
            handle(list,int(remain), nullptr);
        }
    }];
}

void QUmeng_iOS:: removeTags(std::vector<std::string> &tags ,TagCallback handle)
{
    NSMutableArray *ts = [NSMutableArray new];
    for (int i = 0; i < tags.size(); ++i) {
        std::string str = tags[i];
        [ts addObject:toNSString(str)];
    }
    
    [UMessage removeTag:ts response:^(id responseObject, NSInteger remain, NSError *error) {
        if (error) {
            std::string msg = error.localizedDescription.UTF8String;
            std::shared_ptr<QError> err(new QError(int(error.code), msg));
            handle(nullptr,int(remain), err);
        } else {
            std::shared_ptr<std::vector<std::string>> list(new std::vector<std::string>());
            for (NSString*str in responseObject) {
                list->push_back(std::string(str.UTF8String));
            }
            handle(list,int(remain), nullptr);
        }
    }];
}


void QUmeng_iOS:: removeAllTags(TagCallback handle)
{
    [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
        if (error) {
            std::string msg = error.localizedDescription.UTF8String;
            std::shared_ptr<QError> err(new QError(int(error.code), msg));
            handle(nullptr,int(remain), err);
        } else {
            std::shared_ptr<std::vector<std::string>> list(new std::vector<std::string>());
            for (NSString*str in responseObject) {
                list->push_back(std::string(str.UTF8String));
            }
            handle(list,int(remain), nullptr);
        }
    }];
}


void QUmeng_iOS:: addAlias(std::string name, std::string type, ReqCallback callback)
{
    NSString* tp = nil;
    if (type.length()) {
        tp = toNSString(type);
    } else {
        tp = @"apple";
    }
    
    [UMessage addAlias:toNSString(name) type:toNSString(type) response:^(id responseObject, NSError *error) {
        if (error) {
            std::string msg = error.localizedDescription.UTF8String;
            std::shared_ptr<QError> err(new QError(int(error.code), msg));
            callback(err);
        }else{
            callback(nullptr);
        }
    }];
}

void QUmeng_iOS:: removeAlias(std::string name, std::string type, ReqCallback handle)
{
    NSString* tp = nil;
    if (type.length()) {
        tp = toNSString(type);
    } else {
        tp = @"apple";
    }
    
    [UMessage removeAlias:toNSString(name) type:toNSString(type) response:^(id responseObject, NSError *error) {
        if (error) {
            std::string msg = error.localizedDescription.UTF8String;
            std::shared_ptr<QError> err(new QError(int(error.code), msg));
            handle(err);
        }else{
            handle(nullptr);
        }
    }];
}


//======== 社会化部分 =========//


void QUmeng_iOS:: setSocialLogEnabled(bool value)
{
    [UMSocialData openLog:value];
}

void QUmeng_iOS:: setWXAppId(std::string app_Id ,std::string appSecret , std::string url)
{
    [UMSocialWechatHandler setWXAppId:toNSString(app_Id) appSecret:toNSString(appSecret) url:toNSString(url)];
}

void QUmeng_iOS:: openSSOWithRedirectURL(std::string redirectURL)
{
    [UMSocialSinaHandler openSSOWithRedirectURL:toNSString(redirectURL)];
}

void QUmeng_iOS:: setQQWithAppId(std::string appId, std::string appKey, std::string url)
{
    [UMSocialQQHandler setQQWithAppId:toNSString(appId) appKey:toNSString(appKey) url:toNSString(url)];
}


void QUmeng_iOS:: setQQSupportWebView(bool supportWebView)
{
    [UMSocialQQHandler setSupportWebView:supportWebView];
}


void QUmeng_iOS:: setFacebookAppID(std::string appID, std::string urlString)
{
    [UMSocialFacebookHandler setFacebookAppID:toNSString(appID) shareFacebookWithURL:toNSString(urlString)];
}


void QUmeng_iOS:: openTwitter()
{
    [UMSocialTwitterHandler openTwitter];
}


void QUmeng_iOS:: presentSnsIconSheetView(std::string shareText,std::string s_url,std::string shareImage, std::list<int>& snsNames, ReqCallback callback)
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!vc) {
        NSLog(@"[UIApplication sharedApplication].keyWindow.rootViewController = nil");
        std::string msg = "[UIApplication sharedApplication].keyWindow.rootViewController = nil";
        std::shared_ptr<QError> err(new QError(int(UMSResponseCodeFaild), msg));
        callback(err);
        return;
    }
    
    UIImage *image = nil;
    NSString* nShareText = toNSString(shareText);
    NSMutableArray *names = [NSMutableArray new];
    if (shareImage.length()) {
        NSString* path = toNSString(shareImage);
        image = [UIImage imageWithContentsOfFile:path];
    }
    
    for (std::list<int>::iterator it = snsNames.begin(); it != snsNames.end(); ++it) {
        [names addObject: SNS_NAMES[ *it ]];
    }
    
    static SocialSnsDelegate* delegate = nil;
    if (!delegate) {
        delegate = [[SocialSnsDelegate  alloc]init];
    }
    
    if (s_url.length()) {
        nShareText = [nShareText stringByAppendingFormat:@"$$$%s", s_url.c_str()];
    }
    
    delegate->callback = callback;
    [UMSocialSnsService presentSnsIconSheetView:vc appKey:toNSString(m_appkey) shareText:nShareText shareImage:image shareToSnsNames:names delegate:delegate];
    //[UMSocialSnsService presentSnsController:vc appKey:toNSString(m_appkey) shareText:toNSString(shareText) shareImage:image shareToSnsNames:names delegate:delegate];
}


void QUmeng_iOS::postSNSWithTypes(QUMengShare platformTypes, std::string content,std::string s_url, std::string imagePath, std::string urlResource, ReqCallback callback)
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!vc) {
        NSLog(@"[UIApplication sharedApplication].keyWindow.rootViewController = nil");
        std::string msg = "[UIApplication sharedApplication].keyWindow.rootViewController = nil";
        std::shared_ptr<QError> err(new QError(int(UMSResponseCodeFaild), msg));
        callback(err);
        return;
    }
    
    UIImage *image = nil;
    NSString* platform = SNS_NAMES[platformTypes];
    NSString* text = toNSString(content);
    UMSocialUrlResource* url = nil;
    if (s_url.length()){
        if (platformTypes == QUMShareToWechatSession || platformTypes == QUMShareToWechatTimeline || platformTypes == QUMShareToWechatFavorite) {
            [[UMSocialWechatHandler shareInstance] setWxUrl:toNSString(s_url)];
        } else if(platformTypes == QUMShareToQQ || platformTypes == QUMShareToQzone){
            [[UMSocialQQHandler shareInstance] setQqUrl:toNSString(s_url)];
        } else {
            text = [text stringByAppendingString:toNSString(s_url)];
        }
    }
    
    
    if (urlResource.length()) {
        url = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:toNSString(urlResource)];
    }
    
    if (imagePath.length()) {
        NSString* path = toNSString(imagePath);
        image = [UIImage imageWithContentsOfFile:path];
    }
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[platform] content:text image:image location:nil urlResource:url presentedController:vc completion:^(UMSocialResponseEntity *response) {
        /*
        if (response.responseCode == UMSResponseCodeSuccess) {
            std::shared_ptr<QError> err(new QError(int(UMSResponseCodeSuccess), ""));
            callback(err);
        } else {
            std::shared_ptr<QError> err(new QError(int(response.responseCode), response.message.UTF8String));
            callback(err);
        }
         */
        
        std::shared_ptr<QError> err(new QError(int(response.responseCode), response.message.UTF8String));
        callback(err);
    }];
    
}
