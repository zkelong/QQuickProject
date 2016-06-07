#ifndef KHTTPDEVICE_H
#define KHTTPDEVICE_H

#include <QObject>
#include <QIODevice>
#include <QVector>
#include <QPair>

class KHttp;
class KHttpField;
class KHttpDevice : public QIODevice
{
    Q_OBJECT
public:
    explicit KHttpDevice(KHttp *http = 0);
    ~KHttpDevice();

    virtual qint64 size() const;
    virtual bool seek(qint64 pos);

private:
    virtual qint64 readData(char *data, qint64 maxlen);
    virtual qint64 writeData(const char *data, qint64 len);

private:
    void setup();

public:
    struct Range {
        int start;
        int end;
    };

    void appendData(const QByteArray& data);
    void appendField(KHttpField * field);

    QVector< QPair<Range, QIODevice *> > ioDevices;
    int totalSize;
    qint64 ioIndex;
    int lastIndex;
    QByteArray contentType;
};

#endif // KHTTPDEVICE_H
