//
//  ViewController.m
//  SSChatKeyboard
//
//  Created by sskh on 14/10/31.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "ViewController.h"
#import "Keyboard/SSKeyboard.h"
#import "MLEmojiLabel.h"

@interface ViewController ()<SSKeyboardDelegage>
@property (nonatomic, strong) SSKeyboard *keyboard;
@property (nonatomic, strong) MLEmojiLabel *label;

@end

@implementation ViewController

- (void)dealloc
{
    [_keyboard removeKeyboardControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _label = [[MLEmojiLabel alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 200)];
    _label.numberOfLines = 0;
    _label.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _label.customEmojiPlistName = @"expressionDict.plist";
    _label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_label];
    
    _keyboard = [[SSKeyboard alloc] initWithKeyboardType:SSKeyboardTypeChat shoundResizedView:nil loadPhotoIcon:YES delegate:self];
    [_keyboard delegateAddKeyboardControl];
    [self.view addSubview:self.keyboard];
    
    
}

#pragma mark - SSKeyboardDelegage
- (void)ss_sendButtonClickInKeyboard:(SSKeyboard *)keyboard {
    self.label.emojiText = keyboard.textView.text;
    [keyboard clearup];
    [keyboard dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
