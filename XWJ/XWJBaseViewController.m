//
//  XWJBaseViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJBaseViewController ()

@end

@implementation XWJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatusBar];
    [self setNavigationBar];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:236/255.0 alpha:1.0];

}

-(void)setStatusBar{
    //set status bar hidden
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        //iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

-(void)setNavigationBar{
    self.navigationController.navigationBar.hidden = NO;
    
    //set navigationitem title titlecolor
    
    //set navigationitem titlecolor
    UIColor * color = [UIColor whiteColor];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //set button item color style
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  
    
    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
//    self.navigationItem.leftBarButtonItem.style = UIBarButtonSystemItemCancel;
    
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.leftBarButtonItem = barItem;
    //set navigation bar background color
    self.navigationController.navigationBar.barTintColor  = [UIColor colorWithRed:20.0/255.0 green:157.0/255.0 blue:150.0/255.0 alpha:1.0];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
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
