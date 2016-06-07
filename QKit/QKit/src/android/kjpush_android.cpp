#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <jni.h>
#include <QtDebug>
#include "kjpush_bridge.h"

extern void _emit_onReceiveNotification(const char* message, const char* extras);

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT void JNICALL Java_qkit_PushReceiver_onReceiveNotification(JNIEnv *env, jclass, jstring jmessage, jstring jextras)
{
    const char* message = env->GetStringUTFChars(jmessage,NULL);
    const char* extras = env->GetStringUTFChars(jextras,NULL);
    qDebug() << "********** Java_qkit_PushReceiver_onReceiveNotification" << " message:" << message << " extras:" << extras;
    _emit_onReceiveNotification(message, extras);

}

#ifdef __cplusplus
}
#endif


void jpush_init()
{
    QAndroidJniObject::callStaticMethod<void>("qkit/KJPush","init","()V");
}

void jpush_setDebugMode(bool value)
{
    QAndroidJniObject::callStaticMethod<void>("qkit/KJPush","setDebugMode","(Z)V", (jboolean)value);
}


void jpush_setAlias(QString alias)
{
    QAndroidJniObject jalias = QAndroidJniObject::fromString(alias);
    QAndroidJniObject::callStaticMethod<void>("qkit/KJPush","setAlias","(Ljava/lang/String;)V", jalias.object<jstring>());
}

void jpush_setTags(QVariantList tags)
{
    QString st;
    for(auto it = tags.begin(); it != tags.end(); ++it){
        st += (*it).toString() + ",";
    }
    st.remove(st.length()-1, 1);
    qDebug() << "******************* st=" << st;
    QAndroidJniObject jst = QAndroidJniObject::fromString(st);
    QAndroidJniObject::callStaticMethod<void>("qkit/KJPush","setTags","(Ljava/lang/String;)V", jst.object<jstring>());
}

void jpush_clearAllNotifications()
{
    QAndroidJniObject::callStaticMethod<void>("qkit/KJPush","clearAllNotifications","()V");
}
