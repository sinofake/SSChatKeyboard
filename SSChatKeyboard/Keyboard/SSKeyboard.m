//
//  SSKeyboard.m
//  DAKeyboardControlExample
//
//  Created by sskh on 14-8-15.
//  Copyright (c) 2014年 Shout Messenger. All rights reserved.
//

#import "SSKeyboard.h"
#import "SSKeyboardButton.h"
#import "SSFaceBoard.h"
#import "SSImageUtility.h"

#define kHEIGHT_KEYBOARD 216
#define kHEIGHT_INPUT_BAR 44 //输入框的高度

#define PADDING_TEXT 2
#define PADDING_SCROLL_INDICATOR 8

//static CGFloat viewControllerHeight;

@interface SSKeyboard ()<HPGrowingTextViewDelegate, SSPhotoViewDelegate>
@property (nonatomic, weak) UIViewController <SSKeyboardDelegage> *delegate;
@property (nonatomic, weak) UIView *resizedView;//将会随着键盘的升降而改变大小的视图

@property (nonatomic, strong) UIView *inputBar;
@property (nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, strong) SSKeyboardButton *photoButton;
@property (nonatomic, strong) SSKeyboardButton *emojiButton;

@property (nonatomic, strong) SSFaceBoard *faceBoard;
@property (nonatomic, strong) SSPhotoView *photoView;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign, getter = isButtonClicked) BOOL buttonClicked;//用于收键盘时展示表情或其它视图


@property (nonatomic, strong) UIImageView *duiHaoView;

@property (nonatomic, assign) BOOL keybaordType;
@property (nonatomic, assign) BOOL shouldHideKeyboard;//用于timeline模式下隐藏输入框

@property (nonatomic, assign) BOOL loadPhotoIcon;


@end

