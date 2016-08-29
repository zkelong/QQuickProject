#ifndef KAPPSTORELISTENNER_H
#define KAPPSTORELISTENNER_H

#include <QObject>
#include <QVariant>

class KAppStoreListenner : public QObject
{
    Q_OBJECT
public:
    explicit KAppStoreListenner(QObject *parent = 0);
    ~KAppStoreListenner();

signals:
    void payResult(QString receipt);

public slots:
};

void appstore_emit_pay_result(QString receipt);

#endif
