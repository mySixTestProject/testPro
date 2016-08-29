//
//  ViewController.m
//  limitBytesTextFieldDemo
//
//  Created by jin on 16/2/5.
//  Copyright © 2016年 jin. All rights reserved.
//

#import "ViewController.h"

#define kLimitBytesNumber 8

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *myTextField;

@property (nonatomic, strong) NSString *lastTextContent;

@end

@implementation ViewController


- (UITextField *)myTextField
{
    if (!_myTextField) {
        _myTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, self.view.bounds.size.width - 60, 40)];
        
        _myTextField.backgroundColor = [UIColor orangeColor];
        _myTextField.placeholder = @"限制16个字节长度";
        _myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    
    return _myTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTextField.delegate = self;
    
    self.view.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.myTextField];
    
    //注册通知，textfield内容改变调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.myTextField];

    
    
}

//通知
- (void)textFieldDidChange:(NSNotification *)note
{
//    UITextField *textField = note.object;
    //获取文本框内容的字节数
    int bytes = [self stringConvertToInt:self.myTextField.text];
    //设置不能超过16个字节，因为不能有半个汉字，所以以字符串长度为单位。
    if (bytes > kLimitBytesNumber)
    {
        //超出字节数，还是原来的内容
        self.myTextField.text = self.lastTextContent;
    }
    else
    {
        self.lastTextContent = self.myTextField.text;
    }
}


/**
 *  得到字节数
 *
 *  @param strtemp 要获取字节的字符串
 *
 *  @return 返回字节数+1的一半，因为不会有半个汉字
 */
-  (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.lastTextContent = textField.text;
    return YES;
}

//点击空白，隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.myTextField resignFirstResponder];
}

@end
