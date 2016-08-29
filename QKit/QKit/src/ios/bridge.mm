#import <AdSupport/AdSupport.h>
#import <AVFoundation/AVFoundation.h>
#import "UIKit/UIKit.h"
#import "HYBPhotoPickerManager.h"
#include "bridge.h"
#include "qkit.h"
#include "kfiletools.h"

QString bridge_get_uuid()
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId.UTF8String;
}


void set_speaker(bool value)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AVAudioSession *session = [AVAudioSession sharedInstance];
        if(value){
            //[session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
            [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        } else {
            //[session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        }
        
        NSError *activeSetError = nil;
        [[AVAudioSession sharedInstance] setActive:YES
                          error:&activeSetError];
        
        if (activeSetError) {
            NSLog(@"Error activating AVAudioSession: %@", activeSetError);
        }
    });
    
}

bool is_speaker()
{
    return [AVAudioSession sharedInstance] .category == AVAudioSessionCategoryPlayback ;
}

void setStatusBarStye(int stye)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyle)stye];
    });
    
}

QString bridge_getAppVersionName()
{
    NSString *v = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return v.UTF8String;
}

QString bridge_getAppVersionCode()
{
    NSString *v = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return v.UTF8String;
}

QString bridge_getMetaDataForKey(QString key)
{
    NSString *v = [[NSBundle mainBundle] objectForInfoDictionaryKey:key.toNSString()];
    if (v) {
        return [NSString stringWithFormat:@"%@", v].UTF8String;
    }
    return "";
}

bool bridge_openUrl(QString url)
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url.toNSString()]];
}


void set_application_icon_badge_number(int val){
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:val];
}

QString get_user_agent()
{
    static QString s_agent;
    if(s_agent.length() > 0){
        return s_agent;
    }

    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectZero];
    NSString *agent = [web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    s_agent = agent.UTF8String;
    return s_agent;
}


void take_image(bool editing, TakeImageCallback callback)
{
    [[HYBPhotoPickerManager shared] takeImage:nil editing:editing completion:^(UIImage *image) {
        
        NSData *d = UIImageJPEGRepresentation(image, 0.9);

        QString path = QKit::instance()->runTimeCachePath() + "/" + QKit::instance()->randString(5) + ".jpg";
        [d writeToFile:path.toNSString() atomically: NO];
        //KFileTools::instance()->rotateImage(path, 90);
        callback(path);
    } cancelBlock:^{
        callback("");
    }];
}
