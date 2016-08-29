#ifndef KPHONESTATELISTENER_H
#define KPHONESTATELISTENER_H

#include <QObject>

class KPhoneStateListener : public QObject
{
    Q_OBJECT
    Q_ENUMS(phone_state)
public:
    explicit KPhoneStateListener(QObject *parent = 0);
    ~KPhoneStateListener();

    enum phone_state
    {
        //电话挂断
        CALL_STATE_IDLE,

        //等待接电话
        CALL_STATE_RINGING,

        //通话中
        CALL_STATE_OFFHOOK

    };

signals:
    void phoneStateChanged(int state);
public slots:
};

#endif // KPHONESTATELISTENER_H
