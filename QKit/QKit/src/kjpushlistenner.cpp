#include <QMutex>
#include "kjpushlistenner.h"

static QList<KJPushListenner*> s_jpush_listenners;
static QMutex       s_jpush_lock;

KJPushListenner::KJPushListenner(QObject *parent) : QObject(parent)
{
    s_jpush_lock.lock();
    s_jpush_listenners.append(this);
    s_jpush_lock.unlock();
}

KJPushListenner::~KJPushListenner()
{
    s_jpush_lock.lock();
    for(auto it = s_jpush_listenners.begin(); it != s_jpush_listenners.end(); ++it){
        if(*it == this){
            s_jpush_listenners.erase(it);
            break;
        }
    }
    s_jpush_lock.unlock();
}


void _emit_onReceiveNotification(const char* message, const char* extras)
{
    s_jpush_lock.lock();
    for(auto it = s_jpush_listenners.begin(); it != s_jpush_listenners.end(); ++it){
        emit (*it)->receiveNotification(message, extras);
    }
    s_jpush_lock.unlock();
}
