#include "kweixinpaylistenner.h"
#include <QMutex>
#include <QList>

static QList<KWeixinpayListenner*> s_weixinpay_listenners;
static QMutex       s_weixinpay_lock;

void addWeixinpayListenner(KWeixinpayListenner* listenner);
void removeWeixinpayListenner(KWeixinpayListenner* listenner);

KWeixinpayListenner::KWeixinpayListenner(QObject *parent) : QObject(parent)
{
    addWeixinpayListenner(this);
}

KWeixinpayListenner::~KWeixinpayListenner()
{
    removeWeixinpayListenner(this);
}

void weixinpay_emit_pay_result(int code)
{
    s_weixinpay_lock.lock();
    for(auto i = s_weixinpay_listenners.begin(); i != s_weixinpay_listenners.end(); ++i){
        emit (*i)->payResult(code);
    }
    s_weixinpay_lock.unlock();
}

//添加监听
void addWeixinpayListenner(KWeixinpayListenner* listenner)
{
    s_weixinpay_lock.lock();
    s_weixinpay_listenners.append(listenner);
    s_weixinpay_lock.unlock();
}

//移除监听
void removeWeixinpayListenner(KWeixinpayListenner* listenner)
{
    s_weixinpay_lock.lock();
    for(auto i = s_weixinpay_listenners.begin(); i != s_weixinpay_listenners.end(); ++i){
        if( (*i) == listenner ){
            s_weixinpay_listenners.erase(i);
            break;
        }
    }
    s_weixinpay_lock.unlock();
}
