#ifndef CALLNATIVECAMERA_P_H
#define CALLNATIVECAMERA_P_H

#include <QDebug>
#include <QFile>
#include <QDateTime>

#ifdef  Q_OS_ANDROID

#include <QAndroidActivityResultReceiver>
#include <QtAndroid>
#include <QAndroidJniEnvironment>

#define Q_SAFE_CALL_JAVA {                  \
    QAndroidJniEnvironment env;             \
    if(env->ExceptionCheck()) {             \
    qDebug() << "have a java exception";    \
    env->ExceptionDescribe();               \
    env->ExceptionClear();                  \
    }                                       \
    }

#endif

#ifdef  Q_OS_ANDROID
class CallNativeCamera;
class ResultReceiver: public QAndroidActivityResultReceiver
{
public:  //�ؼ��� explicit ���Խ�ֹ�����������캯�����������Զ�����ת����
    explicit ResultReceiver()
    { }


    void handleActivityResult(int receiverRequestCode,
                              int resultCode,
                              const QAndroidJniObject &data);

    static const int ReceiverRequestCode;
    CallNativeCamera* notify;
    QString imagePath;
};

#endif

class CallNativeCameraPrivate
{
public:
    explicit CallNativeCameraPrivate();

    ~CallNativeCameraPrivate()
    {
#ifdef  Q_OS_ANDROID
        delete resultReceiver;
#endif
    }

    void startCapture();

#ifdef  Q_OS_ANDROID
    ResultReceiver* resultReceiver;
#endif
};


#endif // CALLNATIVECAMERA_P_H

