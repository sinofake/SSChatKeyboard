//
//  TopAlignLabel.m
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-18.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "TopAlignLabel.h"

static CGSize originSize;

@implementation TopAlignLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    return [self initWithFrame:frame font:17.f textColor:[UIColor blackColor] align:NSTextAlignmentCenter text:text];
}
- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font text:(NSString *)text
{
    return [self initWithFrame:frame font:font textColor:[UIColor blackColor] align:NSTextAlignmentCenter text:text];
}
- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor text:(NSString *)text
{
    return [self initWithFrame:frame font:17.f textColor:textColor align:NSTextAlignmentCenter text:text];

}
- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text
{
    return [self initWithFrame:frame font:font textColor:textColor align:NSTextAlignmentCenter text:text];

}

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor align:(NSTextAlignment)textAlign text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        originSize = frame.size;
        self.font = [UIFont systemFontOfSize:font];
        self.textColor = textColor;
        self.textAlignment = textAlign;
        self.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        [self setText:text];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor align:(NSTextAlignment)textAlign verticalAlignment:(TTTAttributedLabelVerticalAlignment)verticalAlignment text:(NSString *)text
{
    return [self initWithFrame:frame font:font textColor:textColor align:textAlign verticalAlignment:verticalAlignment text:text lineSpacing:0.0f];
}

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor align:(NSTextAlignment)textAlign verticalAlignment:(TTTAttributedLabelVerticalAlignment)verticalAlignment text:(NSString *)text lineSpacing:(CGFloat)lineSpacing
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0;
        originSize = frame.size;
        self.font = [UIFont systemFontOfSize:font];
        self.textColor = textColor;
        self.textAlignment = textAlign;
        self.verticalAlignment = verticalAlignment;
        self.lineSpacing = lineSpacing;
        
        [self setText:text];
    }
    return self;
}

- (CGSize)ss_sizeToFit
{
    CGSize size = [self sizeThatFits:originSize];
    
    CGRect frame = self.frame;
    frame.size.height = size.height;
//    frame.size.width = size.width;
    self.frame = frame;
    
    return size;
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
