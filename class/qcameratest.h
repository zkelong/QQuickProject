#ifndef QCAMERATEST_H
#define QCAMERATEST_H

#include <QObject>
#include <QCamera>

class QCameraTest : public QObject
{
    Q_OBJECT
public:
    QCameraTest();
    ~QCameraTest(){}

    Q_INVOKABLE void captrue();
    Q_INVOKABLE void setSavePath();

signals:
    void errored(qint64 errorId, QString errorMessage);
    void captured(QString previeiw);
    void saved(QString path);

private:
    QString m_savePath;
    QCamera* m_camera;
};
#endif // QCAMERATEST_H
