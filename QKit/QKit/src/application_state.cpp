
#include <QMutex>
#include "application_state.h"

static QList<KApplicationListenner*> s_app_listenners;
static QMutex       s_app_lock;


//发送暂停消息
void EmitSuspend()
{
    s_app_lock.lock();
    for(auto i = s_app_listenners.begin(); i != s_app_listenners.end(); ++i){
        emit (*i)->suspend();
    }
    s_app_lock.unlock();
}

//发送恢复消息
void EmitResume()
{
    s_app_lock.lock();
    for(auto i = s_app_listenners.begin(); i != s_app_listenners.end(); ++i){
        emit (*i)->resume();
    }
    s_app_lock.unlock();
}

//发送退出消息
void EmitExit()
{
    s_app_lock.lock();
    for(auto i = s_app_listenners.begin(); i != s_app_listenners.end(); ++i){
        emit (*i)->exit();
    }
    s_app_lock.unlock();
}

//发送心跳消息
void EmitHeartbeat()
{
    s_app_lock.lock();
    for(auto i = s_app_listenners.begin(); i != s_app_listenners.end(); ++i){
        emit (*i)->heartbeat();
    }
    s_app_lock.unlock();
}

//添加监听
void addApplicationListenner(KApplicationListenner* listenner)
{
    s_app_lock.lock();
    s_app_listenners.append(listenner);
    s_app_lock.unlock();
}

//移除监听
void removeApplicationListenner(KApplicationListenner* listenner)
{
    s_app_lock.lock();
    for(auto i = s_app_listenners.begin(); i != s_app_listenners.end(); ++i){
        if( (*i) == listenner ){
            s_app_listenners.erase(i);
            return;
        }
    }
    s_app_lock.unlock();
}

