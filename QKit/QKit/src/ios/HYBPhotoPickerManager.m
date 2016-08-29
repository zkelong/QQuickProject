

#import "HYBPhotoPickerManager.h"


#define kGlobalThread  dispatch_get_main_queue()
#define kMainThread dispatch_get_main_queue()

@interface HYBPhotoPickerManager () <UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate>

@property (nonatomic, assign)     UIViewController          *fromController;
@property (nonatomic, copy)     HYBPickerCompelitionBlock completion;
@property (nonatomic, copy)     HYBPickerCancelBlock      cancelBlock;

@end

@implementation HYBPhotoPickerManager

+ (HYBPhotoPickerManager *)shared {
    static HYBPhotoPickerManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });

    return sharedObject;
}

-(void)takeImage:(UIViewController *)fromController editing:(BOOL)editing completion:(HYBPickerCompelitionBlock)completion
     cancelBlock:(HYBPickerCancelBlock)cancelBlock
{
    self.completion = [completion copy];
    self.cancelBlock = [cancelBlock copy];
    self.fromController = fromController;
    if (fromController == nil) {
        self.fromController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = editing;
    picker.delegate = self;
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7) {
        picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;
    }
    // 设置导航默认标题的颜色及字体大小
    picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    [self.fromController presentViewController:picker animated:YES completion:nil];
}

- (void)showActionSheetInView:(UIView *)inView
               fromController:(UIViewController *)fromController
                   completion:(HYBPickerCompelitionBlock)completion
                  cancelBlock:(HYBPickerCancelBlock)cancelBlock {
    self.completion = [completion copy];
    self.cancelBlock = [cancelBlock copy];
    self.fromController = fromController;
    if (fromController == nil) {
        self.fromController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    dispatch_async(kGlobalThread, ^{
        UIActionSheet *actionSheet = nil;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            actionSheet  = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:(id<UIActionSheetDelegate>)self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", @"拍照上传", nil];
        } else {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:(id<UIActionSheetDelegate>)self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"从相册选择", nil];
        }
        
        dispatch_async(kMainThread, ^{
            [actionSheet showInView:inView];
        });
    });
    
    return;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // 从相册选择
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            
            if ([UIDevice currentDevice].systemVersion.integerValue >= 7) {
                picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;
            }
            // 设置导航默认标题的颜色及字体大小
            picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }
    } else if (buttonIndex == 1) { // 拍照
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        if ([UIDevice currentDevice].systemVersion.integerValue >= 7) {
            picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;
        }
        // 设置导航默认标题的颜色及字体大小
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        [self.fromController presentViewController:picker animated:YES completion:nil];
    }
    return;
}

#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage *image = [[info valueForKey:UIImagePickerControllerEditedImage] retain];
    if (!image) {
        image = [[info valueForKey:UIImagePickerControllerOriginalImage] retain];
    }
    if (image && self.completion) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        

        dispatch_async(kMainThread, ^{
            self.completion(image);
            [image release];
        });
    }
    return;
}

// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.cancelBlock) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.cancelBlock();
    }
    return;
}

@end
