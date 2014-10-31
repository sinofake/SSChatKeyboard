//
//  SSPhotoView.m
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-22.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "SSPhotoView.h"
#import "SSImagePickerHelper.h"
#import "SSPhotoImageView.h"
#import "UzysAssetsPickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+FixOrientation.h"
#import "SSImageUtility.h"

@interface SSPhotoView ()<UIActionSheetDelegate, SSPhotoImageViewDelegate, UzysAssetsPickerControllerDelegate>
@property (nonatomic, assign) SSPhotoViewType type;

@property (nonatomic, strong) SSImagePickerHelper *imagePickerHelper;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, strong) TopAlignLabel *tipLabel;

@end

@implementation SSPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.type = SSPhotoViewTypeKeyboard;
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(SSPhotoViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = UIColorFromHex(0xeae6e5);
    
    _imageViewArray = [[NSMutableArray alloc] init];
    
    UIImage *image = [SSImageUtility photoImageViewAddImage];
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setImage:image forState:UIControlStateNormal];
    
//    CGFloat originX = 0.f;
//    if (self.type == SSPhotoViewTypeKewboard) {
//        originX = 244/2.f;
//    }
//    else {
//        originX = 21;
//    }
    _addButton.frame = CGRectMake(244/2.f, 65/2.f, image.size.width, image.size.height);
    
    
    [_addButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

    [self.addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    
    _tipLabel = [[TopAlignLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addButton.frame) + 43/2.f, 320, 20) font:12 textColor:UIColorFromHex(0x888381) text:@"点击添加图片"];
    [self addSubview:_tipLabel];
    
}

- (void)addButtonClick:(UIButton *)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [as showInView:self];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
        type = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1) {
        type = UIImagePickerControllerSourceTypePhotoLibrary;

        
        if (self.type == SSPhotoViewTypeFaTie) {
            UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
            appearanceConfig.finishSelectionButtonColor = UIColorFromHex(0xff5f54);
            //appearanceConfig.assetsGroupSelectedImageName = @"checker.png";
            [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
            
            UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.maximumNumberOfSelectionVideo = 0;
            picker.maximumNumberOfSelectionPhoto = 3 - self.imageViewArray.count;
            
            [viewController presentViewController:picker animated:YES completion:^{
                
            }];
            
            return;
        }
    }
    
    __weak __typeof(self) weakSelf = self;
    
    __weak UIViewController  *weakViewController = viewController;
    [weakSelf.imagePickerHelper showImagePickerViewControllerSourceType:type onViewController:weakViewController completionHandler:^(UIImage *image, NSDictionary *info) {
        if (image) {
            NSData *data = UIImageJPEGRepresentation(image, 1);
            if (data) {
                [weakSelf displayImageViewWithData:data];
            }
            else {
//                UIImage *resizedImage = [image resizedImage:weakSelf.addButton.frame.size interpolationQuality:kCGInterpolationHigh];
//                
//                if (resizedImage) {
//                    [weakSelf displayImageViewWithImage:resizedImage];
//                }
            }
        }
    }];
}

- (void)displayImageViewWithData:(NSData *)data
{
    UIImage *image = [[UIImage alloc] initWithData:data];
    [self displayImageViewWithImage:image];
}

- (void)displayImageViewWithImage:(UIImage *)image
{
    
    SSPhotoImageView *imageView = [[SSPhotoImageView alloc] initWithImage:image];
    imageView.delegate = self;
    
    if (self.type == SSPhotoViewTypeKeyboard) {
    
        imageView.frame = CGRectMake(0, -[SSPhotoImageView expandTopBorder], CGRectGetWidth(self.addButton.frame) + [SSPhotoImageView expandRightBorder], CGRectGetHeight(self.addButton.frame) + [SSPhotoImageView expandTopBorder]);

        [self.addButton addSubview:imageView];
        
        [self.imageViewArray addObject:imageView];
        
        self.tipLabel.hidden = YES;
    }
    else if (self.type == SSPhotoViewTypeFaTie) {
        imageView.frame = CGRectMake(CGRectGetMinX(self.addButton.frame), CGRectGetMinY(self.addButton.frame) - [SSPhotoImageView expandTopBorder], CGRectGetWidth(self.addButton.frame) + [SSPhotoImageView expandRightBorder], CGRectGetHeight(self.addButton.frame) + [SSPhotoImageView expandTopBorder]);
        
        [self.imageViewArray addObject:imageView];
        [self addSubview:imageView];
        
        [self updateTipLabelText];
        
        CGFloat animationDuration = (self.type == SSPhotoViewTypeKeyboard ? 0.5f : 0.5f);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self layoutImageView];

        });
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SSPhotoViewDidCaptureImage:)]) {
        [self.delegate SSPhotoViewDidCaptureImage:self];
    }
    
}

