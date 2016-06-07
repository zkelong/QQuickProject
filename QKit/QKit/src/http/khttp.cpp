#include <QUrlQuery>
#include "khttp.h"
#include "khttpfieldvalue.h"
#include "khttpfieldfile.h"
#include "khttpdevice.h"

bool canSendFile(QString mMethod){
    return (mMethod == "post" || mMethod == "put");
}

KHttp::KHttp(QObject *parent) :
    QObject(parent),
    mProgress(0.0),
    mState(Unsent),
    mPendingReply(NULL),
    mUploadDevice(NULL),
    mStatus(0),
    mHasRawBody(false)
{
    mComplete = false;
    mMethod = "get";
}

KHttp::~KHttp()
{
    if(mPendingReply) {
        mPendingReply->abort();
    }
    qDebug() << "KHttp released";
}

void KHttp::registerTypes()
{
    qmlRegisterUncreatableType<KHttpField>("KHttp", 1, 0, "HttpField", "Can't touch this");
    qmlRegisterType<KHttpFieldValue>("KHttp", 1, 0, "HttpFieldValue");
    qmlRegisterType<KHttpFieldFile>("KHttp", 1, 0, "HttpFieldFile");
    qmlRegisterType<KHttp>("KHttp", 1, 0, "Http");
}

QUrl KHttp::url() const
{
    return mUrl;
}


void KHttp::setUrl(const QUrl& url)
{
    if( mState == Loading ){
        qWarning() << "KHttp: Can't change URL in loading state";
    } else if( url != mUrl ) {
        mUrl = url;
        emit urlChanged();
    }
}


QQmlListProperty<KHttpField> KHttp::postFields()
{
    return QQmlListProperty<KHttpField>(this, 0, &KHttp::appendFunction, &KHttp::countFunction, &KHttp::atFunction, &KHttp::clearFunction);
}


void KHttp::appendFunction(QQmlListProperty<KHttpField> * o, KHttpField* field)
{
    KHttp * self = qobject_cast<KHttp *>(o->object);
    if(self) {
        if( self->mState == Loading ) {
            qWarning("KHttp: Invalid state when trying to append field");
        } else {
            self->mPostFields.append(field);
        }
    }
}


int KHttp::countFunction(QQmlListProperty<KHttpField> * o)
{
    KHttp * self = qobject_cast<KHttp *>(o->object);
    if(self)
        return self->mPostFields.count();
    return 0;
}

KHttpField * KHttp::atFunction(QQmlListProperty<KHttpField> * o, int index)
{
    KHttp * self = qobject_cast<KHttp *>(o->object);
    if(self) {
        return self->mPostFields.value(index);
    }
    return NULL;
}


void KHttp::clearFunction(QQmlListProperty<KHttpField> * o)
{
    KHttp * self = qobject_cast<KHttp *>(o->object);
    if(self) {
        if( self->mState == Loading ) {
            qWarning("KHttp: Invalid state when trying to clear fields");
        } else {
            for(int i = 0 ; i < self->mPostFields.size() ; ++i)
                if(self->mPostFields[i] && !self->mPostFields[i]->mInstancedFromQml)
                    delete self->mPostFields[i];
            self->mPostFields.clear();
        }
    }
}

void KHttp::classBegin()
{
    QQmlEngine * engine = qmlEngine(this);

    if(QQmlNetworkAccessManagerFactory * factory = engine->networkAccessManagerFactory())
    {
        mNetworkAccessManager = factory->create(this);
    } else {
        mNetworkAccessManager = engine->networkAccessManager();
    }
}


void KHttp::componentComplete()
{
    mComplete = true;
}

qreal KHttp::progress() const
{
    return mProgress;
}

KHttp::State KHttp::state() const
{
    return mState;
}

QString KHttp::errorString() const
{
    return mErrorString;
}

QString KHttp::responseText() const
{
    return QString::fromUtf8(mResponse.constData(), mResponse.size());
}

QString KHttp::method() const
{
    return mMethod;
}

int KHttp::status() const
{
    return mStatus;
}

