#include "khttpfieldvalue.h"

KHttpFieldValue::KHttpFieldValue(QObject *parent) : KHttpField(parent)
{
    mType = FieldValue;
}


QString KHttpFieldValue::value() const
{
    return QString::fromUtf8(mValue.constData(), mValue.size());
}

void KHttpFieldValue::setValue(const QString& value)
{
    mValue = value.toUtf8();
}

int KHttpFieldValue::contentLength()
{
    return mValue.size();
}

QIODevice * KHttpFieldValue::createIoDevice(QObject * parent)
{
    QBuffer * buffer = new QBuffer(parent);
    buffer->setData(mValue);
    buffer->open(QIODevice::ReadOnly);
    return buffer;
}

bool KHttpFieldValue::validateVield()
{
    return true;
}
