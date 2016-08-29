#include "kAppStore.h"
#include "kAppStore_bridge.h"


KAppStore::KAppStore(QObject *parent) : QObject(parent)
{

}

KAppStore* KAppStore::instance()
{
    static KAppStore s_instance;
    return &s_instance;
}

void KAppStore::init()
{
    
#if defined(Q_OS_IOS)
    appstore_init();
#endif
}



void KAppStore::pay(QString productId)
{
#if defined(Q_OS_IOS)
    appstore_pay(productId);
    
#endif
}