void KHttp::clear()
{
    if( mState == Done || mState == Opened || mState == Unsent ) {
        mState = Unsent;
        mUrl.clear();
        for(int i = 0 ; i < mPostFields.size() ; ++i)
            if(mPostFields[i] && !mPostFields[i]->mInstancedFromQml)
                delete mPostFields[i];
        mPostFields.clear();
        mProgress = 0;
        mStatus = 0;
        mErrorString.clear();
        mResponse.clear();
        mRequest = QNetworkRequest();
        mHasRawBody = false;
        mUploadDevice->deleteLater();
        mUploadDevice = nullptr;
        emit stateChanged();
        emit urlChanged();
        emit progressChanged();
        emit statusChanged();
    }
}

void KHttp::open(const QString method,const QUrl& url)
{
    mMethod = method.toLower();
    mRequest.setUrl(url);
    if( mState == Unsent )
    {
        setUrl(url);
        mState = Opened;
        emit stateChanged();
    } else {
        qWarning() << "Invalid state of http" << mState << "to open";
    }
}

QUrlQuery fieldsToQuery(QList< QPointer<KHttpField> >& fields){
    QUrlQuery query;
    for(int i = 0; i < fields.length(); ++i){
        KHttpFieldValue* field = qobject_cast<KHttpFieldValue*>(fields[i]);
        if(!field->validateVield()) {
            qCritical() << "Failed to validate query fields";
            continue;
        }
        query.addQueryItem(field->name(),field->value());
    }
    return query;
}


void KHttp::send()
{
    if( mState == Opened ) {
        bool hasContentType = (mRequest.hasRawHeader(QString("Content-type").toUtf8()) || mRequest.header(QNetworkRequest::ContentTypeHeader).isValid());

        if(mMethod == "post" || mMethod == "put"){
            QString contentType = mRequest.header(QNetworkRequest::ContentTypeHeader).toString();
            if(contentType.indexOf("application/x-www-form-urlencoded") >= 0 && mPostFields.length()){
                QUrlQuery query = fieldsToQuery(mPostFields);
                mHasRawBody = true;
                QBuffer * buffer = new QBuffer(this);
                buffer->setData(query.toString().toUtf8());
                mUploadDevice = buffer;
            }
            if(mHasRawBody && mUploadDevice){
                if( !hasContentType ){
                    mRequest.setHeader(QNetworkRequest::ContentTypeHeader, "application/octet-stream");
                }

            } else {
                QCryptographicHash hash(QCryptographicHash::Sha1);
                foreach(QPointer<KHttpField> field, mPostFields) {
                    if( !field.isNull() ) {
                        if(!field->validateVield()) {
                            mState = Done;
                            mErrorString = tr("Failed to validate POST fields");
                            mStatus = -1;
                            emit stateChanged();
                            emit statusChanged();
                            return;
                        }
                        hash.addData(field->name().toUtf8());
                    }
                }

                mBoundaryString = "HttpBoundary" + hash.result().toHex();

                mUploadDevice = new KHttpDevice(this);
                if( !hasContentType ){
                    mRequest.setHeader(QNetworkRequest::ContentTypeHeader, ((KHttpDevice *)mUploadDevice)->contentType);
                }
            }
            mUploadDevice->open(QIODevice::ReadOnly);
            mRequest.setHeader(QNetworkRequest::ContentLengthHeader, mUploadDevice->size());
            mRequest.setUrl(mUrl);
            mPendingReply = mNetworkAccessManager->post(mRequest, mUploadDevice);
        } else {
            if(mPostFields.length()){
                QUrlQuery query = fieldsToQuery(mPostFields);
                mUrl.setQuery(query.toString(QUrl::EncodeSpaces));
            }
            mRequest.setUrl(mUrl);
            mPendingReply = mNetworkAccessManager->get(mRequest);
        }

        mState = Loading;
        mProgress = 0;

        connect(mPendingReply, SIGNAL(finished()), SLOT(reply_finished()));
        connect(mPendingReply, SIGNAL(uploadProgress(qint64,qint64)), SLOT(uploadProgress(qint64,qint64)));

        emit stateChanged();
        emit progressChanged();
    } else {
        qWarning() << "Invalid state of http" << mState << "to send";
    }
}

