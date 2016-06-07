#include "kalipay.h"
#include "alipay_bridge.h"

KAlipay::KAlipay(QObject *parent) : QObject(parent)
{

}

KAlipay* KAlipay::instance()
{
    static KAlipay s_instance;
    return &s_instance;
}

void KAlipay::init(QString partner, QString seller, QString privateKey, QString notifyUrl, QString iosAppScheme)
{
    m_partner = partner;
    m_seller = seller;
    m_privateKey = privateKey;
    m_notifyUrl = notifyUrl;
    m_iosAppScheme = iosAppScheme;
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    alipay_init(partner, seller, privateKey, notifyUrl, iosAppScheme);
#endif
}

void KAlipay::pay(QString tradeNO, QString productName,QString productDescription, QString amount)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    alipay_pay(tradeNO, productName, productDescription, amount);
#endif
}
