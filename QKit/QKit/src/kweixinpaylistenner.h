#ifndef KWEIXINPAYLISTENNER_H
#define KWEIXINPAYLISTENNER_H

#include <QObject>
#include <QVariant>

class KWeixinpayListenner : public QObject
{
    Q_OBJECT
public:
    explicit KWeixinpayListenner(QObject *parent = 0);
    ~KWeixinpayListenner();

signals:
    void payResult(int code);

public slots:
};

void weixinpay_emit_pay_result(int code);

#endif // KALIPAYLISTENNER_H
