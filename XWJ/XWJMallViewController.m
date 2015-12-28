//
//  XWJMallViewController.m
//  XWJ
//
//  Created by Sun on 15/12/13.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMallViewController.h"

@interface XWJMallViewController ()

@end

@implementation XWJMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商城";
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    UIImage *image = [UIImage imageNamed:@"backIcon"];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = nil;
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
