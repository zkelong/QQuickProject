#ifndef KJPUSH_BRIDGE_H
#define KJPUSH_BRIDGE_H
#include <qobject.h>
#include <QVariantList>

void jpush_init();
void jpush_setDebugMode(bool value);
void jpush_setAlias(QString alias);
void jpush_setTags(QVariantList tags);
void jpush_clearAllNotifications();

#endif // KJPUSH_H

