//
//  HTakeImageHelper.m
//  talkweibo
//
//  Created by admin on 3/19/13.
//
//

#include <UIKit/UIKit.h>
#import "HTakeImageHelper.h"
#include "../ImagePicker.h"

 void qimage_picker_open(QSize size, int type, bool edit, QImagePickerCallbak callback)
{
    HTakeImageHelper* taker = [[HTakeImageHelper alloc]init];
        taker.scaleToSize = CGSizeMake(size.width(), size.height());
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (type == QImagePicker::QPickerChoise) {
            [taker showImagePickerControllerWithTitle:@"请选择照片" viewController:vc edit:edit callback:^(HTakeImageHelper *helper, NSDictionary *info) {
                UIImage *img = [info objectForKey:@"data"];
                if(img)
                {
                    NSData *data = UIImageJPEGRepresentation(img, 1);
                    callback((const char*)[data bytes], (uint)[data length]);
                } else {
                    callback(nullptr, 0);
                }
            }];
        } else {

            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if(type == QImagePicker::QPickerPhotoAlbum){
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [taker showImagePickerControllerWithViewController:vc type:sourceType edit:edit callback:^(HTakeImageHelper *helper, NSDictionary *info) {
                UIImage *img = [info objectForKey:@"data"];
                if(img){
                    NSData *data = UIImageJPEGRepresentation(img, 1);

                    size_t length = 0;
                    callback((const char*)[data bytes], (uint)[data length]);
                } else {
                    callback(nullptr, 0);
                }
            }];
        }
}
