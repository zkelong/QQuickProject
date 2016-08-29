#ifndef KWEIXINPAY_H
#define KWEIXINPAY_H

#include <QObject>

class KWeixinpay : public QObject
{
    Q_OBJECT
public:
    explicit KWeixinpay(QObject *parent = 0);

    static KWeixinpay* instance();

    /**
    * 初始化微信Sdk
    * @param partnerId
    * @param package
    */
    Q_INVOKABLE void init(QString appId, QString partnerId, QString package);

    /**
    * 执行支付操作
    * @param tradeNO 预支付订单编号
    * @param nonceStr 随机字符串
    * @param timestamp 时间戳
    * @param sign 签名
    */
    Q_INVOKABLE void pay(QString tradeNO, QString nonceStr, QString timestamp, QString sign);

signals:

public slots:

};

#endif // KALIPAY_H
