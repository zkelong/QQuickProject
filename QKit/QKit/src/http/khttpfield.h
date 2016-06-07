#ifndef KHTTPFIELD_H
#define KHTTPFIELD_H
#include <QtQml>
#include <QObject>
#include <QtNetwork>
#include <QQmlParserStatus>

class KHttpField : public QObject
{
    Q_OBJECT
    Q_ENUMS(FieldType)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(FieldType type READ type CONSTANT FINAL)
    Q_PROPERTY(int contentLength READ contentLength NOTIFY contentLengthChanged)
public:
    enum FieldType {
        FieldInvalid,       //!< Invalid field - not initialized
        FieldValue,         //!< Field is string
        FieldFile           //!< Filed is file
    };

    explicit KHttpField(QObject *parent = 0);
    virtual ~KHttpField();

    //! Name of the field
    QString name() const;
    //! Sets name of the field
    void setName(const QString& name);

    //! HTTP POST field type
    KHttpField::FieldType type() const;

    //! Return length of the content uploaded
    virtual int contentLength() = 0;

    //! Create QIODevice object which returns data to be uploaded
    virtual QIODevice * createIoDevice(QObject * parent = 0) = 0;

    //! Check if the field is valid (e.g. file exists)
    virtual bool validateVield() = 0;

public slots:

signals:
    void nameChanged();
    void contentLengthChanged();

protected:
    //! Sets type of the field. Used only by derived classes
    void setType(KHttpField::FieldType type);

protected:
    friend class KHttp;
    FieldType mType;
    QString mName;
    bool mInstancedFromQml;

};

QML_DECLARE_TYPE(KHttpField)

#endif // KHTTPFIELD_H
