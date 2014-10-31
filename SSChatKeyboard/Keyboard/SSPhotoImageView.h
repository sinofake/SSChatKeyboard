//
//  SSPhotoImageView.h
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-23.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSPhotoImageView;

@protocol SSPhotoImageViewDelegate <NSObject>

- (void)deleteButtonClickInSSPhotoImageView:(SSPhotoImageView *)photoImageView;

@end

@interface SSPhotoImageView : UIView
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(UIImage *)anImage;

/**
 都是因为下面这个属性可以让图片充满_contentImageView的大小，
 _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
 但必须设置[_contentImageView setClipsToBounds:YES];不然图片就全漏出来了，
 但这样一来删除按钮就不能超出_contentImageView的边界了，
 所以重新写一个类SSPhotoImageView : UIView

 */
+ (CGFloat)expandTopBorder;//扩展的上边界，就是删除按钮的高度的一半
+ (CGFloat)expandRightBorder;//扩展的右边界，就是删除按钮的宽度的一半


@property (nonatomic, weak) id <SSPhotoImageViewDelegate> delegate;

@end
