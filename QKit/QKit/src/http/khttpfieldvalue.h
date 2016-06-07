#ifndef KHTTPFIELDVALUE_H
#define KHTTPFIELDVALUE_H

#include "khttpfield.h"

class KHttpFieldValue : public KHttpField
{
    Q_OBJECT
    Q_PROPERTY(QString value READ value WRITE setValue NOTIFY valueChanged)
public:
    explicit KHttpFieldValue(QObject *parent = 0);

    //! Return value as Unicode string
    QString value() const;
    //! Transform unicode string to UTF-8 buffer
    void setValue(const QString& value);

    virtual int contentLength();
    virtual QIODevice * createIoDevice(QObject * parent = 0);
    virtual bool validateVield();

signals:
    void valueChanged();

private:
    QByteArray mValue;
};

QML_DECLARE_TYPE(KHttpFieldValue)

#endif // KHTTPFIELDVALUE_H
