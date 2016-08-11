#ifndef CALLNATIVECAMERA_H
#define CALLNATIVECAMERA_H

#include <QObject>

class CallNativeCameraPrivate;
class CallNativeCamera : public QObject
{
    Q_OBJECT
public:
    enum Error {
        NotError = 0,
        Unkonwn = -1,
        SupportFail = -3,
        CaptureFail = -3,
    };
    Q_ENUM(Error)

    explicit CallNativeCamera(QObject *parent = 0);
    ~CallNativeCamera();

    /***/
    Q_INVOKABLE void capture();

signals:
    void ready(const QString& path);

    void error(Error errorCode, const QString& errorString);

public slots:
private:
    CallNativeCameraPrivate* d_ptr;
};

#endif // CALLNATIVECAMERA_H
