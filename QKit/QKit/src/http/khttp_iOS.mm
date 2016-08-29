#include <QUrlQuery>
#include "KHttp_iOS.h"
#include "khttpfieldvalue.h"
#include "khttpfieldfile.h"
#include "khttpdevice.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#include <QtConcurrent/qtconcurrentrun.h>

static AFURLSessionManager    *s_manager = nil;
static NSString   *s_user_agent = nil;

bool canSendFile(QString mMethod){
    return (mMethod == "post" || mMethod == "put");
}

KHttp_iOS::KHttp_iOS(QObject *parent) :
    QObject(parent),
    m_timeout(0),
    mProgress(0.0),
    mState(Unsent),
    mStatus(0),
    mHasRawBody(false),
    mResponseHeaders(nullptr),
    mRawBody(nil),
    mRequest(nullptr)

{
    mComplete = false;
    mMethod = "get";
    mHeasers = [[NSMutableDictionary alloc]init];
}

KHttp_iOS::~KHttp_iOS()
{
    if(mRequest){
        [(NSURLSessionDataTask*)mRequest cancel];
    }
    [(NSURLSessionDataTask*)mRequest release];
    mRequest = nil;
    [(NSMutableDictionary*)mHeasers release];
    if(mResponseHeaders){
        [(NSMutableDictionary*)mResponseHeaders release];
        mResponseHeaders = nil;
    }
    mHeasers = nil;
    [(NSData*)mRawBody release];
    mRawBody = nil;
    qDebug() << "KHttp_iOS released";
}

void KHttp_iOS::registerTypes()
{
    qmlRegisterUncreatableType<KHttpField>("KHttp", 1, 0, "HttpField", "Can't touch this");
    qmlRegisterType<KHttpFieldValue>("KHttp", 1, 0, "HttpFieldValue");
    qmlRegisterType<KHttpFieldFile>("KHttp", 1, 0, "HttpFieldFile");
    qmlRegisterType<KHttp_iOS>("KHttp", 1, 0, "Http");
}

QUrl KHttp_iOS::url() const
{
    return mUrl;
}


void KHttp_iOS::setUrl(const QUrl& url)
{
    if( mState == Loading ){
        qWarning() << "KHttp_iOS: Can't change URL in loading state";
    } else if( url != mUrl ) {
        mUrl = url;
        emit urlChanged();
    }
}


QQmlListProperty<KHttpField> KHttp_iOS::postFields()
{
    return QQmlListProperty<KHttpField>(this, 0, &KHttp_iOS::appendFunction, &KHttp_iOS::countFunction, &KHttp_iOS::atFunction, &KHttp_iOS::clearFunction);
}


void KHttp_iOS::appendFunction(QQmlListProperty<KHttpField> * o, KHttpField* field)
{
    KHttp_iOS * self = qobject_cast<KHttp_iOS *>(o->object);
    if(self) {
        if( self->mState == Loading ) {
            qWarning("KHttp_iOS: Invalid state when trying to append field");
        } else {
            self->mPostFields.append(field);
        }
    }
}


int KHttp_iOS::countFunction(QQmlListProperty<KHttpField> * o)
{
    KHttp_iOS * self = qobject_cast<KHttp_iOS *>(o->object);
    if(self)
        return self->mPostFields.count();
    return 0;
}

KHttpField * KHttp_iOS::atFunction(QQmlListProperty<KHttpField> * o, int index)
{
    KHttp_iOS * self = qobject_cast<KHttp_iOS *>(o->object);
    if(self) {
        return self->mPostFields.value(index);
    }
    return NULL;
}


void KHttp_iOS::clearFunction(QQmlListProperty<KHttpField> * o)
{
    KHttp_iOS * self = qobject_cast<KHttp_iOS *>(o->object);
    if(self) {
        if( self->mState == Loading ) {
            qWarning("KHttp_iOS: Invalid state when trying to clear fields");
        } else {
            for(int i = 0 ; i < self->mPostFields.size() ; ++i)
                if(self->mPostFields[i] && !self->mPostFields[i]->isInstancedFromQml())
                    delete self->mPostFields[i];
            self->mPostFields.clear();
        }
    }
}

void KHttp_iOS::classBegin()
{
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(s_manager == nil){
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        s_manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:conf];
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectZero];
        s_user_agent = [[web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] retain];
    }
}


void KHttp_iOS::componentComplete()
{
    mComplete = true;
}

qreal KHttp_iOS::progress() const
{
    return mProgress;
}

KHttp_iOS::State KHttp_iOS::state() const
{
    return mState;
}

QString KHttp_iOS::errorString() const
{
    return mErrorString;
}

QString KHttp_iOS::responseText() const
{
    return QString::fromUtf8(mResponse.constData(), mResponse.size());
}

QString KHttp_iOS::method() const
{
    return mMethod;
}

int KHttp_iOS::status() const
{
    return mStatus;
}

