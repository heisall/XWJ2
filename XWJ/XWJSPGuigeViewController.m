//
//  XWJSPGuigeViewController.m
//  XWJ
//
//  Created by Sun on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJSPGuigeViewController.h"

@interface XWJSPGuigeViewController ()

@end

@implementation XWJSPGuigeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品规格";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 70,100 ,20)];
   label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text  = @"暂无规格参数";
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
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
