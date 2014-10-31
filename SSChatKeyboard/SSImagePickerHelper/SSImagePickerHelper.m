//
//  SSImagePickerHelper.m
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-13.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "SSImagePickerHelper.h"
#import "UIImage+FixOrientation.h"

@interface SSImagePickerHelper ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, copy) SSImagePickerHelperDidCaptureImageBlock didCaptureImageBlock;

@end

@implementation SSImagePickerHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allowsEditing = YES;
    }
    return self;
}

- (void)showImagePickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completionHandler:(SSImagePickerHelperDidCaptureImageBlock)completionHandler
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if (completionHandler) {
            completionHandler(nil, nil);
        }
        return;
    }
    
    self.didCaptureImageBlock = completionHandler;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = self.allowsEditing;
    imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    [viewController presentViewController:imagePickerController animated:YES completion:NULL];
    
}

- (void)dismissImagePickerViewController:(UIImagePickerController *)picker {
    __weak __typeof(self)weakSelf = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        weakSelf.didCaptureImageBlock = nil;
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = nil;
        if (self.allowsEditing) {
            image = info[UIImagePickerControllerEditedImage];
        }
        else {
            image = info[UIImagePickerControllerOriginalImage];
        }
        
        if (self.didCaptureImageBlock) {
            image = [image fixOrientation];
            self.didCaptureImageBlock(image, info);
        }
    }
    else {
        if (self.didCaptureImageBlock) {
            self.didCaptureImageBlock(nil, info);
        }
    }
    
    [self dismissImagePickerViewController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.didCaptureImageBlock) {
        self.didCaptureImageBlock(nil, nil);
    }
    [self dismissImagePickerViewController:picker];
}

@end


















