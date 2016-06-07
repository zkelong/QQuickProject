//
//  HTakeImageHelper.m
//  talkweibo
//
//  Created by admin on 3/19/13.
//
//

#import "HTakeImageHelper.h"
#import "JSBlocksActionSheet.h"

@implementation HTakeImageHelper
@synthesize takeBlock;
@synthesize scaleToSize;

@class FCUtlAppleWapper;

UIPopoverController *popover;

+ (UIImage*)imageScale:(UIImage*)imgOrig w:(CGFloat)w h:(CGFloat)h
{
    CGFloat imgW = imgOrig.size.width;
    CGFloat imgH = imgOrig.size.height;
    
    CGFloat scale1 = w/imgW;
    CGFloat scale2 = h/imgH;
    
    CGFloat scale = scale1 > scale2 ? scale1 : scale2;
    
    if(scale > 1)
        return imgOrig;
    
    UIImage*			imgDst = nil;
	UIGraphicsBeginImageContext(CGSizeMake(imgW*scale, imgH*scale));
    [imgOrig drawInRect:CGRectMake(0, 0, imgW*scale, imgH*scale)];
    imgDst = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    CGRect rect = CGRectMake(0, 0, w, h);
    imgOrig = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([imgDst CGImage], rect)];
    
    return imgOrig;
}

-(id)init
{
    self = [super init];
    scaleToSize = CGSizeMake(140, 140);
    return self;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    takeBlock(self,nil);
}

-(void)scaleImage:(UIImage*)image
{
    UIImage *s = [HTakeImageHelper imageScale:image w:scaleToSize.width h:scaleToSize.height];
    NSData* data = UIImageJPEGRepresentation(s, 1);
    
    //如果是iphone平台
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            takeBlock(self,@{@"data":s});
        });
    }
    else
    {
        //zhou
        dispatch_async(dispatch_get_main_queue(), ^{
            takeBlock(self,@{@"data":s});
        });
    }
}

//zhou
/*-(void)getdata:(UIImage*)s
{
    [FCUtlAppleWapper getHeadData:s];
}*/

/*
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{    
    if(image)
    {
        [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:image];
    }
    [picker dismissModalViewControllerAnimated:YES];
}
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString*					mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	UIImage						*imgOrig = nil;

	if([mediaType isEqualToString:@"public.image"])
	{
        imgOrig = [info objectForKey:UIImagePickerControllerEditedImage];
        if(!imgOrig)
        {
            imgOrig = [info objectForKey:UIImagePickerControllerOriginalImage ];
        }		
	}
    
    if(imgOrig)
    {
        [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:imgOrig];
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [picker dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [popover dismissPopoverAnimated:YES];
    }
}

-(void)showImagePickerControllerWithViewController:(UIViewController*)controller type:(UIImagePickerControllerSourceType)type edit:(BOOL)edit callback:(HTakeImageBlock)black
{
    UIImagePickerController *imgPicker = [[[UIImagePickerController alloc]init]autorelease];
    imgPicker.allowsEditing = edit;
	imgPicker.sourceType = type;
	imgPicker.delegate = self;
    //imgPicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
    
    //如果是iphone平台
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        imgPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        self.takeBlock = black;
        [controller presentModalViewController:imgPicker animated:YES];
    }
    else
    {
        //ipad
        popover = [[UIPopoverController alloc]initWithContentViewController:imgPicker];
        //permittedArrowDirections 设置箭头方向
        self.takeBlock = black;
        UIView *root_view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        [popover presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:root_view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)showImagePickerControllerWithViewController:(UIViewController*)controller type:(UIImagePickerControllerSourceType)type callback:(HTakeImageBlock)black
{
    [self showImagePickerControllerWithViewController:controller type:type edit:NO callback:black];
}

-(void)showImagePickerControllerWithTitle:(NSString*)title viewController:(UIViewController*)controller callback:(HTakeImageBlock)black
{
    [self showImagePickerControllerWithTitle:title viewController:controller edit:NO callback:black];
}

-(void)showImagePickerControllerWithTitle:(NSString*)title viewController:(UIViewController*)controller edit:(BOOL)edit callback:(HTakeImageBlock)black
{   
    [JSBlocksActionSheet showActionSheetInView:controller.view withTitle:title dismissedCallback:^(JSBlocksActionSheet *actionSheet, int buttonIndex) {
        
        if(buttonIndex == 0)
        {
            [self showImagePickerControllerWithViewController:controller type:UIImagePickerControllerSourceTypeCamera edit:edit callback:^(HTakeImageHelper *helper, NSDictionary *info) {
                
                black(helper,info);
            }];

        }
        else if(buttonIndex == 1)
        {
            [self showImagePickerControllerWithViewController:controller type:UIImagePickerControllerSourceTypePhotoLibrary edit:edit callback:^(HTakeImageHelper *helper, NSDictionary *info) {
                
                black(helper,info);
            }];
        }
    } cancelButtonTitle:NSLocalizedStringFromTable(@"取消",@"Localization",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"拍照",@"Localization",nil),
     NSLocalizedStringFromTable(@"相册",@"Localization",nil), nil];

}
@end
