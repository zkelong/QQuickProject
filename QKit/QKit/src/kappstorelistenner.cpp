#include "kappstorelistenner.h"
#include <QMutex>
#include <QList>

static QList<KAppStoreListenner*> s_listenners;
static QMutex       s_lock;

void addAppStoreListenner(KAppStoreListenner* listenner);
void removeAppStoreListenner(KAppStoreListenner* listenner);

KAppStoreListenner::KAppStoreListenner(QObject *parent) : QObject(parent)
{
    addAppStoreListenner(this);
}

KAppStoreListenner::~KAppStoreListenner()
{
    removeAppStoreListenner(this);
}

void appstore_emit_pay_result(QString receipt)
{
    s_lock.lock();
    for(auto i = s_listenners.begin(); i != s_listenners.end(); ++i){
        emit (*i)->payResult(receipt);
    }
    s_lock.unlock();
}

//添加监听
void addAppStoreListenner(KAppStoreListenner* listenner)
{
    s_lock.lock();
    s_listenners.append(listenner);
    s_lock.unlock();
}

//移除监听
void removeAppStoreListenner(KAppStoreListenner* listenner)
{
    s_lock.lock();
    for(auto i = s_listenners.begin(); i != s_listenners.end(); ++i){
        if( (*i) == listenner ){
            s_listenners.erase(i);
            break;
        }
    }
    s_lock.unlock();
}
