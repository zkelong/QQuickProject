#include "acameracall.h"
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <QPushButton>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QDebug>
#include <QAndroidActivityResultReceiver>
#include <QDateTime>
#include <QFile>
#include <QDebug>

using namespace QtAndroid;

#define CHECK_EXCEPTION() \
    if(env->ExceptionCheck())\
{\
    qDebug() << "exception occured";\
    env->ExceptionClear();\
    }

class ACameraCall;
class ResultReceiver : public QAndroidActivityResultReceiver
{
public:
    ResultReceiver()
    {

    }
    //处理返回结果
    void handleActivityResult(
            int receiverRequestCode,
            int resultCode,
            const QAndroidJniObject & data)
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
        }
    }

    static const int ReceiverRequestCode;
    QString m_imagePath;
    ACameraCall* notify;
};
const int ResultReceiver::ReceiverRequestCode = 1;
static ResultReceiver* receiver = new ResultReceiver();


ACameraCall::ACameraCall(QObject *parent) : QObject(parent)
{

}

ACameraCall::~ACameraCall()
{

}

void ACameraCall::takePhoto()
{
    QAndroidJniEnvironment env;

    //拍照activity
    QAndroidJniObject action = QAndroidJniObject::fromString(
                "android.media.action.IMAGE_CAPTURE");
    QAndroidJniObject intent("android/content/Intent",
                             "(Ljava/lang/String;)V",
                             action.object<jstring>());


    //文件名，存储路径
    QString date = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
    QAndroidJniObject fileName = QAndroidJniObject::fromString(date + ".jpg");
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
    startActivity(intent,
                  ResultReceiver::ReceiverRequestCode,
                  receiver);
    CHECK_EXCEPTION()
}



