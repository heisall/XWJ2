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
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
