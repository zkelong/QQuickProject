#include "kphonestatelistener.h"
#include <QMutex>
#include <QList>
#include <QDebug>

static QList<KPhoneStateListener*> s_phone_listenners;
static QMutex       s_phone_lock;

void addPhoneStateListenner(KPhoneStateListener* listenner);
void removePhoneStateListenner(KPhoneStateListener* listenner);

KPhoneStateListener::KPhoneStateListener(QObject *parent) : QObject(parent)
{
    addPhoneStateListenner(this);
}

KPhoneStateListener::~KPhoneStateListener()
{
    removePhoneStateListenner(this);
}

void phone_emit_state_changed(int state)
{
    qDebug() << "phone_emit_state_changed " << s_phone_listenners.length();
    s_phone_lock.lock();
    for(auto i = s_phone_listenners.begin(); i != s_phone_listenners.end(); ++i){
        emit (*i)->phoneStateChanged(state);
    }
    s_phone_lock.unlock();
}

//添加监听
void addPhoneStateListenner(KPhoneStateListener* listenner)
{
    s_phone_lock.lock();
    s_phone_listenners.append(listenner);
    s_phone_lock.unlock();
}

//移除监听
void removePhoneStateListenner(KPhoneStateListener* listenner)
{
    s_phone_lock.lock();
    for(auto i = s_phone_listenners.begin(); i != s_phone_listenners.end(); ++i){
        if( (*i) == listenner ){
            s_phone_listenners.erase(i);
            break;
        }
    }
    s_phone_lock.unlock();
}
