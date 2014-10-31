//
//  SSPhotoView.h
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-22.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSPhotoView;

typedef NS_ENUM(NSInteger, SSPhotoViewType) {
    SSPhotoViewTypeKeyboard = 0,
    SSPhotoViewTypeFaTie
};

@protocol SSPhotoViewDelegate <NSObject>

@optional

- (void)SSPhotoViewDeleteButtonClick:(SSPhotoView *)photoView;

- (void)SSPhotoViewDidCaptureImage:(SSPhotoView *)photoView;

@end

@interface SSPhotoView : UIView

@property (nonatomic, readonly) SSPhotoViewType type;
@property (nonatomic, weak) id <SSPhotoViewDelegate> delegate;

@property (nonatomic, readonly) NSMutableArray *imageViewArray;//选择后的图片集

- (instancetype)initWithFrame:(CGRect)frame type:(SSPhotoViewType)type;
- (void)clearSelectedPhoto;//清除选中的图片

@end
