#ifndef KJPUSH_H
#define KJPUSH_H

#include <QObject>
#include <QVariantList>

class KJPush : public QObject
{
    Q_OBJECT
public:
    explicit KJPush(QObject *parent = 0);
    static KJPush* instance();

    Q_INVOKABLE void init();
    Q_INVOKABLE void setDebugMode(bool value);
    Q_INVOKABLE void setAlias(QString alias);
    Q_INVOKABLE void setTags(QVariantList tags);
    Q_INVOKABLE void clearAllNotifications();

signals:


public slots:

private:
    ~KJPush(){}
};

#endif // KJPUSH_H
