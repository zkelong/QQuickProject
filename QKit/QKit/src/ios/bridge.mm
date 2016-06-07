#import <AdSupport/AdSupport.h>
#import <AVFoundation/AVFoundation.h>
#import "UIKit/UIKit.h"
#include "bridge.h"

QString bridge_get_uuid()
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId.UTF8String;
}


void set_speaker(bool value)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(value){
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        } else {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
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
    return [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]].UTF8String;
}

bool bridge_openUrl(QString url)
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url.toNSString()]];
}
