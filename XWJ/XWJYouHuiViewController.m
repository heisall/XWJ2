//
//  XWJYouHuiViewController.m
//  XWJ
//
//  Created by Sun on 15/12/27.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJYouHuiViewController.h"

@interface XWJYouHuiViewController ()

@end

@implementation XWJYouHuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"优惠政策";
    UILabel * labl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_SIZE.width, SCREEN_SIZE.height-20)];
    labl.text = self.zhengce;
    [self.view addSubview:labl];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
