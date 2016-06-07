#ifndef QSYSTEM_DISPATCHER_H
#define QSYSTEM_DISPATCHER_H
#include <QObject>
#include <QVariantMap>

/// QSystemDispatcher provides an simple messaging interface between C/C++/QML and Java code.

class QSystemDispatcher : public QObject
{
    Q_OBJECT
public:
    ~QSystemDispatcher();
    static QSystemDispatcher* instance();

    Q_INVOKABLE void dispatch(QString name , QVariantMap message = QVariantMap());

    static void registerNatives();

signals:
    void dispatched(QString name , QVariantMap data);

private:
    explicit QSystemDispatcher(QObject* parent = 0);

};

#endif