- (void)updateTipLabelText
{
    switch (self.imageViewArray.count) {
        case 0:
            self.tipLabel.text = @"点击添加图片";
            break;
        case 1:
            self.tipLabel.text = @"已选1张，还可以添加2张图片";
            break;
        case 2:
            self.tipLabel.text = @"已选2张，还可以添加1张图片";
            break;
        case 3:
            self.tipLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)layoutImageView
{
    CGFloat duration = 0.25f;
    if (self.imageViewArray.count == 3) {
        duration = 0.f;
    }
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    int i = 0;
    for (; i < self.imageViewArray.count; i++) {
        SSPhotoImageView *imageView = self.imageViewArray[i];
        
        imageView.frame = CGRectMake(21 + (CGRectGetWidth(self.addButton.frame) + 25) * i, 65/2.f - [SSPhotoImageView expandTopBorder], CGRectGetWidth(self.addButton.frame) + [SSPhotoImageView expandRightBorder], CGRectGetHeight(self.addButton.frame) + [SSPhotoImageView expandTopBorder]);
    }
    CGFloat originX = 0.f;
    if (self.imageViewArray.count) {
        originX = 21 + (CGRectGetWidth(self.addButton.frame) + 25) * i;
    }
    else {
        originX = 244/2.f;
    }
    
    CGRect frame = self.addButton.frame;
    frame.origin.x = originX;
    self.addButton.frame = frame;
    
    NSLog(@"iamgearray:%@", self.imageViewArray);
    
    [UIView commitAnimations];
}

#pragma mark - SSPhotoImageViewDelegate
- (void)deleteButtonClickInSSPhotoImageView:(SSPhotoImageView *)photoImageView
{
    [self.imageViewArray removeObject:photoImageView];
    [photoImageView removeFromSuperview];
    photoImageView = nil;
    
    self.tipLabel.hidden = NO;
    
    if (self.type == SSPhotoViewTypeFaTie) {
        [self layoutImageView];
        
        [self updateTipLabelText];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SSPhotoViewDeleteButtonClick:)]) {
        [self.delegate SSPhotoViewDeleteButtonClick:self];
    }
}

- (void)clearSelectedPhoto
{
    while (self.imageViewArray.count) {
        UIImageView *imageView = self.imageViewArray[0];
        [self.imageViewArray removeObject:imageView];
        [imageView removeFromSuperview];
        imageView = nil;
    }
    
    [self layoutImageView];
}

- (SSImagePickerHelper *)imagePickerHelper
{
    if (_imagePickerHelper == nil) {
        _imagePickerHelper = [[SSImagePickerHelper alloc] init];
        _imagePickerHelper.allowsEditing = NO;
    }
    return _imagePickerHelper;
}

#pragma mark - UzysAssetsPickerControllerDelegate
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    __weak typeof(self) weakSelf = self;
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            img = [img fixOrientation];
            [weakSelf displayImageViewWithImage:img];
//            *stop = YES;
        }];
        
        
    }
    else //Video
    {
//        ALAsset *alAsset = assets[0];
//        
//        UIImage *img = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
//                                           scale:alAsset.defaultRepresentation.scale
//                                     orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
//        weakSelf.imageView.image = img;
//        
//        
//        
//        ALAssetRepresentation *representation = alAsset.defaultRepresentation;
//        NSURL *movieURL = representation.url;
//        NSURL *uploadURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] stringByAppendingString:@".mp4"]];
//        AVAsset *asset      = [AVURLAsset URLAssetWithURL:movieURL options:nil];
//        AVAssetExportSession *session =
//        [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
//        
//        session.outputFileType  = AVFileTypeQuickTimeMovie;
//        session.outputURL       = uploadURL;
//        
//        [session exportAsynchronouslyWithCompletionHandler:^{
//            
//            if (session.status == AVAssetExportSessionStatusCompleted)
//            {
//                DLog(@"output Video URL %@",uploadURL);
//            }
//            
//        }];
        
    }
}

- (void)UzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"发帖最多选择三张图片哦~" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [av show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
