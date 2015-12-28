//
//  NichengViewController.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/21.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "NichengViewController.h"
#import "XWJMyInfoViewController.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface NichengViewController ()

@end

@implementation NichengViewController{

    UITextField *textF;
    UIButton *_button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

-(void)createUI{
    
    textF = [[UITextField alloc]init];
    textF.frame = CGRectMake(30, 90, WIDTH - 60, 30);
//    UITextField * textField = (UITextField *)[self.view viewWithTag:1];
    textF.placeholder = @"请输入昵称";
//    //    设置文本的字体类型和大小
//    textField.font = [UIFont italicSystemFontOfSize:30];
//    //    设置字体颜色(默认为黑色)
//    textField.textColor = [UIColor redColor];
   
    textF.adjustsFontSizeToFitWidth = YES;
    textF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textF];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame  = CGRectMake(30, 140, WIDTH - 60, 30);
    [_button setTitle:@"完成" forState:UIControlStateNormal];
    _button.layer.cornerRadius = 5;
    _button.backgroundColor = [UIColor colorWithRed:0.18 green:0.67 blue:0.65 alpha:1];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
}

-(void)onButtonClick{

  
    self.returnStrBlock(textF.text);
     [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //点任何空白区域才能收下键盘
    [textF resignFirstResponder];
    //    [self.view endEditing:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
