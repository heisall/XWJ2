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
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    [self.view addSubview:webView];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
}

@end