void KHttp_iOS::clear()
{
    if( mState == Done || mState == Opened || mState == Unsent ) {
        mState = Unsent;
        mUrl.clear();
        for(int i = 0 ; i < mPostFields.size() ; ++i)
            if(mPostFields[i] && !mPostFields[i]->isInstancedFromQml())
                delete mPostFields[i];
        mPostFields.clear();
        mProgress = 0;
        mStatus = 0;
        mErrorString.clear();
        mResponse.clear();
        
        if(mRequest){
            [(NSURLSessionDataTask*)mRequest cancel];
        }
        [(NSURLSessionDataTask*)mRequest release];
        mRequest = nil;
        
        if(mResponseHeaders){
            [(NSDictionary*)mResponseHeaders release];
            mResponseHeaders = nil;
        }
        
        mHasRawBody = false;
        [(NSData*)mRawBody release];
        mRawBody = nil;
        
        emit stateChanged();
        emit urlChanged();
        emit progressChanged();
        emit statusChanged();
    }
}

void KHttp_iOS::open(const QString method,const QUrl& url)
{
    mMethod = method.toLower();
    if( mState == Unsent )
    {
        setUrl(url);
        mState = Opened;
        emit stateChanged();
    } else {
        qWarning() << "Invalid state of http" << mState << "to open";
    }
}



void KHttp_iOS::send()
{
    if( mState == Opened ) {
        
        NSString *contentType = [(NSMutableDictionary*)mHeasers objectForKey:@"Content-Type"];
        if(contentType == nil){
            contentType = [(NSMutableDictionary*)mHeasers objectForKey:@"content-type"];
        }
        
        NSMutableDictionary *dic = nil;
        
        QList< QPointer<KHttpFieldFile> > files;
        if(mPostFields.length()){
            dic = [NSMutableDictionary new];
            for(int i = 0; i < mPostFields.length(); ++i){
                KHttpField *f = mPostFields[i].data();
                if(!f->validateVield()) {
                    qCritical() << "Failed to validate query fields";
                    continue;
                }
                
                if(f->type() == KHttpField::FieldFile){

                    KHttpFieldFile * file = static_cast<KHttpFieldFile *>(f);
                    files.push_back(file);
                    
                } else {
                    KHttpFieldValue * value = static_cast<KHttpFieldValue *>(f);
                    [dic setObject:value->value().toNSString() forKey:value->name().toNSString()];
                }
                
            }
        }
        
        
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        
        NSString *url = mUrl.toString().toNSString();
        NSError *serializationError = nil;
        NSMutableURLRequest *request = nil;
        
        
        if (files.length()) {
            request = [serializer multipartFormRequestWithMethod:mMethod.toNSString() URLString:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for(int i = 0; i < files.length(); ++i){
                    KHttpFieldFile * file = static_cast<KHttpFieldFile *>(files[i].data());
                    [formData appendPartWithFileURL:file->source().toNSURL() name:file->name().toNSString() error:nil];
                }
            } error:&serializationError];
        } else {
            
            request = [serializer requestWithMethod:mMethod.toNSString() URLString:url parameters:dic error:&serializationError];
        }
        
        if (m_timeout > 0) {
            request.timeoutInterval = m_timeout;
        }
        
        KHttp_iOS *s = this;
        
        if (serializationError) {
            dispatch_async(s_manager.completionQueue ?:dispatch_get_main_queue(), ^{
                s->reply_finished(nil, nil, serializationError);
            });
            return;
        }
        
        if(mHasRawBody && mRawBody){
            request.HTTPBody = (NSData*)mRawBody;
        }
        
        if(contentType == nil){
            if(mHasRawBody && mRawBody){
                contentType = @"application/octet-stream";
            } else if(files.length()){
                contentType = nil; //@"multipart/form-data";
            } else {
                contentType = @"application/x-www-form-urlencoded";
            }
        }
        
        if(contentType){
            [(NSMutableDictionary*)mHeasers setObject:contentType forKey:@"Content-Type"];
        }
        
        if(s_user_agent){
            [(NSMutableDictionary*)mHeasers setObject:s_user_agent forKey:@"user-agent"];
        }
        
        [(NSDictionary*)mHeasers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull ) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
        
        
        NSURLSessionDataTask *dataTask = [s_manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                mProgress = uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
#ifdef QT_DEBUG
                qDebug() << "KHttp_iOS: Progress is" << mProgress;
#endif
                emit progressChanged();
            
            } downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                s->reply_finished(response, responseObject, error);
            }];
        
        mState = Loading;
        mProgress = 0;
        
        mRequest = [dataTask retain];
        
        [dataTask resume];

        emit stateChanged();
        emit progressChanged();
    } else {
        qWarning() << "Invalid state of http" << mState << "to send";
    }
}

