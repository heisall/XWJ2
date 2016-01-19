

//
//  WaiLianViewController.m
//  XWJ
//
//  Created by 徐仁强 on 16/1/19.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "WaiLianViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
@interface WaiLianViewController ()<UIWebViewDelegate>{
    //    UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation WaiLianViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title  = @"详情";
    UIWebView*  webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [self isIOS7], WIDTH, SCREENHEIGHT - [self isIOS7])];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.autoresizesSubviews = YES; //自动调整大小
    
    [self.view addSubview:webView];
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : activityIndicatorView] ;
    if (![self.urlString hasPrefix:@"http"]) {
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }else{
        
    }
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlString]];
    NSLog(@"链接地址-----%@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self createLeftNvc];
}
-(float)isIOS7{
    
    float height;
    if (IOS7) {
        height=64.0;
    }else{
        height=44.0;
    }
    
    return height;
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)createLeftNvc{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,27)];
    [rightButton setImage:[UIImage imageNamed:@"返回按钮"]forState:UIControlStateNormal];
    [rightButton setTitle:@"返回" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    //    rightButton.backgroundColor = [UIColor redColor];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [rightButton addTarget:self action:@selector(backBtnClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem= rightItem;
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"----错误----%@",[error localizedDescription]);
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
