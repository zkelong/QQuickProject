#ifndef ALIPAY_BRIDGE_H
#define ALIPAY_BRIDGE_H
#include <QObject>

void alipay_init(QString partner, QString seller, QString privateKey, QString notifyUrl, QString iosAppScheme);
void alipay_pay(QString tradeNO, QString productName, QString productDescription, QString amount);

#endif // ALIPAY_BRIDGE_H

