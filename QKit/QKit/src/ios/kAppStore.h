#ifndef KAPPSTORE_H
#define KAPPSTORE_H

#include <QObject>

class KAppStore : public QObject
{
    Q_OBJECT
public:
    explicit KAppStore(QObject *parent = 0);

    static KAppStore* instance();

    Q_INVOKABLE void init();


    Q_INVOKABLE void pay(QString productId);

signals:

public slots:

};

#endif
