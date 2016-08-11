#include "callnativecamera.h"
#include "callnativecamera_p.h"

//! [url](http://blog.csdn.net/foruok/article/details/43560437)

#ifdef  Q_OS_ANDROID

const int ResultReceiver::ReceiverRequestCode = 1000;

void ResultReceiver::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data)
{
#ifdef QT_DEBUG
    qDebug() << "handleActivityResult, requestCode - " << receiverRequestCode
             << " resultCode - " << resultCode
             << " data - " << data.toString();
#endif
    //RESULT_OK == -1
    if(resultCode == -1 && receiverRequestCode == ReceiverRequestCode) {
#ifdef QT_DEBUG
        qDebug() << "captured image to - " << imagePath;
        qDebug() << "captured image exist - " << QFile::exists(imagePath);
#endif
        emit notify->ready("file://"+imagePath);
    } else {
        if(!QFile::exists(imagePath)) {
            emit notify->error(CallNativeCamera::CaptureFail, imagePath + " Not Exists");
        } else {
            emit notify->error(CallNativeCamera::Unkonwn, data.toString());
        }
    }
}
#endif

void CallNativeCameraPrivate::startCapture()
{
#ifdef  Q_OS_ANDROID
    QAndroidJniObject action = QAndroidJniObject::fromString(
                "android.media.action.IMAGE_CAPTURE");
    QAndroidJniObject intent("android/content/Intent",
                             "(Ljava/lang/String;)V",
                             action.object<jstring>());

    //setup saved image location
    QString date = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");

    // 给 filename 指定 DCIM 目录--digital camera in memory 的简写，即存照片的文件夹（数码相机）。常见于数码相机、手机存储卡中的文件夹名字
    QAndroidJniObject fileName = QAndroidJniObject::fromString("DCIM/" + date + ".jpg");
    QAndroidJniObject savedDir = QAndroidJniObject::callStaticObjectMethod(
                "android/os/Environment",
                "getExternalStorageDirectory",
                "()Ljava/io/File;"
                );

    Q_SAFE_CALL_JAVA

    QAndroidJniObject savedImageFile(
                "java/io/File",
                "(Ljava/io/File;Ljava/lang/String;)V",
                savedDir.object<jobject>(),
                fileName.object<jstring>());


    Q_SAFE_CALL_JAVA

    QAndroidJniObject savedImageUri =
            QAndroidJniObject::callStaticObjectMethod(
                "android/net/Uri",
                "fromFile",
                "(Ljava/io/File;)Landroid/net/Uri;",
                savedImageFile.object<jobject>());


    Q_SAFE_CALL_JAVA

    //tell IMAGE_CAPTURE the output location
    QAndroidJniObject mediaStoreExtraOutput
            = QAndroidJniObject::getStaticObjectField(
                "android/provider/MediaStore",
                "EXTRA_OUTPUT",
                "Ljava/lang/String;");

    Q_SAFE_CALL_JAVA

    qDebug() << "MediaStore.EXTRA_OUTPUT - " << mediaStoreExtraOutput.toString();
    intent.callObjectMethod(
                "putExtra",
                "(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;",
                mediaStoreExtraOutput.object<jstring>(),
                savedImageUri.object<jobject>());

    this->resultReceiver->imagePath = savedImageFile.toString();

    QtAndroid::startActivity(intent, ResultReceiver::ReceiverRequestCode,
                             this->resultReceiver);
#endif
}


CallNativeCameraPrivate::CallNativeCameraPrivate()
#ifdef  Q_OS_ANDROID
    : resultReceiver(new ResultReceiver)
#endif
{
}
