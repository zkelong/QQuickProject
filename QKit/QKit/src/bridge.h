#ifndef BRIDGE_H
#define BRIDGE_H

#include <qobject.h>

//为qt调用android和ios平台原生方法服务

//取设备号
QString bridge_get_uuid();

//设置是否使用扬声器
void set_speaker(bool value);

//是否使用的扬声器
bool is_speaker();

void setStatusBarStye(int stye);

void android_enableTranslucentStatusBar();

QString bridge_getAppVersionName();

bool bridge_openUrl(QString url);

#endif // BRIDGE_H

