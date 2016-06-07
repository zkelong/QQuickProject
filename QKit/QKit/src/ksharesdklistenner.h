#ifndef KSHARESDKLISTENNER_H
#define KSHARESDKLISTENNER_H

#include <QObject>

class KShareSDKListenner : public QObject
{
    Q_OBJECT
public:
    explicit KShareSDKListenner(QObject *parent = 0);
    virtual ~KShareSDKListenner();

signals:
    void platformError(QString platform);
    void platformComplete(QString platform, QString userId, QString userName, QString userIcon, QString token, QString tokenSecret, qreal expiresTime);
    void platformCancel(QString platform);

public slots:
};

#endif // KSHARESDKLISTENNER_H
