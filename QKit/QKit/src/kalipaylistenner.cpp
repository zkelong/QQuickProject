#include "kalipaylistenner.h"
#include <QMutex>
#include <QList>

static QList<KAlipayListenner*> s_alipay_listenners;
static QMutex       s_alipay_lock;

void addAlipayListenner(KAlipayListenner* listenner);
void removeAlipayListenner(KAlipayListenner* listenner);

KAlipayListenner::KAlipayListenner(QObject *parent) : QObject(parent)
{
    addAlipayListenner(this);
}

KAlipayListenner::~KAlipayListenner()
{
    removeAlipayListenner(this);
}

void alipay_emit_pay_result(QVariant result)
{
    s_alipay_lock.lock();
    for(auto i = s_alipay_listenners.begin(); i != s_alipay_listenners.end(); ++i){
        emit (*i)->payResult(result);
    }
    s_alipay_lock.unlock();
}

//添加监听
void addAlipayListenner(KAlipayListenner* listenner)
{
    s_alipay_lock.lock();
    s_alipay_listenners.append(listenner);
    s_alipay_lock.unlock();
}

//移除监听
void removeAlipayListenner(KAlipayListenner* listenner)
{
    s_alipay_lock.lock();
    for(auto i = s_alipay_listenners.begin(); i != s_alipay_listenners.end(); ++i){
        if( (*i) == listenner ){
            s_alipay_listenners.erase(i);
            return;
        }
    }
    s_alipay_lock.unlock();
}
