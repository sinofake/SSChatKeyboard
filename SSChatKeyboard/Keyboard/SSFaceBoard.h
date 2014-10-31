//
//  SSFaceBoard.h
//  MLEmojiLabel
//
//  Created by sskh on 14-8-16.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSFaceBoard;

@protocol SSFaceBoardDelegate <NSObject>

@optional

- (void)ss_faceBoard:(SSFaceBoard *)faceBoard deleteButtonClick:(UIButton *)sendButton;
- (void)ss_faceBoard:(SSFaceBoard *)faceBoard emojiButtonClick:(UIButton *)sendButton;


@end

@interface SSFaceBoard : UIView

@property (nonatomic, weak) id <SSFaceBoardDelegate> delegate;

@property (nonatomic, weak) UITextView *inputTextView;

//- (void)changeSendButtonStatusToDisable;
//- (void)changeSendButtonStatusToNormal;

- (void)changeClearButtonStatusToDisable;
- (void)changeClearButtonStatusToNormal;


//删除一个表情或字符
- (void)deleteOneEmojiOrCharacter;

@end
