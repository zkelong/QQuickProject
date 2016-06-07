#ifndef KAPPLICATIONLISTENNER_H
#define KAPPLICATIONLISTENNER_H

#include <QObject>

class KApplicationListenner : public QObject
{
    Q_OBJECT
public:
    explicit KApplicationListenner(QObject *parent = 0);
    ~KApplicationListenner();

signals:
    void suspend(); //程序暂停时发出
    void resume(); //程序恢复运行时发出
    void exit(); //程序退出时发出
    void heartbeat(); //定时心跳


public slots:
};

#endif // KAPPLICATIONLISTENNER_H
