//
//  HTakeImageHelper.h
//  talkweibo
//
//  Created by admin on 3/19/13.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HTakeImageHelper;
typedef void (^HTakeImageBlock)(HTakeImageHelper *helper,NSDictionary *info);

@interface HTakeImageHelper : NSObject
 <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,copy) HTakeImageBlock takeBlock;
@property (nonatomic, assign) CGSize scaleToSize;

-(void)showImagePickerControllerWithTitle:(NSString*)title viewController:(UIViewController*)controller callback:(HTakeImageBlock)black;
-(void)showImagePickerControllerWithTitle:(NSString*)title viewController:(UIViewController*)controller edit:(BOOL)edit callback:(HTakeImageBlock)black;

-(void)showImagePickerControllerWithViewController:(UIViewController*)controller type:(UIImagePickerControllerSourceType)type callback:(HTakeImageBlock)black;
-(void)showImagePickerControllerWithViewController:(UIViewController*)controller type:(UIImagePickerControllerSourceType)type edit:(BOOL)edit callback:(HTakeImageBlock)black;

+ (UIImage*)imageScale:(UIImage*)imgOrig w:(CGFloat)w h:(CGFloat)h;
@end
