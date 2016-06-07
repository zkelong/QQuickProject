#include "qkit.h"
#include <QScreen>
#include <QGuiApplication>
#include <QWindow>
#include <QQuickWindow>
#include <QtQml>
#include <QVariantMap>
#include <QImageReader>
#include <QQuickItemGrabResult>


#include "kdir.h"
#include "kfiletools.h"
#include "kphotofecther.h"
#include "imagepickerprovider.h"
#include "kfiledownloader.h"
#include "kfiledownloadmanager.h"
#include "kapplicationlistenner.h"
#include "bridge.h"
#include "http/khttp.h"
#include "ksharesdk.h"
#include "kjpush.h"
#include "kjpushlistenner.h"
#include "kwindow.h"
#include "kwindoweventlistenner.h"
#include "kevent.h"
#include "kalipay.h"
#include "kalipaylistenner.h"

class QQuickImageBase : public QObject{
public:
    QImage image() const;
};


static QJSValue aProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);

    QJSValue value = scriptEngine->newQObject(QKit::instance());

    return value;
}

QKit::QKit(QObject *parent) : QObject(parent)
{

}

QKit* QKit::instance()
{
    static QKit* s_kt = nullptr;
    if(!s_kt){
        s_kt = new QKit();
    }
    return s_kt;
}

void QKit::registerTypes(QQmlEngine *engine)
{
    engine->addImportPath("qrc:///");
    engine->rootContext()->setContextProperty("Dir",new KDir());
    engine->rootContext()->setContextProperty("FileTools", KFileTools::instance());
    engine->rootContext()->setContextProperty("K", QKit::instance());
    engine->rootContext()->setContextProperty("ShareSDK", KShareSDK::instance());
    engine->rootContext()->setContextProperty("JPush", KJPush::instance());
    engine->rootContext()->setContextProperty("Alipay", KAlipay::instance());
    engine->addImageProvider(QLatin1String("picker"), new ImagePickerProvider());

    //qmlRegisterSingletonType("QKit", 1, 0, "K", aProvider);
    qmlRegisterType<KDir>("QKit", 1, 0, "KDir");
    qmlRegisterType<PhotoGroup>("QKit", 1, 0, "PhotoGroup");
    qmlRegisterType<KPhotoFecther>("QKit", 1, 0, "PhotoFecther");
    qmlRegisterType<KFileDownloader>("QKit", 1, 0, "FileDownloader");
    qmlRegisterType<KApplicationListenner>("QKit", 1, 0, "ApplicationListenner");
    qmlRegisterType<KShareSDKListenner>("QKit", 1, 0, "ShareSDKListenner");
    qmlRegisterType<KJPushListenner>("QKit", 1, 0, "JPushListenner");
    qmlRegisterType<KWindow>("QKit", 1, 0, "KWindow");
    qmlRegisterType<KWindowEventListenner>("QKit", 1, 0, "WindowEventListenner");
    qmlRegisterType<KKeyEvent>("QKit", 1, 0, "KKeyEvent");
    qmlRegisterType<KMouseEvent>("QKit", 1, 0, "KMouseEvent");
    qmlRegisterType<KAlipayListenner>("QKit", 1, 0, "AlipayListenner");
    KHttp::registerTypes();
}

qreal QKit::dp(qreal pixel)
{
    //return qApp->primaryScreen()->devicePixelRatio() * pixel;
    return qApp->primaryScreen()->logicalDotsPerInch()/72 * pixel;
}

qreal QKit::dpValue()
{
    return qApp->primaryScreen()->devicePixelRatio();
}

qreal QKit::dpiValue()
{
    return qApp->primaryScreen()->logicalDotsPerInch();
}

QString QKit::systemVersion()
{
    return QSysInfo::productVersion();
}


QString QKit:: grab()
{
    QWindow* window = qApp->focusWindow();
    QQuickWindow* w = dynamic_cast<QQuickWindow*>(window);
    if(w){
        QImage image = w->grabWindow();
        if(image.isNull()){

            QWindowList ls = qApp->allWindows();
            for(QWindowList::iterator it = ls.end(); it != ls.begin(); it++){
                w = dynamic_cast<QQuickWindow*>(*it);
                if(w) break;
            }
            if(!w) return QString();
        }

       QString savedPath = QKit::instance()->runTimeCachePath() + "/" + QKit::instance()->randString(8) + ".png";
        bool ret = image.save(savedPath);
        if(ret) return savedPath;
    }
    return QString();
}