@implementation SSKeyboard



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createInputBar
{
    _inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kHEIGHT_INPUT_BAR)];
    _inputBar.backgroundColor = UIColorFromHex(0xf4f0ef);
    self.inputBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.inputBar];

    
    UIImage *sendBtnDisableImage = [SSImageUtility keyboardSendButtonDisableImage];
    
    CGFloat delta = 0.f;
    if (!self.loadPhotoIcon) {
        delta = 30.f;
    }
    
    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - (sendBtnDisableImage.size.width + (8 + 13 + 388)/2.f + delta), 13/2.f, 388/2.f + delta, kHEIGHT_INPUT_BAR - 13)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, PADDING_TEXT, 0, PADDING_TEXT);
    self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 3;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
	self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.textColor = UIColorFromHex(0x5d5655);
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(PADDING_SCROLL_INDICATOR, 0, PADDING_SCROLL_INDICATOR, -2);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.placeholderColor = UIColorFromHex(0xbfb6b3);
    self.textView.placeholder = @"我也说一句...";
    
    
    
    UIImage *shuRuKuang = [[SSImageUtility keyboardShuRuKuangImage] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 8, 12, 8)];
    UIImageView *shuRuKuangView = [[UIImageView alloc] initWithImage:shuRuKuang];
    shuRuKuangView.frame = CGRectMake(CGRectGetMinX(self.textView.frame) - 5, 0, CGRectGetWidth(self.textView.frame) + 10, kHEIGHT_INPUT_BAR);
    shuRuKuangView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.inputBar addSubview:self.textView];
    [self.inputBar addSubview:shuRuKuangView];
    
    
    UIView *miaoBian = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5f)];
    miaoBian.backgroundColor = UIColorFromHex(0xc5c0c0);
    miaoBian.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.inputBar addSubview:miaoBian];
    
    
    
    if (self.loadPhotoIcon) {
        UIImage *photoNormalImg = [SSImageUtility keyboardPhotoNormalImage];
        _photoButton = [SSKeyboardButton buttonWithType:UIButtonTypeCustom];
        _photoButton.ssType = SSKeyboardButtonTypePhoto;
        _photoButton.isKeyboardStatus = NO;
        
        _photoButton.frame = CGRectMake(15/2.f - 3, 25/2.f - 3, photoNormalImg.size.width + 6, photoNormalImg.size.height + 6);
        _photoButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [_photoButton addTarget:self action:@selector(inputBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.inputBar addSubview:self.photoButton];
        
        delta = CGRectGetMaxX(self.photoButton.frame) + 4;
    }
    else {
        delta = 15/2.f - 3;
    }
    
    
    UIImage *emojiNormalImg = [SSImageUtility keyboardEmojiNormalImage];
    _emojiButton = [SSKeyboardButton buttonWithType:UIButtonTypeCustom];
    _emojiButton.ssType = SSKeyboardButtonTypeEmoji;
    _emojiButton.isKeyboardStatus = NO;
    
    _emojiButton.frame = CGRectMake(delta, 21/2.f - 3, emojiNormalImg.size.width + 6, emojiNormalImg.size.height + 6);
    _emojiButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [_emojiButton addTarget:self action:@selector(inputBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputBar addSubview:self.emojiButton];
    
    
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setImage:sendBtnDisableImage forState:UIControlStateNormal];
    _sendButton.enabled = NO;
    
    _sendButton.frame = CGRectMake(CGRectGetWidth(self.frame) - (4 + sendBtnDisableImage.size.width), 13/2.f, sendBtnDisableImage.size.width, sendBtnDisableImage.size.height);
    _sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [_sendButton addTarget:self action:@selector(inputBarSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.sendButton];
}

#pragma mark - 图片或表情按钮点击

- (void)showPhotoOrEmojiViewWithView:(UIView *)view
{
    [self bringSubviewToFront:view];
    CGRect frame = view.frame;
    frame.origin.y = CGRectGetHeight(self.inputBar.frame);
    view.frame = frame;
    
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    frame = self.frame;
    frame.origin.y = CGRectGetHeight(self.delegate.view.frame) - (CGRectGetHeight(self.inputBar.frame) + kHEIGHT_KEYBOARD);
    self.frame = frame;
    
    [self changeResizedViewHeight];
    
    [UIView commitAnimations];
}

- (void)inputBarButtonClick:(SSKeyboardButton *)sender
{
    
    if (![self isShowKeyboard]) {
        NSLog(@"no contains");
        
        if (sender == self.photoButton) {
            self.photoButton.isKeyboardStatus = YES;
            [self showPhotoOrEmojiViewWithView:self.photoView];
        }
        else if (sender == self.emojiButton) {
            self.emojiButton.isKeyboardStatus = YES;
            [self showPhotoOrEmojiViewWithView:self.faceBoard];
        }
        
        return;
    }

    
    
    if (!sender.isKeyboardStatus) {
        
        if (sender == self.photoButton) {
            
            self.duiHaoView.hidden = YES;

            if (![self.textView isFirstResponder]) {
                
                //此时是在photoView和faceBoard之间切换
                CGRect frame = self.photoView.frame;
                frame.origin.y = CGRectGetMaxY(self.inputBar.frame);
                self.photoView.frame = frame;
                
                [self bringSubviewToFront:self.photoView];
                
                //[self checkCanShowDuiHao];
            }
            
            
            if (self.emojiButton.isKeyboardStatus) {
                self.emojiButton.isKeyboardStatus = NO;
            }
        }
        
        if (sender == self.emojiButton) {
            
            if (![self.textView isFirstResponder]) {
                
                //此时是在photoView和faceBoard之间切换
                CGRect frame = self.faceBoard.frame;
                frame.origin.y = CGRectGetMaxY(self.inputBar.frame);
                self.faceBoard.frame = frame;
                
                [self bringSubviewToFront:self.faceBoard];
                
                [self checkCanShowDuiHao];
            }
            
            
            if (self.photoButton.isKeyboardStatus) {
                self.photoButton.isKeyboardStatus = NO;
            }
        }
        
        sender.isKeyboardStatus = YES;
        self.buttonClicked = YES;
        [self.textView resignFirstResponder];
    }
    else {
        sender.isKeyboardStatus = NO;
        self.buttonClicked = NO;
        [self.textView becomeFirstResponder];
    }
}

- (void)createFaceBoard
{
    _faceBoard = [[SSFaceBoard alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth([[UIScreen mainScreen] bounds]), kHEIGHT_KEYBOARD)];
    _faceBoard.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _faceBoard.backgroundColor = self.inputBar.backgroundColor;
    _faceBoard.inputTextView = (UITextView *)self.textView;
    //_faceBoard.delegate = self;
    [self addSubview:_faceBoard];
}

- (void)createPhotoView
{
    _photoView = [[SSPhotoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth([[UIScreen mainScreen] bounds]), kHEIGHT_KEYBOARD)type:SSPhotoViewTypeKeyboard];
    _photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _photoView.backgroundColor = self.inputBar.backgroundColor;
    _photoView.delegate = self;
    [self addSubview:_photoView];
}

- (void)delegateAddKeyboardControl
{
    __weak __typeof(self)weakSelf = self;
    
    self.delegate.view.keyboardTriggerOffset = kHEIGHT_INPUT_BAR;
    
    [self.delegate.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        CGFloat originY = 0.f;
        
        //NSLog(@"keyboardFrameInView:%@", NSStringFromCGRect(keyboardFrameInView));
        
        if (weakSelf.isButtonClicked) {
            
            //NSLog(@"inputbarframe:%@", NSStringFromCGRect(weakSelf.inputBar.frame));
            //NSLog(@"keyboardFrameInView:%@", NSStringFromCGRect(keyboardFrameInView))
            
            originY = CGRectGetHeight(weakSelf.delegate.view.frame) - (kHEIGHT_KEYBOARD + CGRectGetHeight(weakSelf.inputBar.frame));
            
            //根据按钮的isKeyboardStatus来显示相应的视图
            if (weakSelf.photoButton.isKeyboardStatus) {
                CGRect frame = weakSelf.photoView.frame;
                frame.origin.y = CGRectGetHeight(weakSelf.inputBar.frame);
                weakSelf.photoView.frame = frame;
            }
            if (weakSelf.emojiButton.isKeyboardStatus) {
                CGRect frame = weakSelf.faceBoard.frame;
                frame.origin.y = CGRectGetHeight(weakSelf.inputBar.frame);
                weakSelf.faceBoard.frame = frame;
            }
        }
        else {
            //BOOL opening, BOOL closing, 这两个属性貌似不怎么好使，
            
            //keyboardWillRecede， 这个属性在键盘弹出的时候是yes， 在收键盘是时候是no, 但如果用手势拖动的时候向上是no, 向下是yes
            
            //            NSLog(@"opening:%@", opening ? @"yes" : @"no");
            //            NSLog(@"closing:%@", closing ? @"yes" : @"no");
            //            NSLog(@"keyboardOpened:%@", [self.delegate.view isKeyboardOpened] ? @"yes" : @"no");
            //            NSLog(@"keyboardWillRecede:%@", [self.delegate.view keyboardWillRecede] ? @"yes" : @"no");
            //弹出键盘
            //            opening:no
            //            closing:no
            //            keyboardOpened:no
            //            keyboardWillRecede:yes
            //
            //            opening:yes
            //            closing:no
            //            keyboardOpened:yes
            //            keyboardWillRecede:yes
            
            //收键盘
            //            opening:no
            //            closing:no
            //            keyboardOpened:yes
            //            keyboardWillRecede:no
            //
            //            opening:no
            //            closing:yes
            //            keyboardOpened:yes
            //            keyboardWillRecede:no
            //
            //
            //            opening:no
            //            closing:no
            //            keyboardOpened:yes
            //            keyboardWillRecede:no
            //
            //            opening:no
            //            closing:no
            //            keyboardOpened:yes
            //            keyboardWillRecede:no
            
            if ([self.delegate.view keyboardWillRecede]) {
                originY = CGRectGetMinY(keyboardFrameInView) - CGRectGetHeight(weakSelf.inputBar.frame);
            }
            else {
                if (weakSelf.keybaordType == SSKeyboardTypeTimeline && self.shouldHideKeyboard) {
                    
                    originY = CGRectGetMinY(keyboardFrameInView);
                }
                else {
                    originY = CGRectGetMinY(keyboardFrameInView) - CGRectGetHeight(weakSelf.inputBar.frame);
                }
            }
        }
        
        CGRect selfFrame = weakSelf.frame;
        selfFrame.origin.y = originY;
        weakSelf.frame = selfFrame;
        
        [weakSelf changeResizedViewHeight];
    }];
}

