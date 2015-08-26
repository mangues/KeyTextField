//
//  MGViewController.m
//  KeyTextField
//
//  Created by TTS on 15/8/25.
//  Copyright (c) 2015年 TTS. All rights reserved.
//

#import "MGViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN [UIScreen mainScreen].bounds
@interface MGViewController ()<UITextFieldDelegate>

@end

@implementation MGViewController
     UITextField * tempTextField;
     double keyboardHeight = 0;    //键盘高度
     CGFloat heightOffset;
     UIToolbar * topView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setToolbarUI];
    [_text1 setDelegate:self];
    [_text2 setDelegate:self];
    [_text3 setDelegate:self];
    [self addGestureRecognizer];
    [self addKeyNotification];
    //设置contentSize
    //_uiScroolView.contentSize= [[UIScreen mainScreen] bounds].size ;
}

/**
 *  @author mangues, 15-08-26 08:08:48
 *
 *  增加 键盘的监听事件
 */
- (void)addKeyNotification{
    //设置键盘监听,监听 键盘将要出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
   //设置键盘监听,监听 键盘将要隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark 键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[value CGRectValue] fromView:nil];
    if (keyboardHeight == 0) {
        keyboardHeight = keyboardRect.size.height;//键盘高度
       [self setViewOffset];
    }
   
  }

#pragma mark 键盘隐藏事件
- (void)keyboardWillHide:(NSNotification *)notification{
    [self animation:0];
}



/**
 *  @author mangues, 15-08-26 09:08:42
 *
 *  动画效果
 *
 *  @param offset 偏移量
 */
- (void)animation:(CGFloat) offset{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = offset;
        self.view.frame = frame;
    }];
}



/**
 *  @author mangues, 15-08-26 08:08:50
 *
 *  空白处 点击出发事件绑定
 */
- (void)addGestureRecognizer
{
    UITapGestureRecognizer * sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
    sigleTap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:sigleTap];
}

/**
 *  @author mangues, 15-08-26 08:08:41
 *
 *  接触键盘
 */
- (void)handleTapGesture
{
    [tempTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 *  @author mangues, 15-08-26 08:08:00
 *
 *  textField 获取焦点事件
 *
 *  @param textField
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    tempTextField = textField;
    [tempTextField setInputAccessoryView:topView];
    if (keyboardHeight != 0) {
        [self setViewOffset];
    }
}

/**
 *  @author mangues, 15-08-26 09:08:15
 *
 *  设置偏移效果
 */
- (void)setViewOffset{
    NSInteger tag = tempTextField.tag;    //获取当前取得焦点的field tag
    UIView *view;
    if (tag!=3) {
        view =[self.view viewWithTag:tag+1];
        //获取下一个field的中心y坐标
        CGFloat y = view.center.y;
        CGFloat y1 = SCREENHEIGHT - y;
        heightOffset = keyboardHeight - y1;
    }else{
        heightOffset = keyboardHeight - SCREENHEIGHT + tempTextField.frame.origin.y + tempTextField.frame.size.height;
    }
    [self animation:-heightOffset];

}

/**
 *  @author mangues, 15-08-26 13:08:16
 *
 *  添加底部toolbar 的UI
 */
- (void)setToolbarUI{
    //定义一个toolBar
    topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    //设置style
    //[topView setBarStyle:UIBarStyleBlack];
    [topView setBackgroundColor:[UIColor greenColor]];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backKeyboard)];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStyleDone target:self action:@selector(forwardKeyboard)];
    
    UIBarButtonItem * button3 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(doneKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,button3,doneButton,nil];
    [topView setItems:buttonsArray];
 
       
}

- (void)backKeyboard{
    NSLog(@"backKeyboard");
}
- (void)forwardKeyboard{
    NSLog(@"forwardKeyboard");
    
}
- (void)doneKeyboard{
    NSLog(@"doneKeyboard");
}

@end
