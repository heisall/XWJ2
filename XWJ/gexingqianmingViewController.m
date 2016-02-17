//
//  gexingqianmingViewController.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/21.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "gexingqianmingViewController.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface gexingqianmingViewController ()

@end

@implementation gexingqianmingViewController{

    UITextField *textF;
    UIButton *_button;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性签名";
    [self createUI];
    
}

-(void)createUI{
    
    textF = [[UITextField alloc]init];
    textF.frame = CGRectMake(30, 90, WIDTH - 60, 90);
    textF.placeholder = @"请编辑您的个性签名";
    textF.adjustsFontSizeToFitWidth = YES;
    textF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textF];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame  = CGRectMake(30, 200, WIDTH - 60, 30);
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
    [textF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
