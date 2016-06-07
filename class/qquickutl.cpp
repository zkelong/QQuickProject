#include <QScreen>
#include <QGuiApplication>
#include <QWindow>
#include <QQuickWindow>
#include <QStandardPaths>
#include <QDir>
#include <QFileDialog>
#include <QImageReader>
#include "qquickutl.h"


#define INCH 72
//#define INCH 96


//QImage image() const
template<typename T>
struct HasImageFunction {
        template<typename U, QImage (U::*)() const >
        struct matcher;

        template<typename U>
        static char helper(matcher<U, &U::image> *);

        template<typename U>
        static int helper(...);

        enum { value = sizeof(helper<T>(NULL)) == sizeof(char*) };
 };

template <bool>
struct ImageWrapper {};

template<>
struct ImageWrapper<true> {
        template<typename T>
        static QImage image(T &x) {
            return x->image();
        }
 };

template<>
struct ImageWrapper<false> {
        template<typename T>
        static QImage image(T &x) {
            Q_UNUSED(x);
            return QImage();
        }
 };

template<typename T>
QImage image(const T &x) {
        return ImageWrapper<HasImageFunction<T>::value>::image(x);
}
//QImage image() const


class QQuickImageBase : public QObject{
public:
    QImage image() const;
};

QQuickUtl::QQuickUtl(QObject *parent) : QObject(parent),dp_scale(0.0)
{
    QScreen *screen = qApp->primaryScreen();
    dp_scale = INCH / screen->logicalDotsPerInch();
}

QQuickUtl::~QQuickUtl()
{

}

QQuickUtl* QQuickUtl:: instance()
{
    static QQuickUtl s_utl;
    return &s_utl;
}

double QQuickUtl:: dpScale()
{
    return dp_scale;
}

double QQuickUtl:: dp(double pixel)
{
    return int(pixel / dp_scale);
}

QString QQuickUtl:: grab()
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

        QString savedPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
        if(savedPath.isEmpty()) savedPath = QDir::currentPath();
        savedPath += "/grabTemp.png";
        bool ret = image.save(savedPath);
        if(ret) return savedPath;
    }
    return QString();
}

QString QQuickUtl:: grab(QQuickImage* item)
{
    QQuickImageBase* base = (QQuickImageBase*)item;
//    QImage img = ((QQuickImageBase*)item)->image();
    QImage img = image(base);
    if(img.isNull())
        return grab();

    QString savedPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    if(savedPath.isEmpty()) savedPath = QDir::currentPath();
    savedPath += "/grabTemp.png";
    bool ret = img.save(savedPath);
    if(ret) return savedPath;
    return QString();
}

QObject* QQuickUtl::focusObject()
{
    QObject* item = qApp->focusObject();
    return item;
}
