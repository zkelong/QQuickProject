#include "kAppStore_bridge.h"
#include "kappstorelistenner.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "IAPHelper.h"
#import "IAPShare.h"



void appstore_init()
{
    

    if(![IAPShare sharedHelper].iap) {
        
        NSArray *idts = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IAPS"];
        
        
        if(idts){
            NSSet* dataSet = [[NSSet alloc] initWithArray:idts];
            [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
        }
        
    }
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* ,SKProductsResponse* response)
     {
         NSLog(@"iOS AppStore products loaded: %@", response);
     }];

}

void doBuy(SKProduct *p)
{
    [[IAPShare sharedHelper].iap buyProduct:p onCompletion:^(SKPaymentTransaction* trans){
        if(trans.transactionReceipt){
            appstore_emit_pay_result([trans.transactionReceipt base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength].UTF8String);
        } else {
            appstore_emit_pay_result("");
        }
    }];
}

void appstore_pay(QString productId)
{

    SKProduct *p = nil;
    IAPHelper *iap = [IAPShare sharedHelper].iap;
    NSString *pid = productId.toNSString();
    
    for (SKProduct* o in iap.products) {
        if([o.productIdentifier isEqualToString:pid]){
            p = o;
            break;
        }
    }
    
    if (p) {
        return doBuy(p);
    }
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* ,SKProductsResponse* response)
     {
         NSLog(@"iOS AppStore products loaded: %@", response);
         if (response.products.count) {
             appstore_pay(productId);
         }
     }];
    

}
