#ifndef KJPUSHLISTENNER_H
#define KJPUSHLISTENNER_H

#include <QObject>

class KJPushListenner : public QObject
{
    Q_OBJECT
public:
    explicit KJPushListenner(QObject *parent = 0);
    virtual ~KJPushListenner();

signals:
    void receiveNotification(QString message, QString extras);

public slots:
};

#endif // KJPUSHLISTENNER_H
