
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <jni.h>
#include <QtDebug>
#include "../application_state.h"


#ifdef __cplusplus
extern "C" {
#endif

//程序暂停时调用
JNIEXPORT void JNICALL Java_qkit_KNative_onSuspend(JNIEnv *, jclass)
{
    qDebug() << "********* Java_qkit_KNative_onSuspend";
    EmitSuspend();
}

//恢复运行时调用
JNIEXPORT void JNICALL Java_qkit_KNative_onResume(JNIEnv *, jclass)
{
    qDebug() << "********** Java_qkit_KNative_onResume";
    EmitResume();
}

JNIEXPORT void JNICALL Java_qkit_KNative_onDestroy(JNIEnv *, jclass)
{
    qDebug() << "********** Java_qkit_KNative_onDestroy";
    EmitExit();
}

#ifdef __cplusplus
}
#endif

