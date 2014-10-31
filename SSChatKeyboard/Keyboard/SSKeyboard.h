//
//  SSKeyboard.h
//  DAKeyboardControlExample
//
//  Created by sskh on 14-8-15.
//  Copyright (c) 2014年 Shout Messenger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAKeyboardControl.h"
#import "HPGrowingTextView.h"
#import "SSPhotoView.h"

@class SSKeyboard;

typedef NS_ENUM(NSInteger, SSKeyboardType){
    SSKeyboardTypeChat = 0,
    SSKeyboardTypeTimeline
};

@protocol SSKeyboardDelegage <NSObject>

@optional
- (void)ss_sendButtonClickInKeyboard:(SSKeyboard *)keyboard;


@end


@interface SSKeyboard : UIView

@property (nonatomic, readonly) HPGrowingTextView *textView;
@property (nonatomic, readonly) SSPhotoView *photoView;


- (instancetype)initWithKeyboardType:(SSKeyboardType)type shoundResizedView:(UIView *)resizedView loadPhotoIcon:(BOOL)loadPhotoIcon delegate:(UIViewController <SSKeyboardDelegage> *) delegate;
@property (nonatomic, readonly) BOOL keybaordType;
@property (nonatomic, readonly) BOOL loadPhotoIcon;


- (void)show;
- (void)dismiss;
- (void)clearup;//清空数据

- (BOOL)isShowKeyboard;

//[(UIViewController <SSKeyboardDelegage> *) delegate.view removeKeyboardControl]，这两个方法配套使用
- (void)delegateAddKeyboardControl;


@end
