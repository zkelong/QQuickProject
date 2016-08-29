//
//  weixin_bridge.m
//  CallCenter
//
//  Created by Yuming on 5/19/16.
//
//

#include "../weixin_bridge.h"
#import <Foundation/Foundation.h>
#import "WXApiManager.h"
#include "kweixinpay.h"
#include "kweixinpaylistenner.h"

static NSString* s_weinxin_partnerId = nil;
static NSString* s_weinxin_package = nil;

void weixin_init(QString appId, QString partnerId, QString package)
{
    s_weinxin_partnerId = [partnerId.toNSString() retain];
    s_weinxin_package = [package.toNSString() retain];
}

void weixin_pay(QString tradeNO, QString nonceStr,QString timestamp, QString sign)
{
    [[WXApiManager sharedManager] pay:s_weinxin_partnerId prepayId:tradeNO.toNSString()  nonceStr:nonceStr.toNSString() timestamp:timestamp.toNSString().integerValue package:s_weinxin_package sign:sign.toNSString() callback:^(int code) {
        weixinpay_emit_pay_result(code);
    }];
}