void KHttp_iOS::sendFile(const QString& fileName)
{
    if(!canSendFile(mMethod)){
        qCritical() << "Can not add file with [" << mMethod << "] method!";
        return;
    }

    if( mState == Opened ) {
        
        NSString *path = fileName.toNSString();
        NSFileManager *mf = [NSFileManager defaultManager];
        if(![mf isReadableFileAtPath:path]){
            mState = Done;
            mErrorString = fileName + " can not read!";
            mStatus = -1;
            emit stateChanged();
            emit statusChanged();
            return;
        }
        
        NSURL *url = mUrl.toNSURL();
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        KHttp_iOS *s = this;
        NSURLSessionUploadTask *uploadTask = [s_manager uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:fileName.toNSString()] progress:^(NSProgress * _Nonnull uploadProgress) {
            mProgress = uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
#ifdef QT_DEBUG
            qDebug() << "KHttp_iOS: Progress is" << mProgress;
#endif
            emit progressChanged();
            
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            s->reply_finished(response, responseObject, error);
        }];
        
        mRequest = [uploadTask retain];
        
        mState = Loading;
        mProgress = 0;
        
        [uploadTask resume];

        emit stateChanged();
        emit progressChanged();
    } else {
        qWarning() << "Invalid state of http" << mState << "to send";
    }
}


void KHttp_iOS::abort()
{
    if( mState == Loading ) {
        mState = Aborting;
        emit stateChanged();
        [(NSURLSessionDataTask*)mRequest cancel];
    }
}


void KHttp_iOS::addField(const QString& fieldName, const QString& fieldValue)
{
    KHttpFieldValue * field = new KHttpFieldValue(this);
    field->setName(fieldName);
    field->setValue(fieldValue);
    field->setIsInstancedFromQml(false);
    mPostFields.append(field);
}


void KHttp_iOS::addFile(const QString& fieldName, const QString& fileName, const QString& mimeType)
{
    if(!canSendFile(mMethod)){
        qCritical() << "Can not add file with [" << mMethod << "] method!";
        return;
    }
    KHttpFieldFile * field = new KHttpFieldFile(this);
    field->setName(fieldName);
    field->setSource(QUrl::fromLocalFile(fileName));
    field->setMimeType(mimeType);
    field->setIsInstancedFromQml(false);
    mPostFields.append(field);
}

void KHttp_iOS::setHeader(const QString name, const QString value)
{
    [(NSMutableDictionary*)mHeasers setObject:value.toNSString() forKey:name.toNSString()];
}

QString KHttp_iOS::header(const QString name)
{
    NSString *val = [(NSMutableDictionary*)mHeasers objectForKey:name.toNSString()];
    return val.UTF8String;
}

QString KHttp_iOS::responseHeader(const QString name)
{
    if(mResponseHeaders){
        NSString *h = [(NSDictionary*)mResponseHeaders objectForKey:name.toNSString()];
        return h.UTF8String;
    }
    return "";
}

void KHttp_iOS::setBody(const QString body)
{
    if(body.isEmpty()){
        qCritical() << "Http setBody: body can not empty!";
        return;
    }
    mHasRawBody = true;
    
    [(NSData*)mRawBody release];
    QByteArray d = body.toUtf8();
    mRawBody = [[NSData alloc]initWithBytes:d.data() length:d.length()];
}

void _emit_finished_status(KHttp_iOS *s)
{
    emit s->progressChanged();
    emit s->statusChanged();
    emit s->stateChanged();
}

void KHttp_iOS::reply_finished(void * res, void* dd, void * e)
{
    NSHTTPURLResponse * response = (NSHTTPURLResponse*)res;
    id  responseObject = (id)dd;
    NSError * error = (NSError*)e;
    
    mStatus = response.statusCode;
    if (mResponseHeaders) {
        [(NSDictionary*)mResponseHeaders release];
        mResponseHeaders = nil;
    }
    
    mResponseHeaders = [response.allHeaderFields copy];

    if( mStatus == 0 || mStatus == -1 ) {
#ifdef QT_DEBUG
        qDebug() << "KHttp_iOS: request aborted";
#endif
        [(NSURLSessionDataTask*)mRequest release];
        mRequest = nil;
        mProgress = 0;
        mState = Done;
        mBoundaryString.clear();
        QtConcurrent::run(_emit_finished_status, this);
        return;
    }

    NSData *d = nil;
    if (responseObject) {
        if([responseObject isKindOfClass:[NSData class]]){
            d = (NSData*)responseObject;
        } else if([responseObject isKindOfClass:[NSString class]]){
            d = [(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            d = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
        }
    }
    
    if(d){
        mResponse = QByteArray::fromNSData(d);
    }
    

    if( error ) {
#ifdef QT_DEBUG
        qDebug() << "KHttp_iOS: Network error" << error.localizedDescription;
#endif

        [(NSURLSessionDataTask*)mRequest release];
        mRequest = nil;
        mProgress = 1;
        mState = Done;
        mBoundaryString.clear();
        mErrorString = error.localizedDescription.UTF8String;
        QtConcurrent::run(_emit_finished_status, this);
        return;
    }

#ifdef QT_DEBUG
    qDebug() << "KHttp_iOS: request finished";
#endif

    [(NSURLSessionDataTask*)mRequest release];
    mRequest = nil;
    mProgress = 1;
    mState = Done;
    mErrorString.clear();
    QtConcurrent::run(_emit_finished_status, this);
}


