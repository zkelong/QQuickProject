
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <jni.h>

QString android_getStandardPicturePath()
{
    QAndroidJniObject  ret = QAndroidJniObject::callStaticObjectMethod("qkit/FileTools","standardPicturePath","()Ljava/lang/String;");

    return ret.toString();
}
