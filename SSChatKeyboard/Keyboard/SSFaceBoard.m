//
//  SSFaceBoard.m
//  MLEmojiLabel
//
//  Created by sskh on 14-8-16.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "SSFaceBoard.h"
#import "SSImageUtility.h"
//#import "NSString+SSTextHandle.h"

//#define kHEIGHT_KEYBOARD 216
#define TAG_FACE_BUTTON_BASE 200

@interface SSFaceBoard ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *emojiNames;
@property (nonatomic, strong) UIScrollView *faceView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *clearButtonArray;

@end

@implementation SSFaceBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _clearButtonArray = [[NSMutableArray alloc] initWithCapacity:4];

        [self setup];
    }
    return self;
}

- (void)setup
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"expressionArray.plist"];
    _emojiNames = [[NSArray alloc] initWithContentsOfFile:path];
    
    _faceView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 20)];
    //self.faceView.backgroundColor = [UIColor greenColor];
    
    self.faceView.pagingEnabled = YES;
    self.faceView.showsHorizontalScrollIndicator = NO;
    self.faceView.showsVerticalScrollIndicator = NO;
    self.faceView.delegate = self;
    
    [self addSubview:self.faceView];
    
    int rate = 0;//因为要插入删除和发送按钮， 这里用条标记
    for (int i = 0; i < 7 * 4 * 4; i++) {
        CGFloat btnWidth = 32;
        CGFloat btnHeight = 32;
        CGFloat xOffset = 12;
        CGFloat yOffset = 15;
        CGFloat xGap = 12;
        CGFloat yGap = 16;
        
        int colum = ((i % 28) % 7);
        int row = ((i % 28) / 7);
        
        if (colum == 6 && row == 3) {
            
            rate++;//
            
            UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *clearImage = [SSImageUtility faceBoardDeleteButtonNormalImage];
            [clearButton setImage:clearImage forState:UIControlStateNormal];
            //[clearButton setImage:[self clearButtonSelectedImage] forState:UIControlStateSelected];
            //[clearButton setImage:[self clearButtonSelectedImage] forState:UIControlStateHighlighted];
            
            //clearButton.backgroundColor = [UIColor greenColor];
            
            clearButton.frame = CGRectMake(xOffset + colum * (btnWidth + xGap) + (i / 28 * 320) - 3, yOffset + row * (btnHeight + yGap), clearImage.size.width + 8, clearImage.size.height + 10);
            clearButton.imageEdgeInsets = UIEdgeInsetsMake(-10, -5, 0, 0);
            
            [clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            clearButton.enabled = NO;
            [self.faceView addSubview:clearButton];
            
            [self.clearButtonArray addObject:clearButton];
            
            
//            UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            UIImage *sendDiablImage = [self sendButtonDisableImage];
//            [sendButton setImage:sendDiablImage forState:UIControlStateNormal];
//            
//            sendButton.frame = CGRectMake(CGRectGetMaxX(clearButton.frame) + 18, CGRectGetMinY(clearButton.frame), sendDiablImage.size.width, sendDiablImage.size.height);
//            
//            [sendButton addTarget:self action:@selector(clearOrSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            
//            sendButton.enabled = NO;
//            [self.faceView addSubview:sendButton];
            
//            [self.sendButtonArray addObject:sendButton];
            
            
            //i += 2;
            continue;
        }
        
        int buttonIndex = i - rate * 1;
        if (buttonIndex < 100) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = TAG_FACE_BUTTON_BASE + buttonIndex;
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Expression_%d@2x", buttonIndex + 1] ofType:@"png"];
            UIImage *face = [[UIImage alloc] initWithContentsOfFile:path];
            
            [button setBackgroundImage:face forState:UIControlStateNormal];
            [button setBackgroundImage:face forState:UIControlStateSelected];
            [button setBackgroundImage:face forState:UIControlStateHighlighted];
            
            //button.backgroundColor = [UIColor blueColor];
            
            button.frame = CGRectMake(xOffset + colum * (btnWidth + xGap) + (i / 28 * 320) , yOffset + row * (btnHeight + yGap), btnWidth, btnHeight);
            
            
            [button addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.faceView addSubview:button];
        }
    }
    
    self.faceView.contentSize = CGSizeMake(320 * 4, CGRectGetHeight(self.faceView.frame));
    
    //添加PageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.faceView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(self.faceView.frame))];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:UIColorFromHex(0xff5f54)];
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor lightGrayColor]];
    
    [_pageControl addTarget:self action:@selector(pageControlChange:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_pageControl];
}

