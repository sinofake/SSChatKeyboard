//
//  SSPhotoImageView.m
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-23.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "SSPhotoImageView.h"
#import "SSImageUtility.h"

#define DELETE_BUTTON_EXPAND 15 //删除按钮的扩展，即width和height都加上  DELETE_BUTTON_EXPAND *　2

@interface SSPhotoImageView ()
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation SSPhotoImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];

    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)anImage
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.image = anImage;
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    
//    self.backgroundColor = [UIColor greenColor];
    
    [self addSubview:self.contentImageView];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *deleteImg = [SSImageUtility photoImageViewDeleteImage];
    [_deleteButton setImage:deleteImg forState:UIControlStateNormal];
    
    _deleteButton.frame = CGRectMake(0, 0, deleteImg.size.width + DELETE_BUTTON_EXPAND * 2, deleteImg.size.height + DELETE_BUTTON_EXPAND * 2);
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    [self addSubview:_deleteButton];
    //_deleteButton.backgroundColor = [UIColor redColor];
}

- (void)deleteButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonClickInSSPhotoImageView:)]) {
        [self.delegate deleteButtonClickInSSPhotoImageView:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect frame = self.deleteButton.frame;
//    frame.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(frame)/2.f - 5;
//    frame.origin.y = - CGRectGetHeight(frame)/2.f + 5;
    frame.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(frame) + DELETE_BUTTON_EXPAND;
    frame.origin.y = -DELETE_BUTTON_EXPAND;
    self.deleteButton.frame = frame;
    
    self.contentImageView.frame = CGRectMake(0, [SSPhotoImageView expandTopBorder], CGRectGetWidth(self.frame) - [SSPhotoImageView expandRightBorder], CGRectGetHeight(self.frame) - [SSPhotoImageView expandTopBorder]);
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = image;
        
        self.contentImageView.image = _image;
    }
}

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        //_contentImageView.userInteractionEnabled = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_contentImageView setClipsToBounds:YES];
    }
    return _contentImageView;
}


+ (CGFloat)expandTopBorder
{
    UIImage *deleteImg = [SSImageUtility photoImageViewDeleteImage];
    return deleteImg.size.height/2.f;
}

+ (CGFloat)expandRightBorder
{
    UIImage *deleteImg = [SSImageUtility photoImageViewDeleteImage];
    return deleteImg.size.width/2.f;
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