- (instancetype)initWithKeyboardType:(SSKeyboardType)type shoundResizedView:(UIView *)resizedView loadPhotoIcon:(BOOL)loadPhotoIcon delegate:(UIViewController <SSKeyboardDelegage> *) delegate

{
    CGRect frame = CGRectZero;
    switch (type) {
        case SSKeyboardTypeChat:
        {
            frame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]) - kHEIGHT_INPUT_BAR, CGRectGetWidth([[UIScreen mainScreen] bounds]), kHEIGHT_KEYBOARD + kHEIGHT_INPUT_BAR);
        }
            break;
        case SSKeyboardTypeTimeline:
        {
            frame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]), CGRectGetWidth([[UIScreen mainScreen] bounds]), kHEIGHT_KEYBOARD + kHEIGHT_INPUT_BAR);
        }
            break;
            
        default:
            break;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.keybaordType  = type;
        self.loadPhotoIcon = loadPhotoIcon;
        self.delegate = delegate;
        
        if (resizedView) {
            self.resizedView = resizedView;
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [self createInputBar];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView uzys_stopRefreshAnimation];
            [self createFaceBoard];
            
            [self createPhotoView];
        });
    }
    return self;
}


//#pragma mark - SSFaceBoardDelegate
//- (void)SSFaceBoard:(SSFaceBoard *)faceBoard sendButtonClick:(UIButton *)sendButton
//{
//    NSLog(@"%s", __FUNCTION__);
//    if (self.delegate && [self.delegate respondsToSelector:@selector(ss_sendButtonClickInKeyboard:)]) {
//        [self.delegate ss_sendButtonClickInKeyboard:self];
//    }
//    else {
//        [self resignFirstResponder];
//    }
//}

