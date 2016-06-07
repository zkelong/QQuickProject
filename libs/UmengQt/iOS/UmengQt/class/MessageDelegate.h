//
//  MessageDelegate.h
//  UmengQt
//
//  Created by fu yuming on 5/22/15.
//  Copyright (c) 2015 fu yuming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClick.h"

@interface MessageDelegate : NSObject

+ (instancetype) instance;

/** 初始化友盟统计模块
 @param appKey 友盟appKey.
 @param reportPolicy 发送策略, 默认值为：BATCH，即“启动发送”模式
 @param channelId 渠道名称,为nil或@""时, 默认为@"App Store"渠道
 @return void
 */
- (void)startWithAppkey:(NSString *)appKey reportPolicy:(ReportPolicy)rp channelId:(NSString *)cid;

@property (nonatomic, retain) NSString* appkey;
@property (nonatomic, assign) ReportPolicy reportPolicy;
@property (nonatomic, retain) NSString* channelId;
@end
