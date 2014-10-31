//
//  SSImageUtility.m
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-24.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "SSImageUtility.h"

@implementation SSImageUtility

#pragma mark - button image

+ (NSString *)keyboardImageBundlePath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"keyboardImage.bundle"];
}

+ (UIImage *)imageWithBundleName:(NSString *)name
{
    NSString *path = [[self keyboardImageBundlePath] stringByAppendingPathComponent:name];
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+ (UIImage *)keyboardSendButtonDisableImage
{
    return [self imageWithBundleName:@"keyboard_sendBtn_disable@2x.png"];
}

+ (UIImage *)keyboardSendButtonNormalImage
{
    return [self imageWithBundleName:@"keyboard_sendBtn_normal@2x.png"];
}

+ (UIImage *)keyboardShuRuKuangImage
{
    return [self imageWithBundleName:@"keyboard_shurukuang@2x.png"];
}

+ (UIImage *)keyboardPhotoNormalImage
{
    return [self imageWithBundleName:@"keyboard_photo@2x.png"];
}

+ (UIImage *)keyboardPhotoSelectedImage
{
    return [self imageWithBundleName:@"keyboard_photoHL@2x.png"];
}

+ (UIImage *)keyboardEmojiNormalImage
{
    return [self imageWithBundleName:@"keyboard_emoji@2x.png"];
}

+ (UIImage *)keyboardEmojiSelectedImage
{
    return [self imageWithBundleName:@"keyboard_emojiHL@2x.png"];
}

+ (UIImage *)keyboardIconImage
{
    return [self imageWithBundleName:@"keyboard_icon@2x.png"];
}

+ (UIImage *)keyboardDuiHaoImage
{
    return [self imageWithBundleName:@"keyboard_duihao@2x.png"];
}

+ (UIImage *)faceBoardDeleteButtonDisableImage
{
    return [self imageWithBundleName:@"keyboard_clearDisablebtn@2x.png"];
}

+ (UIImage *)faceBoardDeleteButtonNormalImage
{
    return [self imageWithBundleName:@"keyboard_clearbtnNormal@2x.png"];
}

+ (UIImage *)faceBoardDeleteButtonSelectedImage
{
    return [self imageWithBundleName:@"keyboard_clearbtnHL@2x.png"];
    
}

+ (UIImage *)photoImageViewDeleteImage
{
    return [self imageWithBundleName:@"keyboard_photo_closeBtn@2x.png"];
}

+ (UIImage *)photoImageViewAddImage
{
    return [self imageWithBundleName:@"keyboard_photo_add@2x.png"];
}



@end
