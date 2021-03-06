#include "acameracall.h"
#include <QPushButton>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QDebug>
#include <QDateTime>
#include <QFile>
#include <QDebug>

class ACameraCall;
#ifdef Q_OS_ANDROID

#define CHECK_EXCEPTION() {         \
    QAndroidJniEnvironment env;     \
    if(env->ExceptionCheck())       \
    {                               \
    qDebug() << "exception occured";\
    env->ExceptionDescribe();       \
    env->ExceptionClear();          \
    }                               \
}

const int ResultReceiverC::ReceiverRequestCode = 1;


ResultReceiverC::ResultReceiverC()
{

}
//处理返回结果
void ResultReceiverC::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data)
{
    qDebug() << "handleActivityResult, requestCode - " << receiverRequestCode
             << " resultCode - " << resultCode
             << " data - " << data.toString();
    //RESULT_OK == -1
    if(resultCode == -1 && receiverRequestCode == 1)
    {
        qDebug() << "captured image to - " << m_imagePath;
        qDebug() << "captured image exist - " << QFile::exists(m_imagePath);
        notify->succeed(m_imagePath);
    } else {
        if(!QFile::exists(m_imagePath))
        {
            emit notify->errored();
        } else {
            emit notify->errored();
        }
    }
}
#endif

ACameraCall::ACameraCall(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_ANDROID
    receiver = new ResultReceiverC();
    receiver->notify = this;
#endif
}

ACameraCall::~ACameraCall()
{

}

void ACameraCall::takePhoto()
{
#ifdef Q_OS_ANDROID

    //拍照activity
    QAndroidJniObject action = QAndroidJniObject::fromString(
                "android.media.action.IMAGE_CAPTURE");
    QAndroidJniObject intent("android/content/Intent",
                             "(Ljava/lang/String;)V",
                             action.object<jstring>());


    //文件名，存储路径
    QString date = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
    QAndroidJniObject fileName = QAndroidJniObject::fromString("DCIM/" + date + ".jpg");
    QAndroidJniObject savedDir = QAndroidJniObject::callStaticObjectMethod(
                "android/os/Environment",
                "getExternalStorageDirectory",
                "()Ljava/io/File;"
                );
    CHECK_EXCEPTION()
            qDebug() << "savedDir - " << savedDir.toString();
    QAndroidJniObject savedImageFile(
                "java/io/File",
                "(Ljava/io/File;Ljava/lang/String;)V",
                savedDir.object<jobject>(),
                fileName.object<jstring>());
    CHECK_EXCEPTION()
            qDebug() << "savedImageFile - " << savedImageFile.toString();
    QAndroidJniObject savedImageUri =
            QAndroidJniObject::callStaticObjectMethod(
                "android/net/Uri",
                "fromFile",
                "(Ljava/io/File;)Landroid/net/Uri;",
                savedImageFile.object<jobject>());

    CHECK_EXCEPTION()

    //tell IMAGE_CAPTURE the output location
    QAndroidJniObject mediaStoreExtraOutput
            = QAndroidJniObject::getStaticObjectField(
                "android/provider/MediaStore",
                "EXTRA_OUTPUT",
                "Ljava/lang/String;");
    CHECK_EXCEPTION()
    qDebug() << "MediaStore.EXTRA_OUTPUT - " << mediaStoreExtraOutput.toString();
    intent.callObjectMethod(
                "putExtra",
                "(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;",
                mediaStoreExtraOutput.object<jstring>(),
                savedImageUri.object<jobject>());

    receiver->m_imagePath = savedImageFile.toString();
    //获得拍照结果
    QtAndroid::startActivity(intent, ResultReceiverC::ReceiverRequestCode,
                  receiver);
    CHECK_EXCEPTION()
#else
    emit errored();
#endif
}

//去掉注释，编译apk
