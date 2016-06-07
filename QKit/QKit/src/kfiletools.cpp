#include "kfiletools.h"
#include <QtCore/qbuffer.h>
#include <QImageReader>
#include <QImage>
#include <QTransform>
#include "kdir.h"
#include "qkit.h"
#include "file_tools.h"


static KFileTools*  s_file_tools = nullptr;



KFileTools::KFileTools(QObject *parent) : QObject(parent)
{

}

KFileTools* KFileTools::instance()
{
    if(!s_file_tools) s_file_tools = new KFileTools();
    return s_file_tools;
}

QImage KFileTools::scaleImage(QString path, int maxWidth, int maxHeight)
{
    QImageReader reader(path);
    if(!reader.canRead())
        return QImage();
    QImage img = reader.read();
    if(img.isNull())
        return img;

    float sw = 1,sh = 1;
    if(img.width() > maxWidth)
        sw = maxWidth/img.width();
    if(img.height() > maxHeight)
        sh = maxHeight/img.height();
    float scale = qMin(sw,sh);
    if(scale >= 1)
        return img;
    return img.scaled(img.width()*scale, img.height()*scale);
}

QImage KFileTools::scaleImage(QString path, int maxArea)
{
    QImageReader reader(path);
    if(!reader.canRead())
        return QImage();
    QImage img = reader.read();
    if(img.isNull())
        return img;

    int originArea = img.width()*img.height();
    float scale = maxArea/originArea;
    if(scale >= 1)
        return img;
    return img.scaled(img.width()*scale, img.height()*scale);
}

QString KFileTools::readablePath(QString path)
{
    if(path.indexOf("image://picker/") == 0){
        path.replace(QRegExp("^image://picker/"),"");
    }

#ifdef Q_OS_IOS
    if(path.indexOf("assets-library://") == 0){ //ios 相册
        QString dstPath = QKit::instance()->runTimeCachePath() + "/" + QKit::instance()->randString(8) + ".png";
        if(ios_copyImageToPath(path, dstPath)){
            return dstPath;
        }
        return "";
    } else {
        return path;
    }
#else
    return path;
#endif
}

QString KFileTools::assetsPath(QString srcPath)
{

#ifdef Q_OS_ANDROID
    QString path = QString("assets:/") + srcPath;
    QFile file(path);
    if(file.exists()){
        QString dstPath = QKit::instance()->runTimeCachePath() + "/b/" + srcPath;
        if(QFile(dstPath).exists())
            return dstPath;
        QDir dir(KDir::instance()->dirPath(dstPath));
        if(!dir.exists() && !dir.mkpath(".")){
            qDebug() << "####### create runtime temp path error";
        }
        file.copy(dstPath);
        return dstPath;
    } else {
        qDebug() << "*****************" << path << " not exists";
    }
#endif

    return QDir::currentPath() + "/" + srcPath;
}

QUrl KFileTools::assetsUrl(QString srcPath)
{
    return QUrl::fromLocalFile(assetsPath(srcPath));
}


QString KFileTools::rotateImage(QString path, qreal angle)
{
    QImage img(path);
    if(img.isNull()){
        qDebug() << "Rotate image: file not loaded! " << path;
    }
    QTransform trans;
    trans.rotate(angle);
    QImage newImg = img.transformed(trans);
    newImg.save(path);
    return path;
}
