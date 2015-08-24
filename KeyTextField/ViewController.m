//
//  ViewController.m
//  KeyTextField
//
//  Created by TTS on 15/8/24.
//  Copyright (c) 2015年 TTS. All rights reserved.
//

#import "ViewController.h"
#define REGISTERTABLE_CELL_HEGHIT 200
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *text1;
@property (weak, nonatomic) IBOutlet UITextField *text2;
@property (weak, nonatomic) IBOutlet UITextField *text3;
@property (weak, nonatomic) IBOutlet UIView *buttonVIew;

@property (assign,nonatomic) CGFloat heightOffset;
@property (assign,nonatomic) CGFloat height1;
@property (assign,nonatomic) CGFloat height2;
@property (assign,nonatomic) CGFloat height3;
@property (assign,nonatomic) CGFloat buttonVIewY;

@property (weak, nonatomic) IBOutlet UIButton *previousPage;
@property (weak, nonatomic) IBOutlet UIButton *nextPage;

@end

@implementation ViewController
UITextField *tempTextFiled;
NSInteger currentPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_text1 setDelegate:self];
    [_text2 setDelegate:self];
    [_text3 setDelegate:self];
    //设置键盘监听,监听 键盘将要出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    //设置键盘监听,监听 键盘将要隐藏
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
     _height1 = _text1.frame.origin.y;
     _height2 = _text2.frame.origin.y;
     _height3 = _text3.frame.origin.y;
     _buttonVIewY = _buttonVIew.frame.origin.y;
    
    _buttonVIew.hidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tempTextFiled resignFirstResponder];
}


#pragma mark 开始选择编辑框时
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    tempTextFiled = textField;
    currentPage = textField.tag;
}



#pragma mark 键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[value CGRectValue] fromView:nil];
    double keyboardHeight = keyboardRect.size.height;//键盘高度
    //计算偏移
    _heightOffset =[[UIScreen mainScreen] bounds].size.height - keyboardHeight  - REGISTERTABLE_CELL_HEGHIT;

    CGFloat translateY=(-1);
    [self animation:translateY];
    [self hidden];
    tempTextFiled.hidden = false;
    _buttonVIew.hidden = false;

}

#pragma mark 键盘隐藏事件
-(void)keyboardWillHide:(NSNotification *)notification{
  CGFloat translateY= 1;
  [self show];
  _buttonVIew.hidden = true;
  [self animation:translateY];
  

    
}

#pragma mark 动画事件
-(void)animation:(CGFloat) translateY{
    CGFloat x1 =(_height1 - _heightOffset)*translateY;
    CGFloat x2 =(_height2 - _heightOffset)*translateY;
    CGFloat x3 =(_height3 - _heightOffset)*translateY;
    CGFloat x4 =(_buttonVIewY - _heightOffset)*translateY;

    
    [UIView animateWithDuration:1 animations:^{
        _text1.transform=CGAffineTransformTranslate(_text1.transform, 0, x1);
        _text2.transform=CGAffineTransformTranslate(_text2.transform, 0, x2);
        _text3.transform=CGAffineTransformTranslate(_text3.transform, 0, x3);
        _buttonVIew.transform=CGAffineTransformTranslate(_buttonVIew.transform, 0, x4);
    }];
}



-(void)show{
     _text1.hidden = false;
     _text2.hidden = false;
     _text3.hidden = false;
}

-(void)hidden{
    _text1.hidden = true;
    _text2.hidden = true;
    _text3.hidden = true;
}


#pragma mark 上一页
- (IBAction)previousBtn:(id)sender {
    [self hidden];   //全部隐藏
    NSInteger i;
    if(currentPage==1){
         i = 3;
    }else{
        i = currentPage - 1;
    }
    UIView *view =[self.view viewWithTag:i];
    view.hidden = false;
    [view becomeFirstResponder];
    currentPage = i;
}

#pragma mark 下一页
- (IBAction)nextBtn:(id)sender {
    [self hidden];   //全部隐藏
    NSInteger i;
    if(currentPage==3){
        i = (currentPage + 1) % 3;
    }else{
        i = currentPage + 1;
    }
    UIView *view =[self.view viewWithTag:i];
    view.hidden = false;
    [view becomeFirstResponder];
    currentPage = i;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//
////点击键盘上的Return按钮响应的方法
//-(IBAction)nextOnKeyboard:(UITextField *)sender
//{
////    if (sender == self.userNameText) {
////        [self.passwordText becomeFirstResponder];
////    }else if (sender == self.passwordText){
////        [self hidenKeyboard];
////    }
//}
@end
