#include "callnativecamera.h"

#include "callnativecamera_p.h"


CallNativeCamera::CallNativeCamera(QObject *parent)
    : QObject(parent) ,
      d_ptr(new CallNativeCameraPrivate())
{
    qRegisterMetaType<Error>("CallNativeCamera::Error");

#ifdef  Q_OS_ANDROID
    d_ptr->resultReceiver->notify = this;
#endif
}

CallNativeCamera::~CallNativeCamera()
{
    delete d_ptr;
}

void CallNativeCamera::capture()
{
#ifdef Q_OS_ANDROID
    d_ptr->startCapture();
#endif

#ifndef Q_OS_ANDROID
    emit this->error(SupportFail, "Only Suppor Android");
#endif
}

