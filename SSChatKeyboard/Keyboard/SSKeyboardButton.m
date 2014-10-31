//
//  SSKeyboardButton.m
//  DAKeyboardControlExample
//
//  Created by sskh on 14-8-21.
//  Copyright (c) 2014年 Shout Messenger. All rights reserved.
//

#import "SSKeyboardButton.h"
#import "SSImageUtility.h"

@implementation SSKeyboardButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIsKeyboardStatus:(BOOL)isKeyboardStatus
{
    _isKeyboardStatus = isKeyboardStatus;
    
    if (isKeyboardStatus) {
        [self setImage:[SSImageUtility keyboardIconImage] forState:UIControlStateNormal];
        [self setImage:[SSImageUtility keyboardIconImage] forState:UIControlStateSelected];
        [self setImage:[SSImageUtility keyboardIconImage] forState:UIControlStateHighlighted];
    }
    else {
        if (self.ssType == SSKeyboardButtonTypePhoto) {
            [self setImage:[SSImageUtility keyboardPhotoNormalImage] forState:UIControlStateNormal];
            [self setImage:[SSImageUtility keyboardPhotoSelectedImage] forState:UIControlStateSelected];
            [self setImage:[SSImageUtility keyboardPhotoSelectedImage] forState:UIControlStateHighlighted];
        }
        else if (self.ssType == SSKeyboardButtonTypeEmoji) {
            [self setImage:[SSImageUtility keyboardEmojiNormalImage] forState:UIControlStateNormal];
            [self setImage:[SSImageUtility keyboardEmojiSelectedImage] forState:UIControlStateSelected];
            [self setImage:[SSImageUtility keyboardEmojiSelectedImage] forState:UIControlStateHighlighted];
        }
    }
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
