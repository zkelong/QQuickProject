//
//  SocialSnsDelegate.h
//  UmengQt
//
//  Created by fu yuming on 5/22/15.
//  Copyright (c) 2015 fu yuming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"
#include "QUmeng.h"

@interface SocialSnsDelegate : NSObject <UMSocialUIDelegate>
{
    @public
    QUmeng::ReqCallback callback;
}
@end
