#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APService.h"

#include <QObject>
#include "kjpush_bridge.h"

extern NSDictionary* s_launchingOption;


void jpush_init()
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        //可以添加 categories
        [APService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    }
    [APService setupWithOption:s_launchingOption];
}

void jpush_setDebugMode(bool value)
{
    if (value) {
        [APService setDebugMode];
    } else {
        [APService setLogOFF];
    }
    
}


void jpush_setAlias(QString alias)
{
    [APService setAlias:alias.toNSString() callbackSelector:nil object:nil];
}

void jpush_setTags(QVariantList tags)
{
    NSMutableSet* nst = [[[NSMutableSet alloc]init] autorelease];
    for(auto it = tags.begin(); it != tags.end(); ++it){
        [nst addObject:(*it).toString().toNSString()];
    }
    [APService setTags:nst callbackSelector:nil object:nil];
    
}

void jpush_clearAllNotifications()
{
    [APService clearAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

