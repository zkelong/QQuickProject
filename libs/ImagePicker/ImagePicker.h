//
//  HTakeImageHelper.h
//  talkweibo
//
//  Created by admin on 3/19/13.
//
//

#ifndef QImagePicker_H
#define QImagePicker_H

#include <QObject>
#include <QQuickItem>
#include <QImage>
#include <QImageReader>
#include <functional>

typedef std::function<void (const char* data, uint size)> QImagePickerCallbak;

class QImagePicker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QPickerType source MEMBER m_source)
    Q_PROPERTY(QSize size MEMBER m_size)
    Q_PROPERTY(bool edit MEMBER m_edit)
    Q_ENUMS(QPickerType)
public:
     enum QPickerType{
            QPickerChoise,  //由用户自己选择
            QPickerPhotoAlbum, //从相册
            QPickerCamera //从相机
        };

    QImagePicker();
    ~QImagePicker();

    Q_INVOKABLE virtual void open();

signals:
    void didSelectImage(QUrl preview,QString savedPath);
    void didCancelled();

public slots:
//    QString save();

protected:
    QPickerType m_source;
    QSize m_size;
//    QImage m_image;
    bool m_edit;
};

#endif
