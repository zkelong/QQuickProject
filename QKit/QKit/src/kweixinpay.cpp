#include "kweixinpay.h"
#include "weixin_bridge.h"

KWeixinpay::KWeixinpay(QObject *parent) : QObject(parent)
{

}

KWeixinpay* KWeixinpay::instance()
{
    static KWeixinpay s_instance;
    return &s_instance;
}

void KWeixinpay::init(QString appId, QString partnerId, QString package)
{
    
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    weixin_init(appId, partnerId,package);
#endif
}

void KWeixinpay::pay(QString tradeNO, QString nonceStr, QString timestamp, QString sign)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    weixin_pay(tradeNO, nonceStr, timestamp, sign);
#endif
}
