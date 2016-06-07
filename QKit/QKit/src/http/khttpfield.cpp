#include "khttpfield.h"

KHttpField::KHttpField(QObject *parent) : QObject(parent),mType(FieldInvalid),mInstancedFromQml(true)
{

}

KHttpField::~KHttpField()
{
#ifdef QT_DEBUG
    qDebug() << "KHttpField::~KHttpField()" << this;
#endif
}

QString KHttpField::name() const
{
    return mName;
}

void KHttpField::setName(const QString& name)
{
    if( mName != name ) {
        mName = name;
        emit nameChanged();
    }
}

KHttpField::FieldType KHttpField::type() const
{
    return mType;
}

void KHttpField::setType(KHttpField::FieldType type)
{
    mType = type;
}

