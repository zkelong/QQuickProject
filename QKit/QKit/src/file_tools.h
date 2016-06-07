#ifndef FILE_TOOLS_H
#define FILE_TOOLS_H
#include <QImage>
#include <QPixmap>
#include "kphotofecther.h"
#include <functional>

//获取相册的回调，当group为nillptr时代表已获取完成
typedef std::function<void (PhotoGroup* group)> FetchPhotoGroupsCallback;

//获取相片列表时的回调，url为空时代表已完成
typedef std::function<void (QString url)> FetchPhotoListCallback;

//获取相片时的回调，image为空时代表已完成
typedef std::function<void (QImage image)> FetchPhotosCallback;


void ios_photoGroups(FetchPhotoGroupsCallback callback);

void ios_photosWithGroupUrl(QString url,FetchPhotoListCallback callback);

void ios_thumbnailImageWithPhotoUrl(QString url,FetchPhotosCallback callback);

//根据指定相册图片地址取得相片缩略图,同步
QImage ios_thumbnailImageWithPhotoUrlSynch(QString url );

void ios_imageWithPhotoUrl(QString url,FetchPhotosCallback callback);

//根据指定相册图片地址取得相片原图,同步
QImage ios_imageWithPhotoUrlSynch(QString url);

bool ios_copyImageToPath(QString srcUrl, QString dstPath);


QString android_getStandardPicturePath();

#endif // FILE_TOOLS_H

