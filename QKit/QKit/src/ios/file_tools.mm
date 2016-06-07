
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

#if defined(Q_OS_MAC)
#import <CoreServices/CoreServices.h>
#else
#import <MobileCoreServices/MobileCoreServices.h>
#endif

#include "../file_tools.h"


static ALAssetsLibrary *library = nullptr;
static NSMutableDictionary* assets_cache = nullptr;
static NSLock* s_ALLocker = nullptr;

void file_tools_init()
{
    if (!library) {
        library = [[ALAssetsLibrary alloc]init];
        assets_cache = [[NSMutableDictionary alloc]init];
        s_ALLocker = [[NSLock alloc] init];
    }
}

id _alCacheGet(NSString* key)
{
    [s_ALLocker lock];
    id ret = [assets_cache objectForKey:key];
    [s_ALLocker unlock];
    return ret;
}

id _alCacheSet(id obj, NSString* key)
{
    [s_ALLocker lock];
    [assets_cache setObject:obj forKey:key];
    [s_ALLocker unlock];
}

QImage _CGImageToQImage(CGImageRef cgImg)
{
    NSMutableData *md = [[[NSMutableData alloc]init] autorelease];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)md, kUTTypePNG, 1, NULL);
    if (!destination) {
        NSLog(@"Failed to create CGImageDestination");
        return QImage();
    }
    
    CGImageDestinationAddImage(destination, cgImg, nil);
    if (!CGImageDestinationFinalize(destination)) {
        printf("Faild to write image");
        CFRelease(destination);
        return QImage();
    }
    
    QImage retImg = QImage::fromData((const uchar *)md.bytes, md.length);;
    CFRelease(destination);
    return retImg;
}

//取得相册列表
void ios_photoGroups(FetchPhotoGroupsCallback callback)
{
    file_tools_init();
    
    __block QList<PhotoGroup*>  ret;

    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        Q_UNUSED(stop);
        if (!group) {
            callback(nullptr);
            return;
        }
        NSLog(@"group %@",group);
        NSString* name = [group valueForProperty:ALAssetsGroupPropertyName];
        NSString* url = [(NSURL*)[group valueForProperty:ALAssetsGroupPropertyURL] absoluteString];
        PhotoGroup* g = new PhotoGroup(QString(name.UTF8String), QString(url.UTF8String));
        callback(g);
        
    } failureBlock:^(NSError *error) {
        Q_UNUSED(error);
        callback(nullptr);
    }];
    
}

//获取某个相册的所有相片地址列表
void ios_photosWithGroupUrl(QString url ,FetchPhotoListCallback callback)
{
    file_tools_init();
    
    __block QStringList ret;
    NSURL* u = [NSURL URLWithString:url.toNSString()];
    
    [library groupForURL:u resultBlock:^(ALAssetsGroup *group) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            Q_UNUSED(index);
            Q_UNUSED(stop);
            if (!result) {
                callback(QString());
                return ;
            }
            
            NSString* aurl = [(NSURL*)[result valueForProperty:ALAssetPropertyAssetURL] absoluteString];
            _alCacheSet(result,aurl);
            callback(QString::fromNSString(aurl));
        }];
    } failureBlock:^(NSError *error) {
        Q_UNUSED(error);
        callback(QString());
    }];
    
}

//根据指定相册图片地址取得相片缩略图
void ios_thumbnailImageWithPhotoUrl(QString url ,FetchPhotosCallback callback)
{
    file_tools_init();
    
    NSURL* u = [NSURL URLWithString:url.toNSString()];

    [library assetForURL:u resultBlock:^(ALAsset *asset) {
        if (!asset) {
            callback(QImage());
            return ;
        }
        CGImageRef img = [asset thumbnail];
        
        callback( _CGImageToQImage(img) );

    } failureBlock:^(NSError *error) {
        Q_UNUSED(error);
        callback(QImage());
    }];

}

//根据指定相册图片地址取得相片缩略图,同步
QImage ios_thumbnailImageWithPhotoUrlSynch(QString url )
{
    file_tools_init();
    
    ALAsset *asset = _alCacheGet(url.toNSString());
    if (!asset) {
        return QImage();
    }
    
    CGImageRef img = [asset thumbnail];

    return _CGImageToQImage(img);
}

//根据指定相册图片地址取得相片原图
void ios_imageWithPhotoUrl(QString url,FetchPhotosCallback callback)
{
    file_tools_init();
    
    NSURL* u = [NSURL URLWithString:url.toNSString()];

    [library assetForURL:u resultBlock:^(ALAsset *asset) {
        if (!asset) {
            callback(QImage());
            return ;
        }
        
        CGImageRef img = [[asset defaultRepresentation] fullResolutionImage];
        
        callback( _CGImageToQImage(img) );
    } failureBlock:^(NSError *error) {
        Q_UNUSED(error);
        callback(QImage());
    }];
    
}

//根据指定相册图片地址取得相片原图,同步
QImage ios_imageWithPhotoUrlSynch(QString url)
{
    file_tools_init();
    
    ALAsset *asset = _alCacheGet(url.toNSString());
    if (!asset) {
        return QImage();
    }
    
    CGImageRef img = [[asset defaultRepresentation] fullResolutionImage];

    return _CGImageToQImage(img);
}

//将指定的相册图片存到其他地址
bool ios_copyImageToPath(QString srcUrl, QString dstPath)
{
    file_tools_init();
    
    ALAsset *asset = _alCacheGet(srcUrl.toNSString());
    if (!asset) {
        return false;
    }

    CGImageRef img = [[asset defaultRepresentation] fullResolutionImage];

    CFURLRef tUrl = (CFURLRef)[NSURL fileURLWithPath:dstPath.toNSString()];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(tUrl, kUTTypePNG, 1, NULL);
    if (!destination) {
        NSLog(@"Failed to create CGImageDestination for %@", dstPath.toNSString());
        return false;
    }

    CGImageDestinationAddImage(destination, img, nil);
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Faild to write image to %@", dstPath.toNSString());
        CFRelease(destination);
        return true;
    }
    CFRelease(destination);
    return true;
}




