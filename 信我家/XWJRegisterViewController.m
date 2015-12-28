//
//  XWJRegisterViewController.m
//  信我家
//
//  Created by Paul on 17/11/15.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJRegisterViewController.h"

@interface XWJRegisterViewController ()

@end

@implementation XWJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.title = @"找回密码";
    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController ];
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame=CGRectMake(0, 0, 30, 30);
//    [button setImage:[UIImage imageNamed:@"nav_Back_Icon"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(playListNavItemClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
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
