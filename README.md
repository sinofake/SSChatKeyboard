SSChatKeyboard
==============

聊天键盘


用法示例：
_keyboard = [[SSKeyboard alloc] initWithKeyboardType:SSKeyboardTypeChat shoundResizedView:nil loadPhotoIcon:YES delegate:self];
[_keyboard delegateAddKeyboardControl];
[self.view addSubview:self.keyboard];

//需要在dealloc中加入这个方法：
- (void)dealloc
{
    [_keyboard removeKeyboardControl];
}