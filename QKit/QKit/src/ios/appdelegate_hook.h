#ifndef APPDELEGATE_HOOK_H
#define APPDELEGATE_HOOK_H

#import <Foundation/Foundation.h>

@interface AppdelegateHook : NSObject
{
    
}

+(instancetype)instance;
-(void)initWithOption:(NSDictionary*)launchingOption;

@end

#endif // APPDELEGATE_HOOK_H