#pragma mark - 输入框上的“发送”按钮点击
- (void)inputBarSendButtonClick:(UIButton *)sender
{
    [self handleSimilarSendEvent];
}

#pragma mark  - 处理发送事件，将消息传送给代理 
- (void)handleSimilarSendEvent
{
    NSLog(@"%s", __FUNCTION__);
    if (self.delegate && [self.delegate respondsToSelector:@selector(ss_sendButtonClickInKeyboard:)]) {
        [self.delegate ss_sendButtonClickInKeyboard:self];
    }
    else {
        [self resignFirstResponder];
    }
}

#pragma mark - SSPhotoViewDelegate
- (void)SSPhotoViewDeleteButtonClick:(SSPhotoView *)photoView
{
    //[self checkCanShowDuiHao];
    [self autoChangeSendButtonAndFaceboardClearButtonStatus];
}

- (void)SSPhotoViewDidCaptureImage:(SSPhotoView *)photoView
{
    [self autoChangeSendButtonAndFaceboardClearButtonStatus];
}


#pragma mark - HPGrowingTextViewDelegate

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    self.buttonClicked = NO;
    self.shouldHideKeyboard = NO;
    
    self.photoButton.isKeyboardStatus = NO;
    self.emojiButton.isKeyboardStatus = NO;
    
    return YES;
}
//- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;
//
- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    CGRect frame = self.faceBoard.frame;
    frame.origin.y = CGRectGetMaxY(self.frame);
    self.faceBoard.frame = frame;
    
    frame = self.photoView.frame;
    frame.origin.y = CGRectGetMaxY(self.frame);
    self.photoView.frame = frame;
    
    //显示对号
    [self checkCanShowDuiHao];
}
//- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;
//
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"键盘发送点击");
        [self handleSimilarSendEvent];
        return NO;
    }
    
    //键盘删除点击
    if (range.length == 1) {
        [self.faceBoard deleteOneEmojiOrCharacter];
        return NO;
    }
    
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    [self autoChangeSendButtonAndFaceboardClearButtonStatus];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect frame = self.frame;
    frame.size.height -= diff;
    frame.origin.y += diff;
	self.frame = frame;
    
    [self changeResizedViewHeight];
}
//- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height;
//
//- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView;

