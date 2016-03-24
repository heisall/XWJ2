//
//  XWJWebViewController.m
//  XWJ
//
//  Created by Sun on 15/12/20.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJWebViewController.h"


@implementation XWJWebViewController

-(void)viewDidLoad{
    
    self.navigationItem.title =@"详情";
//    创建显示详情的webview页面
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 164, SCREEN_SIZE.width, self.view.bounds.size.height)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    webView.scalesPageToFit = YES;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
@end
