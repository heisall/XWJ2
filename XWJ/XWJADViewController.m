//
//  XWJADViewController.m
//  XWJ
//
//  Created by Sun on 15/12/14.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJADViewController.h"

@interface XWJADViewController ()
@property UIWebView *webView;
@end

@implementation XWJADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    
    [self.view addSubview:self.webView];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[_dic valueForKey:@"url"]]];
    self.webView.scalesPageToFit = TRUE;
    [self.webView loadRequest:request];
    self.navigationItem.title =@"详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
