#import <ShareSDK/ShareSDK.h>
#import "appdelegate_hook.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "APService.h"
#import "JSONKit.h"
#import <AlipaySDK/AlipaySDK.h>

#include "application_state.h"
#include "kalipaylistenner.h"
#include <QJsonDocument>
#include <QVariant>


extern void _emit_onReceiveNotification(const char* message, const char* extras);

static AppdelegateHook* s_appdelegate_hook = nil;
NSDictionary* s_launchingOption = nil;

static IMP handleOpenURL_imp = NULL;
static IMP openURL_imp = NULL;
static IMP didRegisterForRemoteNotificationsWithDeviceToken_imp = NULL;
static IMP didFailToRegisterForRemoteNotificationsWithError_imp = NULL;
static IMP didReceiveRemoteNotification_imp = NULL;
static IMP didReceiveRemoteNotification_Fetch_imp = NULL;

typedef BOOL(*handleOpenURL_func)(id,SEL,UIApplication*,NSURL*);
typedef BOOL(*openURL_func)(id,SEL,UIApplication*,NSURL*,NSString *,id);
typedef void(*didRegisterForRemoteNotificationsWithDeviceToken_func)(id,SEL,UIApplication*,NSData*);
typedef void(*didReceiveRemoteNotification_func)(id,SEL,UIApplication*,NSDictionary*);
typedef void(*didReceiveRemoteNotification_fetch_func)(id,SEL,UIApplication*,NSDictionary*,void (^)(UIBackgroundFetchResult));

IMP swizzleSelector(NSObject* obj, SEL sel)
{
    Class cls = [obj class];
    Method newMethod = class_getInstanceMethod([AppdelegateHook class], sel);
    IMP newImp = method_getImplementation(newMethod);
    
    if (![obj respondsToSelector:sel]) {
        bool ok = class_addMethod(cls, sel, newImp, method_getTypeEncoding(newMethod));
        if (!ok) {
            
            NSLog(@"class_addMethod %@ failed!", NSStringFromSelector(method_getName(newMethod)));
        }
    } else {
        Method origMethod = class_getInstanceMethod(cls, sel);
        IMP origIMP = method_getImplementation(origMethod);
        method_setImplementation(origMethod, newImp);
        return origIMP;
    }
    
    return NULL;
}

@implementation AppdelegateHook

+(instancetype)instance
{
    if (!s_appdelegate_hook) {
        s_appdelegate_hook = [[AppdelegateHook alloc]init];
    }
    return s_appdelegate_hook;
}

-(void)initWithOption:(NSDictionary*)launchingOption
{
    static BOOL s_is_init = NO;
    if (s_is_init) {
        return;
    }
    s_is_init = YES;

    s_launchingOption = [[NSDictionary alloc]initWithDictionary:launchingOption];
    
    [NSThread detachNewThreadSelector:@selector(_swizzle) toTarget:self withObject:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

}


-(void)_swizzle
{
    while (![UIApplication sharedApplication].delegate) {
        
    }
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    
    handleOpenURL_imp = swizzleSelector(delegate, @selector(application:handleOpenURL:));
    openURL_imp = swizzleSelector(delegate, @selector(application:openURL:sourceApplication:annotation:));
    didRegisterForRemoteNotificationsWithDeviceToken_imp = swizzleSelector(delegate, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:));
    didFailToRegisterForRemoteNotificationsWithError_imp = swizzleSelector(delegate, @selector(application:didFailToRegisterForRemoteNotificationsWithError:));
    didReceiveRemoteNotification_imp = swizzleSelector(delegate, @selector(application:didReceiveRemoteNotification:));
    didReceiveRemoteNotification_Fetch_imp = swizzleSelector(delegate, @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:));
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"*************** applicationDidBecomeActive");
    EmitResume();
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"*************** applicationWillResignActive");
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"*************** applicationDidEnterBackground");
    EmitSuspend();
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"*************** applicationWillEnterForeground");
}


//=====  swizzle method ==============//

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"*************** handleOpenURL");
    BOOL ret = [ShareSDK handleOpenURL:url wxDelegate:self];
    if (!ret) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"alipay appdelegate result = %@",resultDic);
            NSString* str = [resultDic JSONString];
            QJsonDocument job = QJsonDocument::fromJson(str.UTF8String);
            QVariant ret = job.toVariant();
            alipay_emit_pay_result(ret);
        }];
    }
    
    if (!ret && handleOpenURL_imp) {
        handleOpenURL_func func = (handleOpenURL_func)handleOpenURL_imp;
        ret = func(application.delegate, @selector(application:handleOpenURL:), application, url);
    }
    return ret;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"*************** openURL");
    BOOL ret = [ShareSDK handleOpenURL:url  sourceApplication:sourceApplication  annotation:annotation  wxDelegate:self];
    if (!ret) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"alipay appdelegate result = %@",resultDic);
            NSString* str = [resultDic JSONString];
            QJsonDocument job = QJsonDocument::fromJson(str.UTF8String);
            QVariant ret = job.toVariant();
            alipay_emit_pay_result(ret);
        }];
    }
    if (!ret && handleOpenURL_imp) {
        openURL_func func = (openURL_func)openURL_imp;
        ret = func(application.delegate, @selector(application:openURL:sourceApplication:annotation:), application, url, sourceApplication,annotation);
    }
    return ret;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"*************** didRegisterForRemoteNotificationsWithDeviceToken:%@", deviceToken);
    [APService registerDeviceToken:deviceToken];
    if (didRegisterForRemoteNotificationsWithDeviceToken_imp) {
        didRegisterForRemoteNotificationsWithDeviceToken_func func = (didRegisterForRemoteNotificationsWithDeviceToken_func)didRegisterForRemoteNotificationsWithDeviceToken_imp;
        func(application.delegate,@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:),application,deviceToken);
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"*************** didFailToRegisterForRemoteNotificationsWithError:%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"*************** didReceiveRemoteNotification: %@",userInfo);
    [APService  handleRemoteNotification:userInfo];
    
    if (didReceiveRemoteNotification_imp) {
        didReceiveRemoteNotification_func func = (didReceiveRemoteNotification_func)didReceiveRemoteNotification_imp;
        func(application.delegate, @selector(application:didReceiveRemoteNotification:),application,userInfo);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"*************** didReceiveRemoteNotification: %@",userInfo);
    [APService handleRemoteNotification:userInfo];
    NSMutableDictionary* extra = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [extra removeObjectForKey:@"aps"];
    NSString* content = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    _emit_onReceiveNotification(content.UTF8String, extra.JSONString.UTF8String);
    
    if (didReceiveRemoteNotification_Fetch_imp) {
        didReceiveRemoteNotification_fetch_func func = (didReceiveRemoteNotification_fetch_func)didReceiveRemoteNotification_Fetch_imp;
        func(application.delegate, @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:),application,userInfo, completionHandler);
    } else {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}
@end
