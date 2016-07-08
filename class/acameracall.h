#ifndef ACAMERACALL_H
#define ACAMERACALL_H

#include <QObject>
#include <QQuickItem>

class ACameraCall : public QObject
{
    Q_OBJECT
public:
    ACameraCall(QObject *parent = 0);
    ~ACameraCall();

    Q_INVOKABLE void takePhoto();

private:

signals:
    void canceled();
    void errored();
    void succeed(QString path);

};

#endif // ACAMERACALL_H