#pragma mark - 弹出或隐藏键盘

- (void)show {
    if ([self isShowKeyboard]) {
        return;
    }
    
    self.buttonClicked = NO;
    [self.textView becomeFirstResponder];
}

- (void)dismiss
{
    if (![self isShowKeyboard]) {
        return;
    }
    
    self.buttonClicked = NO;
    
    if ([self.textView isFirstResponder]) {
        self.shouldHideKeyboard = YES;
        
        [self.textView resignFirstResponder];
    }
    else {
        
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        CGRect frame = self.frame;
        CGFloat originY = 0.f;
        
        if (self.keybaordType == SSKeyboardTypeChat) {
            originY = CGRectGetHeight(self.delegate.view.frame) - CGRectGetHeight(self.inputBar.frame);
        }
        else if (self.keybaordType == SSKeyboardTypeTimeline) {
            originY = CGRectGetHeight(self.delegate.view.frame);
        }
        
        frame.origin.y = originY;
        self.frame = frame;
        
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDidStopSelector:@selector(changeKeyboardToolbarButtonStatus)];
        
        [self changeResizedViewHeight];
        
        [UIView commitAnimations];
    }
}

- (void)clearup;//清空数据
{
    self.textView.text = nil;
    [self.photoView clearSelectedPhoto];
    [self checkCanShowDuiHao];
    [self autoChangeSendButtonAndFaceboardClearButtonStatus];
}

- (void)changeKeyboardToolbarButtonStatus
{
    self.photoButton.isKeyboardStatus = NO;
    self.emojiButton.isKeyboardStatus = NO;
}


- (BOOL)isShowKeyboard
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (CGRectContainsPoint(keyWindow.frame, self.center)) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark - 改变resizedView的高度
- (void)changeResizedViewHeight
{
    if (self.resizedView) {
        CGRect frame = self.resizedView.frame;
        frame.size.height = CGRectGetMinY(self.frame);
        self.resizedView.frame = frame;

        if ([self.resizedView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *resizedView = (UIScrollView *)self.resizedView;
            resizedView.contentOffset = CGPointMake(resizedView.contentOffset.x, MAX(resizedView.contentSize.height - CGRectGetHeight(resizedView.frame), 0));
        }
    }
}

#pragma mark - 改变发送按钮及表情键入上删除按钮的状态

- (void)autoChangeSendButtonAndFaceboardClearButtonStatus
{
    NSString *textViewString = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.photoView.imageViewArray.count || textViewString.length) {
        [self changeSendButtonToNormalStatus];
    }
    else {
        [self changeSendButtonToDisableStatus];
    }
    
    
    if ([textViewString length] == 0) {
        //[self.faceBoard changeSendButtonStatusToDisable];
        [self.faceBoard changeClearButtonStatusToDisable];
    }
    else {
        //[self.faceBoard changeSendButtonStatusToNormal];
        [self.faceBoard changeClearButtonStatusToNormal];
    }
}

- (void)changeSendButtonToDisableStatus
{
    [self.sendButton setImage:[SSImageUtility keyboardSendButtonDisableImage] forState:UIControlStateNormal];
    self.sendButton.enabled = NO;
}

- (void)changeSendButtonToNormalStatus
{
    [self.sendButton setImage:[SSImageUtility keyboardSendButtonNormalImage] forState:UIControlStateNormal];
    self.sendButton.enabled = YES;
}

#pragma mark - 对号

- (void)checkCanShowDuiHao
{
    if (self.photoView.imageViewArray.count > 0) {
        self.duiHaoView.hidden = NO;
    }
    else {
        self.duiHaoView.hidden = YES;
    }
}

- (UIImageView *)duiHaoView
{
    if (_duiHaoView == nil) {
        UIImage *image = [SSImageUtility keyboardDuiHaoImage];
        _duiHaoView = [[UIImageView alloc] initWithImage:image];
        _duiHaoView.frame = CGRectMake(45/2.f, 3, image.size.width, image.size.height);
        _duiHaoView.userInteractionEnabled = YES;
        [self.inputBar addSubview:_duiHaoView];
    }
    return _duiHaoView;
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
