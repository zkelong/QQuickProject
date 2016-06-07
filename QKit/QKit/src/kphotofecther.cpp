#include "kphotofecther.h"
#include <QImageReader>
#include <QImage>
#include "kdir.h"
#include "qkit.h"


#include "file_tools.h"


PhotoGroup::PhotoGroup(QObject *parent) : QObject(parent)
{
    
}


PhotoGroup::PhotoGroup(QString name, QString url):QObject(nullptr),m_name(name),m_url(url)
{
    
}

KPhotoFecther::KPhotoFecther(QObject *parent) : QObject(parent)
{

}


//获取系统相册列表
void KPhotoFecther::photoGroups()
{
#ifdef Q_OS_IOS
    FetchPhotoGroupsCallback callback = [this](PhotoGroup* group){
        emit this->photoGroupCallback(group);
    };
    ios_photoGroups(callback);
#else
    QString root = KDir::instance()->standardPicturesLocation();

    emit this->photoGroupCallback(new PhotoGroup(".", root)); //当前目录

#ifdef Q_OS_ANDROID
    QString a_path = android_getStandardPicturePath();
    emit this->photoGroupCallback(new PhotoGroup(".", a_path)); //相册主目录
    QDir a_dir(a_path);
    QStringList a_dirs = a_dir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
    for (auto it = a_dirs.begin(); it != a_dirs.end(); ++it) {
        if((*it).at(0) != '.'){
            emit this->photoGroupCallback(new PhotoGroup(*it, root + "/" + *it));
        }
    }
#endif

    QDir dir(root);
    QStringList dirs = dir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
    for (auto it = dirs.begin(); it != dirs.end(); ++it) {
        emit this->photoGroupCallback(new PhotoGroup(*it, root + "/" + *it));
    }
    emit this->photoGroupCallback(nullptr);
#endif

}

//获取某个相册的所有相片地址列表
void KPhotoFecther::photosWithGroupUrl(QString url)
{
#ifdef Q_OS_IOS
    FetchPhotoListCallback callback = [this](QString url){
        emit this->photoCallback(url);
    };
    ios_photosWithGroupUrl(url, callback);
#else
    KDir dir(url);
    QStringList dirs = dir.entryList(KDir::Files);
    for (auto it = dirs.begin(); it != dirs.end(); ++it) {
        emit this->photoCallback(url + "/" + *it);
    }
    emit this->photoCallback("");
#endif
    
}




