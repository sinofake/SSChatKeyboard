//
//  SSKeyboardButton.h
//  DAKeyboardControlExample
//
//  Created by sskh on 14-8-21.
//  Copyright (c) 2014年 Shout Messenger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SSKeyboardButtonType) {
    SSKeyboardButtonTypePhoto = 0,
    SSKeyboardButtonTypeEmoji
};

@interface SSKeyboardButton : UIButton
@property (nonatomic, assign) SSKeyboardButtonType ssType;//这个属性只应在初始化的时候设置一次， 这个属性要在下面属性之前设置
@property (nonatomic, assign) BOOL isKeyboardStatus;//是否显示的是键盘图标

@end
