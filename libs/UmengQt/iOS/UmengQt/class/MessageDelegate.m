//
//  MessageDelegate.m
//  UmengQt
//
//  Created by fu yuming on 5/22/15.
//  Copyright (c) 2015 fu yuming. All rights reserved.
//

#import "MessageDelegate.h"
#import <objc/runtime.h>
#import "UMSocial.h"
#import "UMessage.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialFacebookHandler.h"
#import "UMSocialTwitterHandler.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000


static MessageDelegate* s_msg = nil;
static BOOL s_started = NO;

static IMP handleOpenURL_imp = NULL;
static IMP openURL_imp = NULL;
static IMP didRegisterForRemoteNotificationsWithDeviceToken_imp = NULL;
static IMP didFailToRegisterForRemoteNotificationsWithError_imp = NULL;
static IMP didReceiveRemoteNotification_imp = NULL;

typedef BOOL(*handleOpenURL_func)(id,SEL,UIApplication*,NSURL*);
typedef BOOL(*openURL_func)(id,SEL,UIApplication*,NSURL*,NSString *,id);
typedef void(*didRegisterForRemoteNotificationsWithDeviceToken_func)(id,SEL,UIApplication*,NSData*);
typedef void(*didReceiveRemoteNotification_func)(id,SEL,UIApplication*,NSDictionary*);

IMP swizzleSelector(NSObject* obj, SEL sel)
{
    Class cls = [obj class];
    Method newMethod = class_getInstanceMethod([MessageDelegate class], sel);
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

@implementation MessageDelegate

+ (instancetype) instance
{
    if (!s_msg) {
        s_msg = [[MessageDelegate alloc]init];
    }
    return s_msg;
}

-(void)startWithAppkey:(NSString *)appKey reportPolicy:(ReportPolicy)rp channelId:(NSString *)cid
{
    NSLog(@"*************** startWithAppkey");

    @synchronized(self){
        if (s_started) {
            return;
        }
        self.appkey = appKey;
        self.reportPolicy = rp;
        self.channelId = cid;
        s_started = true;
//        [self regist];
        
        [NSThread detachNewThreadSelector:@selector(_swizzle) toTarget:self withObject:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
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
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!");
}

-(void) regist
{
    [MobClick startWithAppkey:self.appkey reportPolicy:self.reportPolicy channelId:self.channelId];
    [UMessage startWithAppkey:self.appkey launchOptions:nil];
    [UMSocialData setAppKey:self.appkey];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    NSLog(@"*************** applicationDidFinishLaunching");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"*************** applicationDidBecomeActive");
    [self regist];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"*************** applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"*************** applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"*************** applicationWillEnterForeground");
}


//=====  swizzle method ==============//

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"*************** handleOpenURL");
    BOOL ret = [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    if (!ret && handleOpenURL_imp) {
        handleOpenURL_func func = (handleOpenURL_func)handleOpenURL_imp;
        ret = func(application.delegate, @selector(application:handleOpenURL:), application, url);
    }
    return ret;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"*************** openURL");
    BOOL ret = [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    if (!ret && handleOpenURL_imp) {
        openURL_func func = (openURL_func)openURL_imp;
        ret = func(application.delegate, @selector(application:openURL:sourceApplication:annotation:), application, url, sourceApplication,annotation);
    }
    return ret;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"*************** didRegisterForRemoteNotificationsWithDeviceToken:%@", deviceToken);
    [UMessage registerDeviceToken:deviceToken];
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
    [UMessage didReceiveRemoteNotification:userInfo];
    if (didReceiveRemoteNotification_imp) {
        didReceiveRemoteNotification_func func = (didReceiveRemoteNotification_func)didReceiveRemoteNotification_imp;
        func(application.delegate, @selector(application:didReceiveRemoteNotification:),application,userInfo);
    }
}


@end