void KHttp::sendFile(const QString& fileName)
{
    if(!canSendFile(mMethod)){
        qCritical() << "Can not add file with [" << mMethod << "] method!";
        return;
    }

    if( mState == Opened ) {
        QNetworkRequest request(mUrl);

        mUploadDevice = new QFile(fileName, this);
        if(!mUploadDevice->open(QIODevice::ReadOnly)) {
            mState = Done;
            mErrorString = mUploadDevice->errorString();
            delete mUploadDevice;
            mUploadDevice = NULL;
            mStatus = -1;
            emit stateChanged();
            emit statusChanged();
            return;
        }

        mPendingReply = mNetworkAccessManager->post(request, mUploadDevice);
        mState = Loading;
        mProgress = 0;

        connect(mPendingReply, SIGNAL(finished()), SLOT(reply_finished()));
        connect(mPendingReply, SIGNAL(uploadProgress(qint64,qint64)), SLOT(uploadProgress(qint64,qint64)));

        emit stateChanged();
        emit progressChanged();
    } else {
        qWarning() << "Invalid state of http" << mState << "to send";
    }
}


void KHttp::abort()
{
    if( mState == Loading ) {
        mState = Aborting;
        emit stateChanged();
        mPendingReply->abort();
    }
}


void KHttp::addField(const QString& fieldName, const QString& fieldValue)
{
    KHttpFieldValue * field = new KHttpFieldValue(this);
    field->setName(fieldName);
    field->setValue(fieldValue);
    field->mInstancedFromQml = false;
    mPostFields.append(field);
}


void KHttp::addFile(const QString& fieldName, const QString& fileName, const QString& mimeType)
{
    if(!canSendFile(mMethod)){
        qCritical() << "Can not add file with [" << mMethod << "] method!";
        return;
    }
    KHttpFieldFile * field = new KHttpFieldFile(this);
    field->setName(fieldName);
    field->setSource(QUrl::fromLocalFile(fileName));
    field->setMimeType(mimeType);
    field->mInstancedFromQml = false;
    mPostFields.append(field);
}

void KHttp::setHeader(const QString name, const QString value)
{
    mRequest.setRawHeader(name.toUtf8(),value.toUtf8());
}

QString KHttp::header(const QString name)
{
    return mRequest.rawHeader(name.toUtf8());
}

QString KHttp::responseHeader(const QString name)
{
    if(mPendingReply){
        return mPendingReply->rawHeader(name.toUtf8());
    }
    return "";
}

void KHttp::setBody(const QString body)
{
    if(body.isEmpty()){
        qCritical() << "Http setBody: body can not empty!";
        return;
    }
    mHasRawBody = true;
    QBuffer * buffer = new QBuffer(this);
    buffer->setData(body.toUtf8());
    mUploadDevice = buffer;
}

void KHttp::reply_finished()
{
    mPendingReply->deleteLater();
    mStatus = 0;
    QVariant statusCode = mPendingReply->attribute( QNetworkRequest::HttpStatusCodeAttribute );
    if ( statusCode.isValid() ){
        mStatus = statusCode.toInt();
        qDebug() << "********************** status code = " << mStatus;
    }

    if( mPendingReply->error() == QNetworkReply::OperationCanceledError ) {
#ifdef QT_DEBUG
        qDebug() << "KHttp: request aborted";
#endif

        mPendingReply = NULL;
        delete mUploadDevice;
        mUploadDevice = NULL;
        mProgress = 0;
        mState = Done;
        mBoundaryString.clear();
        emit progressChanged();
        emit stateChanged();
        return;
    }

    mResponse = mPendingReply->readAll();

    if( mPendingReply->error() != QNetworkReply::NoError ) {
#ifdef QT_DEBUG
        qDebug() << "KHttp: Network error" << mPendingReply->error();
#endif

        delete mUploadDevice;
        mUploadDevice = NULL;
        mProgress = 1;
        mState = Done;
        mBoundaryString.clear();
        mErrorString = mPendingReply->errorString();
        emit progressChanged();
        emit stateChanged();
        emit statusChanged();
        mPendingReply = NULL;
        return;
    }

#ifdef QT_DEBUG
    qDebug() << "KHttp: request finished";
#endif

    delete mUploadDevice;
    mUploadDevice = NULL;
    mProgress = 1;
    mState = Done;
    mErrorString.clear();
    emit progressChanged();
    emit statusChanged();
    emit stateChanged();
    mPendingReply = NULL;
}


void KHttp::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    if( bytesTotal > 0 )
    {
        qreal progress = qreal(bytesSent) / qreal(bytesTotal);
        if(!qFuzzyCompare(progress, mProgress))
        {
            mProgress = progress;
#ifdef QT_DEBUG
            qDebug() << "KHttp: Progress is" << mProgress;
#endif
            emit progressChanged();
        }
    }
}
