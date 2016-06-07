#include "khttpdevice.h"
#include "khttpfieldfile.h"
#include "khttpfieldvalue.h"
#include "khttp.h"

KHttpDevice::KHttpDevice(KHttp *http) : QIODevice(http), totalSize(0), ioIndex(0), lastIndex(0)
{
    setup();
}

KHttpDevice::~KHttpDevice()
{
    for(int i = 0 ; i < ioDevices.count() ; ++i)
        delete ioDevices[i].second;
}


qint64 KHttpDevice::size() const
{
    return totalSize;
}

bool KHttpDevice::seek(qint64 pos)
{
    if(pos >= totalSize)
        return false;
    ioIndex = pos;
    lastIndex = 0;
    return QIODevice::seek(pos);
}

qint64 KHttpDevice::readData(char *data, qint64 len)
{
    if ((len = qMin(len, qint64(totalSize) - ioIndex)) <= 0)
        return qint64(0);

    qint64 totalRead = 0;

    while(len > 0)
    {
        if( ioIndex >= ioDevices[lastIndex].first.start && ioIndex <= ioDevices[lastIndex].first.end )
        {

        } else {
            for(int i = 0 ; i < ioDevices.count() ; ++i)
            {
                if( ioIndex >= ioDevices[i].first.start && ioIndex <= ioDevices[i].first.end )
                {
                    lastIndex = i;
                }
            }
        }

        QIODevice * chunk = ioDevices[lastIndex].second;

        if(!ioDevices[lastIndex].second->seek(ioIndex - ioDevices[lastIndex].first.start))
        {
            qWarning("KHttpDevice: Failed to seek inner device");
            break;
        }

        qint64 bytesLeftInThisChunk = chunk->size() - chunk->pos();
        qint64 bytesToReadInThisRequest = qMin(bytesLeftInThisChunk, len);

        qint64 readLen = chunk->read(data, bytesToReadInThisRequest);
        if( readLen != bytesToReadInThisRequest ) {
            qWarning("KHttpDevice: Failed to read requested amount of data");
            break;
        }

        data += bytesToReadInThisRequest;
        len -= bytesToReadInThisRequest;
        totalRead += bytesToReadInThisRequest;
        ioIndex += bytesToReadInThisRequest;
    }

    return totalRead;
}

qint64 KHttpDevice::writeData(const char *data, qint64 len)
{
    return -1;
}

void KHttpDevice::setup()
{
#ifdef QT_DEBUG
    qDebug() << "KHttpDevice: Setup device";
#endif

    KHttp * o = (KHttp *)parent();

    QByteArray crlf("\r\n");
    QByteArray boundary("---------------------------" + o->mBoundaryString);
    QByteArray endBoundary(crlf + "--" + boundary + "--" + crlf);
    contentType = QByteArray("multipart/form-data; boundary=") + boundary;
    boundary="--"+boundary+crlf;
    QByteArray bond=boundary;

    bool first = true;

    for(int i = 0 ; i < o->mPostFields.count() ; ++i)
    {
        if(!o->mPostFields[i])
            continue;
        KHttpField * field = o->mPostFields[i].data();

        QByteArray chunk(bond);
        if(first) {
            first = false;
            boundary = crlf + boundary;
            bond = boundary;
        }

        if(field->type() == KHttpField::FieldFile) {
            chunk.append("Content-Disposition: form-data; name=\"");
            chunk.append(field->name().toLatin1());
            chunk.append("\"; filename=\"");

            KHttpFieldFile * file = static_cast<KHttpFieldFile *>(field);

            QFileInfo fi(file->source().toLocalFile());
            chunk.append(fi.fileName().toUtf8());
            chunk.append("\"");
            chunk.append(crlf);

            if(!file->mimeType().isEmpty()) {
                chunk.append("Content-Type: ");
                chunk.append(file->mimeType());
                chunk.append("\r\n");
            } else {
                chunk.append("Content-Type: application/octet-stream\r\n");
            }

            chunk.append(crlf);

            // Files up to 256KB may be loaded into memory
            if( totalSize + chunk.size() + file->contentLength() < 256*1024) {
                QIODevice * dev = file->createIoDevice(this);
                chunk.append(dev->readAll());
                delete dev;
                appendData(chunk);
            } else {
                appendData(chunk);
                appendField(file);
            }
        } else {
            chunk.append("Content-Disposition: form-data; name=\"");
            chunk.append(field->name().toLatin1());
            chunk.append("\"");
            chunk.append(crlf);
            chunk.append("Content-Transfer-Encoding: 8bit");
            chunk.append(crlf);
            chunk.append(crlf);

            KHttpFieldValue * value = static_cast<KHttpFieldValue *>(field);

            chunk.append(value->value().toUtf8());

            appendData(chunk);
        }
    }

    if( !o->mPostFields.isEmpty() )
        appendData(endBoundary);

#ifdef QT_DEBUG
    qDebug() << "Total content length is" << totalSize;
#endif
}

void KHttpDevice::appendData(const QByteArray& data)
{
#ifdef QT_DEBUG
    qDebug() << "KHttpDevice: Append chunk of size" << data.size();
#endif

    QBuffer * buffer = new QBuffer(this);
    buffer->setData(data);
    buffer->open(QBuffer::ReadOnly);

    Range r;
    r.start = totalSize;
    r.end = totalSize + data.size() - 1;

    ioDevices.append(QPair<Range, QIODevice *>(r, buffer));
    totalSize += data.size();
}

void KHttpDevice::appendField(KHttpField * field)
{
#ifdef QT_DEBUG
    qDebug() << "KHttpDevice: Append field of size" << field->contentLength();
#endif

    QIODevice * device = field->createIoDevice(this);

    Range r;
    r.start = totalSize;
    r.end = totalSize + device->size() - 1;

    ioDevices.append(QPair<Range, QIODevice *>(r, device));
    totalSize += device->size();
}
