#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <jni.h>
#include "bridge.h"

QString bridge_get_uuid()
{
    QAndroidJniObject  ret = QAndroidJniObject::callStaticObjectMethod("qkit.KActivity","getUUID","()Ljava/lang/String;");
    return ret.toString();
}


//设置是否使用扬声器
void set_speaker(bool value)
{
    if(value){
        QAndroidJniObject::callStaticMethod<void>("qkit.KActivity","openSpeaker","()V");
    } else {
        QAndroidJniObject::callStaticMethod<void>("qkit.KActivity","closeSpeaker","()V");
    }

}

//是否使用的扬声器
bool is_speaker()
{
    jboolean  ret = QAndroidJniObject::callStaticMethod<jboolean>("qkit.KActivity","isSpeaker","()Ljava/lang/String;");
    return ret;
}


void android_enableTranslucentStatusBar()
{
    QAndroidJniObject::callStaticMethod<void>("qkit.KActivity","enableTranslucentStatusBar","()V");
}

QString bridge_getAppVersionName()
{
    QAndroidJniObject  ret = QAndroidJniObject::callStaticObjectMethod("qkit.KActivity","getAppVersionName","()Ljava/lang/String;");

    return ret.toString();
}

bool bridge_openUrl(QString url)
{
    return false;
}
