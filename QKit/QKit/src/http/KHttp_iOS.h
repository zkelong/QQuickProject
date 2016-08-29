#ifndef KHttp_iOS_H
#define KHttp_iOS_H

#include <QtQml>
#include <QObject>
#include <QtNetwork>
#include <QQmlParserStatus>
#include "khttpfield.h"



class KHttp_iOS : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    Q_ENUMS(State)
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QQmlListProperty<KHttpField> postFields READ postFields)
    Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(State state READ state NOTIFY stateChanged)
    Q_PROPERTY(int status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString errorString READ errorString)
    Q_PROPERTY(QString responseText READ responseText)
    Q_PROPERTY(QString method READ method)
    Q_PROPERTY(int timeout MEMBER m_timeout)
    Q_CLASSINFO("DefaultProperty", "postFields")
public:
    //! State of the uploader object (compatible with XMLHttpRequest state)
    enum State {
        Unsent,     //!< Object is closed
        Opened,     //!< Object is open and ready to send
        Loading,    //!< Data is being sent
        Aborting,   //!< State entered when upload is being aborted
        Done        //!< Upload finished (you need to examine status property)
    };

    explicit KHttp_iOS(QObject *parent = 0);
    virtual ~KHttp_iOS();

    static void registerTypes();

    //! Get the destination URL
    QUrl url() const;
    //! Set the destination URL of the upload
    void setUrl(const QUrl& url);

    Q_PROPERTY(QQmlListProperty<KHttpField> postFields READ postFields)
    qreal progress() const;
    KHttp_iOS::State state() const;
    QString errorString() const;
    QString responseText() const;
    QString method() const;
    int status() const;

    QQmlListProperty<KHttpField> postFields();

public slots:
    //! Reset object to the initial state (close files/clear fields/etc.)
    void clear();
    //! Set object to the open state with specified URL
    void open(const QString method, const QUrl& url);
    //! Start upload
    void send();
    //! Start upload, but use file as POST body
    void sendFile(const QString& fileName);
    //! Abort current transaction
    void abort();
    //! Add key/value field
    void addField(const QString& fieldName, const QString& fieldValue);
    //! Add file field
    void addFile(const QString& fieldName, const QString& fileName, const QString& mimeType = QString());
    //! Set http header
    void setHeader(const QString name, const QString value);
    //! Get header
    QString header(const QString name);
    //! Get response header
    QString responseHeader(const QString name);
    //! Set http post body, if setted the post fields will be ignore.
    void setBody(const QString body);

signals:
    void urlChanged();
    void progressChanged();
    void stateChanged();
    void statusChanged();

public:
    int m_timeout;
    
private:
    static void appendFunction(QQmlListProperty<KHttpField> *, KHttpField*);
    static int countFunction(QQmlListProperty<KHttpField> *);
    static KHttpField * atFunction(QQmlListProperty<KHttpField> *, int);
    static void clearFunction(QQmlListProperty<KHttpField> *);

private: // QDeclarativeParserStatus
    virtual void classBegin();
    virtual void componentComplete();

private slots:
    void reply_finished(void * response, void* responseObject, void* error);

private:
    bool mComplete;

    QUrl mUrl;
    QList< QPointer<KHttpField> > mPostFields;
    qreal mProgress;
    State mState;

    QString mErrorString;
    QByteArray mBoundaryString;

    int mStatus;
    QByteArray mResponse;
    QString mMethod;

    bool mHasRawBody;
    
    void     *mHeasers;
    void     *mResponseHeaders;
    void     *mRawBody;
    
    
    void     *mRequest;

};

#endif // KHttp_iOS_H
