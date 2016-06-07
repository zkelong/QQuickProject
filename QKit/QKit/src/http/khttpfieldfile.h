#ifndef KHTTPFIELDFILE_H
#define KHTTPFIELDFILE_H

#include "khttpfield.h"

class KHttpFieldFile : public KHttpField
{
    Q_OBJECT
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString mimeType READ mimeType WRITE setMimeType NOTIFY mimeTypeChanged)
public:
    explicit KHttpFieldFile(QObject *parent = 0);

    virtual int contentLength();
    virtual QIODevice * createIoDevice(QObject * parent = 0);
    virtual bool validateVield();

    //! Source URL for the file
    QUrl source() const;
    //! Sets source URL of the file
    void setSource(const QUrl& url);

    //! Returns MIME type of the file
    QString mimeType() const;
    //! Sets MIME type of the file. If MIME type is empty, application/octet-stream is used by default
    void setMimeType(const QString& mime);

signals:
    void sourceChanged();
    void mimeTypeChanged();

private:
    QUrl mSource;
    QString mMime;

};

QML_DECLARE_TYPE(KHttpFieldFile)

#endif // KHTTPFIELDFILE_H