QString QKit:: grab(QQuickItem* item)
{
    QImage img = ((QQuickImageBase*)item)->image();
    if(img.isNull())
        return grab();

    QString savedPath = QKit::instance()->runTimeCachePath() + "/" + QKit::instance()->randString(8) + ".png";
    bool ret = img.save(savedPath);
    if(ret) return savedPath;
    return QString();
}

QQuickWindow* QKit:: mainWindow()
{
    QWindow* window = qApp->focusWindow();
    QQuickWindow* w = dynamic_cast<QQuickWindow*>(window);
    return w;
}

QObject* QKit::focusObject()
{
    QObject* item = qApp->focusObject();
    return item;
}


//运行时缓存目录，运行结束后要删除
QString QKit::runTimeCachePath()
{
    static QString s_run_time_cache;
    if (s_run_time_cache.length() == 0) {
        s_run_time_cache = KDir::instance()->cacheLocation() + "/runtime";

        QDir dir(s_run_time_cache);
        if(!dir.exists() && !dir.mkpath(".")){
            qDebug() << "####### create runtime temp path error";
        }

    }
    return s_run_time_cache;
}

//清除运行时的临时文件(程序退出时会自动清理,如非必需不应主动调用)
void QKit::cleanRunTimeCache()
{
    QDir::cleanPath(runTimeCachePath());
}

//生成一个给定长度的随机字符串
QString QKit::randString(int len)
{
    QString ret;
    for (int i = 0; i < len; ++i) {
        int r = qrand()%2 == 0? 65:97;
        QChar ch = qrand()%26 + r;
        ret += ch;
    }
    return ret;
}

//获取设备标识符
QString QKit::getUUID()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return bridge_get_uuid();
#endif

    return "NONE_UUID";
}

void QKit::setSpeaker(bool value)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    set_speaker(value);
#endif

}

bool QKit::isSpeaker()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return is_speaker();
#endif

    return true;
}

void QKit::iOS_setStatusBarStye(int stye)
{
#ifdef Q_OS_IOS
    setStatusBarStye(stye);
#endif
}

double toFloat(QString v){
    double ret = 0;
    bool hasPoint = false;
    for(int i = 0; i < v.length(); ++i){
        char ch = v.at(i).toLatin1();
        if(ch == '.'){
            i++;
            hasPoint = true;
            for(int j = 0; j + i < v.length(); ++j){
                char pc = v.at(j+i).toLatin1();
                if( !(pc >= '0' && pc <= '9') ) break;
                ret += (pc - '0') / ( (j+1)*10.0 );
            }
        }
        if(hasPoint) break;
        if(ch >= '0' && ch <= '9'){
            if(i > 0) ret += (ch - '0') * (i*10.0);
            else ret += (ch - '0');
        } else {
            break;
        }
    }
    return ret;
}

void QKit::enableTranslucentStatusBar(QQmlApplicationEngine *engine)
{

#if defined(Q_OS_IOS)
    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine->rootObjects().first());
    window->showFullScreen();
    m_isTranslucentStatusBar = true;
    QKit::instance()->iOS_setStatusBarStye(QKit::StatusBarStyleLightContent);
#elif defined(Q_OS_ANDROID)
    qDebug() << "-----------------------------";
    qDebug() << "!!#################" << toFloat( systemVersion() );
    if(toFloat( systemVersion() ) >= 4.4){
        m_isTranslucentStatusBar = true;
        android_enableTranslucentStatusBar();
    }
#endif
}

bool QKit::isTranslucentStatusBar()
{
    return m_isTranslucentStatusBar;
}

QString QKit::getAppVersionName()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return bridge_getAppVersionName();
#endif
    return "";
}

bool QKit::openUrl(QString url)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return bridge_openUrl(url);
#endif
    return false;
}
