#ifndef ACAMERACALL_H
#define ACAMERACALL_H

#include <QObject>
#include <QQuickItem>

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <QAndroidActivityResultReceiver>

using namespace QtAndroid;

class ACameraCall;

class ResultReceiverC : public QAndroidActivityResultReceiver
{
public:
    explicit ResultReceiverC();
    void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data);

    static const int ReceiverRequestCode;
    QString m_imagePath;
    ACameraCall* notify;
};

#endif


class ACameraCall : public QObject
{
    Q_OBJECT
public:
    ACameraCall(QObject *parent = 0);
    ~ACameraCall();

    Q_INVOKABLE void takePhoto();

private:

signals:
    void canceled();
    void errored();
    void succeed(QString path);

protected:
    ResultReceiverC * receiver;

};

#endif // ACAMERACALL_H
