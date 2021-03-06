#import <ShareSDK/ShareSDK.h>
#import "appdelegate_hook.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "JPUSHService.h"
#import "JSONKit.h"
#import <AlipaySDK/AlipaySDK.h>
#import <ShareSDKInterfaceAdapter/ShareSDK+InterfaceAdapter.h>

#include "application_state.h"
#include "kalipaylistenner.h"
#include <QJsonDocument>
#include <QVariant>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <AVFoundation/AVFoundation.h>

#import "WXApiManager.h"

#include "kphonestatelistener.h"


extern void _emit_onReceiveNotification(const char* message, const char* extras);
extern void phone_emit_state_changed(int state);

extern void set_speaker(bool value);
extern bool is_headset_open();
bool _get_speaker_is_open();

static AppdelegateHook* s_appdelegate_hook = nil;
static int64_t s_start_time = 0;
NSDictionary* s_launchingOption = nil;

static IMP handleOpenURL_imp = NULL;
static IMP openURL_imp = NULL;
static IMP didRegisterForRemoteNotificationsWithDeviceToken_imp = NULL;
static IMP didFailToRegisterForRemoteNotificationsWithError_imp = NULL;
static IMP didReceiveRemoteNotification_imp = NULL;
static IMP didReceiveRemoteNotification_Fetch_imp = NULL;

static bool is_headset = false;

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
    s_start_time = (int64_t)[[NSDate new]timeIntervalSince1970];

    s_launchingOption = [[NSDictionary alloc]initWithDictionary:launchingOption];
    
    [NSThread detachNewThreadSelector:@selector(_swizzle) toTarget:self withObject:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];

    callCenter.callEventHandler=^(CTCall* call){

        if (call.callState == CTCallStateDialing){
            NSLog(@"Call Dialing");
            phone_emit_state_changed(KPhoneStateListener::CALL_STATE_RINGING);
        }
        if (call.callState == CTCallStateConnected){
            NSLog(@"Call Connected");
            phone_emit_state_changed(KPhoneStateListener::CALL_STATE_OFFHOOK);
        }
        if (call.callState == CTCallStateDisconnected){
            
            NSLog(@"Call Disconnected");
            phone_emit_state_changed(KPhoneStateListener::CALL_STATE_IDLE);

        }

    };
    
    
    AudioSessionInitialize (NULL, NULL, NULL, NULL);
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback,self);
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


void audioRouteChangeListenerCallback (
                                       void                      *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueS,
                                       const void                *inPropertyValue
                                       ) {
    
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    CFStringRef state = nil;
    
    //获取音频路线
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);//kAudioSessionProperty_AudioRoute：音频路线
    NSLog(@"%@",(NSString *)state);//Headphone 耳机  Speaker 喇叭.
    if ([(NSString*)state hasPrefix:@"Head"]) {
        if(is_headset) return;
        
        is_headset = true;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        });
        
        
    } else {
        if(!is_headset) return;
        
        is_headset = false;
        if (_get_speaker_is_open()) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            });
            
        }
    }
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
    
    if(!ret) {
        ret = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
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
    
    if(!ret) {
        ret = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
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
    [JPUSHService registerDeviceToken:deviceToken];
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
    [JPUSHService  handleRemoteNotification:userInfo];
    
    if (didReceiveRemoteNotification_imp) {
        didReceiveRemoteNotification_func func = (didReceiveRemoteNotification_func)didReceiveRemoteNotification_imp;
        func(application.delegate, @selector(application:didReceiveRemoteNotification:),application,userInfo);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"*************** didReceiveRemoteNotification: %@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    
    
    /*
     NSMutableDictionary* extra = [NSMutableDictionary dictionaryWithDictionary:userInfo];
     [extra removeObjectForKey:@"aps"];
     NSString* content = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    int64_t time = (int64_t)[[NSDate new]timeIntervalSince1970];
    int dur = (int)(time - s_start_time);
    if(s_start_time > 0 && dur > 3000){ //启动3秒的推送才发消息,防止crash
        _emit_onReceiveNotification(content.UTF8String, extra.JSONString.UTF8String);
    }
    */
    
    if (didReceiveRemoteNotification_Fetch_imp) {
        didReceiveRemoteNotification_fetch_func func = (didReceiveRemoteNotification_fetch_func)didReceiveRemoteNotification_Fetch_imp;
        func(application.delegate, @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:),application,userInfo, completionHandler);
    } else {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}
@end
