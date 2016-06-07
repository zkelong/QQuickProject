//
//  HTakeImageHelper.m
//  talkweibo
//
//  Created by admin on 3/19/13.
//
//


#include <QStandardPaths>
#include <QDir>
#include <QtCore/qbuffer.h>
#include "ImagePicker.h"

extern void qimage_picker_open(QSize size, int type, bool edit, QImagePickerCallbak callback);

#ifndef Q_OS_IOS
void qimage_picker_open(QSize size, int type, bool edit, QImagePickerCallbak callback)
{
}
#endif

QString saveImage(QImage& img, QString name)
{
    if(img.isNull())
        return QString();

    QString savedPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    if(savedPath.isEmpty()) savedPath = QDir::currentPath();
    savedPath += "/" + name;
    bool ret = img.save(savedPath);
    if(ret) {
        return savedPath;
    }
    return QString();
}

QImagePicker :: QImagePicker(): m_size(800,600),m_source(QPickerChoise),m_edit(false)
{

}

QImagePicker ::~QImagePicker()
{

}


void QImagePicker ::open()
{
    QImagePickerCallbak callback = [this] (const char* data, uint sz){
        if(data){
            QByteArray jpgData = QByteArray::fromRawData(data, sz);
            QBuffer buffer(&jpgData);
            QImageReader reader(&buffer);
            QImage image = reader.read();

//            QSize imgSize = reader.size();
//            int downScaleSteps = 0;
//            while (imgSize.width() > 600 && downScaleSteps < 8) {
//                imgSize.rwidth() /= 2;
//                imgSize.rheight() /= 2;
//                downScaleSteps++;
//            }
//            reader.setScaledSize(imgSize);
//            QImage snapPreview = reader.read();
//            QString pre_path = saveImage(snapPreview,"preview.jpg");
            QString path = saveImage(image, QString('A' + qrand()%('z'-'A')) + "takeImage.jpg");
            image = QImage();
//            snapPreview = QImage();
            emit didSelectImage(QUrl::fromLocalFile(path), path);

            //QMetaObject::invokeMethod(this, "didSelectImage", Qt::QueuedConnection,Q_ARG(QImage, snapPreview));
        } else {
            emit didCancelled();
        }
    };

    qimage_picker_open(m_size, m_source, m_edit, callback);
}


/*
QString QImagePicker::save()
{
    if(m_image.isNull())
        return QString();

    QString savedPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    if(savedPath.isEmpty()) savedPath = QDir::currentPath();
    savedPath += "/grabTemp.png";
    bool ret = m_image.save(savedPath);
    if(ret) {
        emit didSaved(QUrl::fromLocalFile(savedPath));
        return savedPath;
    }
    return QString();
}
*/


