#ifndef IMAGEPICKERPROVIDER_H
#define IMAGEPICKERPROVIDER_H

#include <QQuickImageProvider>

//处理 image://picker
//如果为 image://picker/thumb 则处理为缩略图
class ImagePickerProvider : public QQuickImageProvider
{
public:
    ImagePickerProvider();
    virtual QImage requestImage(const QString &id, QSize *size, const QSize& requestedSize);
};

#endif // IMAGEPICKERPROVIDER_H
