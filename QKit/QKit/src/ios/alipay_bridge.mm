#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "JSONKit.h"


#include "../alipay_bridge.h"
#include <QJsonDocument>
#include <QVariant>
#include "kalipaylistenner.h"

static NSString* s_alipay_partner = nil;
static NSString* s_alipay_seller = nil;
static NSString* s_alipay_privateKey = nil;
static NSString* s_alipay_notifyUrl = nil;
static NSString* s_alipay_iosAppScheme = nil;

void alipay_init(QString partner, QString seller, QString privateKey, QString notifyUrl, QString iosAppScheme)
{
    s_alipay_partner = [partner.toNSString() retain];
    s_alipay_seller = [seller.toNSString() retain];
    s_alipay_privateKey = [privateKey.toNSString() retain];
    s_alipay_notifyUrl = [notifyUrl.toNSString() retain];
    s_alipay_iosAppScheme = [iosAppScheme.toNSString() retain];
}

void alipay_pay(QString tradeNO, QString productName, QString productDescription, QString amount)
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[[Order alloc] init] autorelease];
    order.partner = s_alipay_partner;
    order.seller = s_alipay_seller;
    order.tradeNO = tradeNO.toNSString(); //订单ID（由商家自行制定）
    order.productName = productName.toNSString(); //商品标题
    order.productDescription = productDescription.toNSString(); //商品描述
    order.amount = amount.toNSString(); //商品价格
    order.notifyURL =  s_alipay_notifyUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(s_alipay_privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:s_alipay_iosAppScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString* str = [resultDic JSONString];
            QJsonDocument job = QJsonDocument::fromJson(str.UTF8String);
            QVariant ret = job.toVariant();
            alipay_emit_pay_result(ret);
        }];
        
    }
}
