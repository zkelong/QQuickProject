#include "khttpfieldfile.h"

KHttpFieldFile::KHttpFieldFile(QObject *parent) : KHttpField(parent)
{
    mType = FieldFile;
}


int KHttpFieldFile::contentLength()
{
    QFileInfo fi(mSource.toLocalFile());
    return fi.size();
}

QIODevice * KHttpFieldFile::createIoDevice(QObject * parent)
{
    QFile * file = new QFile(mSource.toLocalFile(), parent);
    if(!file->open(QFile::ReadOnly))
    {
        delete file;
        Q_ASSERT_X(NULL, "KHttpFieldFile::createIoDevice", "Failed to open file");
        return nullptr;
    }
    return file;
}

QUrl KHttpFieldFile::source() const
{
    return mSource;
}

void KHttpFieldFile::setSource(const QUrl& url)
{
    mSource = url;
}

QString KHttpFieldFile::mimeType() const
{
    return mMime;
}

void KHttpFieldFile::setMimeType(const QString& mime)
{
    if( mMime != mime ) {
        mMime = mime;
        emit mimeTypeChanged();
    }
}

bool KHttpFieldFile::validateVield()
{
    return QFile::exists(mSource.toLocalFile());
}
