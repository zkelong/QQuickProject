//
//  SocialSnsDelegate.m
//  UmengQt
//
//  Created by fu yuming on 5/22/15.
//  Copyright (c) 2015 fu yuming. All rights reserved.
//

#import "SocialSnsDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialFacebookHandler.h"
#import "UMSocialTwitterHandler.h"

@implementation SocialSnsDelegate

/**
 自定义关闭授权页面事件
 
 @param navigationCtroller 关闭当前页面的navigationCtroller对象
 
 */
-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService
{
    NSLog(@"Umeng social: closeOauthWebViewController");
    return YES;
}

/**
 关闭当前页面之后
 
 @param fromViewControllerType 关闭的页面类型
 
 */
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"Umeng social: didCloseUIViewController");
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"Umeng social: didFinishGetUMSocialDataInViewController");
}


/**
 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 例如：
 
 -(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
 {
 if (platformName == UMShareToSina) {
 socialData.shareText = @"分享到新浪微博的文字内容";
 }
 else{
 socialData.shareText = @"分享到其他平台的文字内容";
 }
 }
 
 @param platformName 点击分享平台
 
 @prarm socialData   分享内容
 */
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    NSArray * coms = [socialData.shareText componentsSeparatedByString:@"$$$"];
    if(coms.count > 1){
        if (platformName == UMShareToWechatSession || UMShareToWechatTimeline == platformName || UMShareToWechatFavorite == platformName ) {
            NSLog(@"****************** shareTo %@",platformName);
            
            [[UMSocialWechatHandler shareInstance] setWxUrl:coms[1]];
        } else if (platformName == UMShareToQQ || platformName == UMShareToQzone){
            NSLog(@"################## shareTo %@",platformName);
            [[UMSocialQQHandler shareInstance] setQqUrl:coms[1]];
        }
        socialData.shareText = coms[0];
    }
    
   
    NSLog(@"Umeng social: didSelectSocialPlatform");
}

/**
 配置点击分享列表后是否弹出分享内容编辑页面，再弹出分享，默认需要弹出分享编辑页面
 
 @result 设置是否需要弹出分享内容编辑页面，默认需要
 
 */
-(BOOL)isDirectShareInIconActionSheet
{
    return NO;
}
@end
