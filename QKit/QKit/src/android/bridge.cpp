#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <jni.h>
#include <QDebug>
#include "bridge.h"

static TakeImageCallback take_image_callback = nullptr;
extern void phone_emit_state_changed(int state);

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT void JNICALL Java_qkit_KActivity_onImageTook(JNIEnv *env, jclass, jstring path)
{
    const char* str = env->GetStringUTFChars(path,NULL);
    qDebug() << "Java_qkit_KActivity_onImageTook:" << str;
    if(take_image_callback){
        take_image_callback(str);
        take_image_callback = nullptr;
    }
}


JNIEXPORT void JNICALL Java_qkit_KActivity_onPhoneStateChanged(JNIEnv *env, jclass, jint state)
{

    qDebug() << "Java_qkit_KActivity_onPhoneStateChanged:" << state;
    phone_emit_state_changed(state);
}

#ifdef __cplusplus
}
#endif


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

QString bridge_getAppVersionCode()
{
    QAndroidJniObject  ret = QAndroidJniObject::callStaticObjectMethod("qkit.KActivity","getAppVersionCode","()Ljava/lang/String;");

    return ret.toString();
}

QString bridge_getMetaDataForKey(QString key)
{
    QAndroidJniObject jkey = QAndroidJniObject::fromString(key);
    QAndroidJniObject  ret = QAndroidJniObject::callStaticObjectMethod("qkit.KActivity","getMetaDataForKey","(Ljava/lang/String;)Ljava/lang/String;",
        jkey.object<jstring>());

    return ret.toString();
}

bool bridge_openUrl(QString url)
{
    return false;
}


void bridge_openSettings(QString name)
{
    QAndroidJniObject jname = QAndroidJniObject::fromString(name);

    QAndroidJniObject::callStaticMethod<void>("qkit.KActivity",
                                              "openSettings",
                                              "(Ljava/lang/String;)V",
                                              jname.object<jstring>());
}


QStringList bridge_getLocalImages()
{
    QAndroidJniObject  ret = QAndroidJniObject::callStaticObjectMethod("qkit.KActivity","getLocalImages","()Ljava/util/ArrayList;");

    jint len = ret.callMethod<jint>("size", "()I");

    QStringList paths;
    for(int i = 0; i < len; ++i){
        QAndroidJniObject obj = ret.callObjectMethod("get", "(I)Ljava/lang/Object;", i);
        QString str = obj.toString();
        paths.append(str);
    }
    //qDebug() << paths;
    return paths;
}

void set_application_icon_badge_number(int val){
    QAndroidJniObject::callStaticMethod<void>("qkit.KActivity",
                                              "setApplicationIconBadgeNumber",
                                              "(I)V",
                                              val);
}


QString get_user_agent()
{
    QAndroidJniObject  ret = QAndroidJniObject::callStaticObjectMethod("qkit.KActivity","getUserAgent","()Ljava/lang/String;");

    return ret.toString();
}

void take_image(bool editing, TakeImageCallback callback)
{
    take_image_callback = callback;
    QAndroidJniObject::callStaticMethod<void>("qkit.KActivity","takeImage","()V");
}