- (void)pageControlChange:(UIPageControl *)sender
{
    [self.faceView setContentOffset:CGPointMake(sender.currentPage * 320, 0)animated:YES];
}

#pragma mark - 删除按钮点击

- (void)clearButtonClick:(UIButton *)sender
{
    [self deleteOneEmojiOrCharacter];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ss_faceBoard:deleteButtonClick:)]) {
        [self.delegate ss_faceBoard:self deleteButtonClick:sender];
    }
}

//- (void)clearOrSendButtonClick:(UIButton *)sender
//{
//
//    if ([self.sendButtonArray containsObject:sender]) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(SSFaceBoard:sendButtonClick:)]) {
//            [self.delegate SSFaceBoard:self sendButtonClick:sender];
//        }
//    }
//    else if ([self.clearButtonArray containsObject:sender]) {
//        [self deleteOneEmojiOrCharacter];
//    }
//}

- (void)deleteOneEmojiOrCharacter
{
    if (self.inputTextView) {
        NSString *inputString = self.inputTextView.text;
        
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        if (stringLength > 0) {
            if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
                if ([inputString rangeOfString:@"["].location == NSNotFound){
                    string = [inputString substringToIndex:stringLength - 1];
                } else {
                    string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
                }
            } else {
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        self.inputTextView.text = string;
        
        if ([self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            [self changeClearButtonStatusToDisable];
        }
        else {
            [self changeClearButtonStatusToNormal];
        }
    }
}

#pragma mark - 停止滚动的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.pageControl setCurrentPage:scrollView.contentOffset.x / 320];
}

#pragma mark - 表情点击
- (void)faceButtonClick:(UIButton *)sender
{
    //NSLog(@"tag:%d", sender.tag);
    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc] initWithString:self.inputTextView.text];
        [faceString appendString:self.emojiNames[sender.tag - TAG_FACE_BUTTON_BASE]];
        self.inputTextView.text = faceString;
        
        if ([self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
            [self changeClearButtonStatusToNormal];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ss_faceBoard:emojiButtonClick:)]) {
        [self.delegate ss_faceBoard:self emojiButtonClick:sender];
    }
}

#pragma mark - 改变删除按钮的状态
- (void)changeClearButtonStatusToDisable
{
    for (UIButton *button in self.clearButtonArray) {
        [button setImage:[SSImageUtility faceBoardDeleteButtonDisableImage] forState:UIControlStateNormal];
        button.enabled = NO;
    }
}
- (void)changeClearButtonStatusToNormal
{
    for (UIButton *button in self.clearButtonArray) {
        [button setImage:[SSImageUtility faceBoardDeleteButtonNormalImage] forState:UIControlStateNormal];
        [button setImage:[SSImageUtility faceBoardDeleteButtonSelectedImage] forState:UIControlStateSelected];
        [button setImage:[SSImageUtility faceBoardDeleteButtonSelectedImage] forState:UIControlStateHighlighted];
        button.enabled = YES;
    }
}
//- (void)changeSendButtonStatusToDisable
//{
//    for (UIButton *button in self.sendButtonArray) {
//        [button setImage:[self sendButtonDisableImage] forState:UIControlStateNormal];
//        button.enabled = NO;
//    }
//}
//
//- (void)changeSendButtonStatusToNormal
//{
//    for (UIButton *button in self.sendButtonArray) {
//        [button setImage:[self sendButtonNormalImage] forState:UIControlStateNormal];
//        //[button setImage:<#(UIImage *)#> forState:UIControlStateSelected];
//        button.enabled = YES;
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
