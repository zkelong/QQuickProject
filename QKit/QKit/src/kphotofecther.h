#ifndef KPHOTOFECTHER_H
#define KPHOTOFECTHER_H

#include <QObject>
#include <QStringList>

class PhotoGroup : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString name MEMBER m_name)
    Q_PROPERTY(QString url MEMBER m_url)
public:
    explicit PhotoGroup(QObject *parent = 0);
    PhotoGroup(QString name, QString url);

protected:
    QString  m_name;
    QString  m_url;
};


class KPhotoFecther : public QObject
{
    Q_OBJECT
public:
    explicit KPhotoFecther(QObject *parent = 0);

    //获取系统相册列表
    Q_INVOKABLE void photoGroups();
    //获取某个相册的所有相片地址列表
    Q_INVOKABLE void photosWithGroupUrl(QString url);    
signals:
    void photoGroupCallback(PhotoGroup* group);
    void photoCallback(QString photoUrl);

public slots:
};

#endif // KPHOTOFECTHER_H
