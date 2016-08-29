#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JPUSHService.h"

#include <QObject>
#include "kjpush_bridge.h"

extern NSDictionary* s_launchingOption;


void jpush_init()
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        //可以添加 categories
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    }
    [JPUSHService setupWithOption:s_launchingOption];
}

void jpush_setDebugMode(bool value)
{
    if (value) {
        [JPUSHService setDebugMode];
    } else {
        [JPUSHService setLogOFF];
    }
    
}


void jpush_setAlias(QString alias)
{
    [JPUSHService setAlias:alias.toNSString() callbackSelector:nil object:nil];
}

void jpush_setTags(QVariantList tags)
{
    NSMutableSet* nst = [[[NSMutableSet alloc]init] autorelease];
    for(auto it = tags.begin(); it != tags.end(); ++it){
        [nst addObject:(*it).toString().toNSString()];
    }
    [JPUSHService setTags:nst callbackSelector:nil object:nil];
    
}

void jpush_clearAllNotifications()
{
    [JPUSHService resetBadge];
    [JPUSHService clearAllLocalNotifications];
}

