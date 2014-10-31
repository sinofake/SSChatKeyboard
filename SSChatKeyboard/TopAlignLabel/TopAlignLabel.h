//
//  TopAlignLabel.h
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-18.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface TopAlignLabel : TTTAttributedLabel

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;
- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font text:(NSString *)text;
- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor text:(NSString *)text;
- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text;
/**
 *  TopAlignLabel:
 *
 *  @param frame     <#frame description#>
 *  @param text      <#text description#>
 *  @param font      default 17.0
 *  @param textColor default blackColor
 *  @param textAlign default NSTextAlignmentCenter
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor align:(NSTextAlignment)textAlign text:(NSString *)text;

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor align:(NSTextAlignment)textAlign verticalAlignment:(TTTAttributedLabelVerticalAlignment)verticalAlignment text:(NSString *)text;


- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor align:(NSTextAlignment)textAlign verticalAlignment:(TTTAttributedLabelVerticalAlignment)verticalAlignment text:(NSString *)text lineSpacing:(CGFloat)lineSpacing;



- (CGSize)ss_sizeToFit;


@end
