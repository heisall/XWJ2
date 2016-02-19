//
//  XWJHomeViewController2.m
//  XWJ
//
//  Created by Sun on 15/11/30.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJHomeViewController2.h"

@interface XWJHomeViewController2 ()

@end

@implementation XWJHomeViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar2];
}

-(void)showList{
    
}
//设置头标题的城市名称
-(void)setNavigationBar2{
    
    self.navigationItem.title = @"XX城";
    UIImage *image = [UIImage imageNamed:@"liebiao"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
