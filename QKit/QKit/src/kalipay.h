#ifndef KALIPAY_H
#define KALIPAY_H

#include <QObject>

class KAlipay : public QObject
{
    Q_OBJECT
public:
    explicit KAlipay(QObject *parent = 0);

    static KAlipay* instance();

    /**
    * 初始化支付宝Sdk
    * @param partner
    * @param seller
    * @param privateKey
    * @param iosNotifyUrl
    * @param iosAppScheme ios使用
    */
    Q_INVOKABLE void init(QString partner, QString seller, QString privateKey, QString iosNotifyUrl, QString iosAppScheme = QString());

    /**
    * 执行支付操作
    * @param tradeNO 自定义订单编号
    * @param productDescription 产品描述
    * @param amount 总金额
    */
    Q_INVOKABLE void pay(QString tradeNO, QString productName, QString productDescription, QString amount);

signals:

public slots:

protected:
    QString         m_partner;
    QString         m_seller;
    QString         m_privateKey;
    QString         m_notifyUrl;
    QString         m_iosAppScheme;
};

#endif // KALIPAY_H
