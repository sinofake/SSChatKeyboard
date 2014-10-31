//
//  SSImagePickerHelper.h
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-13.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SSImagePickerHelperDidCaptureImageBlock)(UIImage *image, NSDictionary *info);

@interface SSImagePickerHelper : NSObject

@property (nonatomic, assign) BOOL allowsEditing;//default YES;

/** eg:
 __weak __typeof(self)weakSelf = self;

 [weakSelf.imagePickerHelper showImagePickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:weakSelf completionHandler:^(UIImage *image, NSDictionary *info) {
     //这里应当使用weakSelf，避免引用循环
 }]
 */
- (void)showImagePickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completionHandler:(SSImagePickerHelperDidCaptureImageBlock)completionHandler;

@end
