#ifndef KALIPAYLISTENNER_H
#define KALIPAYLISTENNER_H

#include <QObject>
#include <QVariant>

class KAlipayListenner : public QObject
{
    Q_OBJECT
public:
    explicit KAlipayListenner(QObject *parent = 0);
    ~KAlipayListenner();

signals:
    void payResult(QVariant result);

public slots:
};

void alipay_emit_pay_result(QVariant result);

#endif // KALIPAYLISTENNER_H
