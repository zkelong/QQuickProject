#include "imagepickerprovider.h"
#include <QImageReader>
#include <QDebug>
#include "./file_tools.h"

ImagePickerProvider::ImagePickerProvider() : QQuickImageProvider(QQmlImageProviderBase::Image)
{

}


QImage ImagePickerProvider::requestImage(const QString &id, QSize *size, const QSize& requestedSize)
{
    qDebug() << "id = " << id << requestedSize << *size;
    
    bool isThumb = id.indexOf("thumb") == 0;
    QString path = id;
    if (isThumb) {
        path.replace(QRegExp("^thumb/"),"");
    }

#ifdef Q_OS_IOS
    if(path.indexOf("assets-library://") == 0){
        if (isThumb) {
            return ios_thumbnailImageWithPhotoUrlSynch(path);
        }
        return ios_imageWithPhotoUrlSynch(path);
    }
#endif

    QImageReader reader(path);
    int width = requestedSize.width() > 0 ? requestedSize.width() : reader.size().width();
    int height = requestedSize.height() > 0 ? requestedSize.height() : reader.size().height();
    if(width == 0){
        return QImage();
    }

    if (isThumb) {
        width = 150;
        height = 150;
    }

    if(size){
        *size = QSize(width, height);
    }
    if(requestedSize.width() > 0 || isThumb){
        reader.setScaledSize(*size);
    }
    return reader.read();
}
