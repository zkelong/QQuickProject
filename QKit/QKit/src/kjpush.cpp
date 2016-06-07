#include "kjpush.h"
#include "kjpush_bridge.h"

KJPush::KJPush(QObject *parent) : QObject(parent)
{

}

KJPush* KJPush::instance()
{
    static KJPush s_jpush;
    return &s_jpush;
}

void KJPush::init()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    jpush_init();
#endif
}
void KJPush::setDebugMode(bool value)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    jpush_setDebugMode(value);
#endif
}

void KJPush::setAlias(QString alias)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    jpush_setAlias(alias);
#endif
}

void KJPush::setTags(QVariantList tags)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    jpush_setTags(tags);
#endif
}

void KJPush::clearAllNotifications()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    jpush_clearAllNotifications();
#endif
}
