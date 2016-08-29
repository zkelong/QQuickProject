#ifndef BRIDGE_H
#define BRIDGE_H

#include <qobject.h>
#include <functional>

//为qt调用android和ios平台原生方法服务

typedef std::function<void (QString path)> TakeImageCallback;

//取设备号
QString bridge_get_uuid();

//设置是否使用扬声器
void set_speaker(bool value);

//是否使用的扬声器
bool is_speaker();

void setStatusBarStye(int stye);

void android_enableTranslucentStatusBar();

QString bridge_getAppVersionName();

QString bridge_getAppVersionCode();

QString bridge_getMetaDataForKey(QString key);

bool bridge_openUrl(QString url);

void bridge_openSettings(QString name);

void set_application_icon_badge_number(int val);

QString get_user_agent();

void take_image(bool editing,TakeImageCallback callback);

#endif // BRIDGE_H

