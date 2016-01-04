//
//  XWJZuShouViewController.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJZuShouViewController.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
#import "TitleView.h"
#import "MyChuShouViewController.h"
#import "MyChuZuViewController.h"

@interface XWJZuShouViewController ()<UIScrollViewDelegate>
@end

@implementation XWJZuShouViewController{

    UIScrollView *_scrollView;
    TitleView * _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBarHidden = YES;
  //  self.tabBarController.tabBar.hidden = YES;
    self.title = @"我的租售";
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,44,self.view.frame.size.width,self.view.frame.size.height - 44)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height - 64 -200);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [self addSubviewsToScrollView:_scrollView];
    
    __weak UIScrollView * scrollview = _scrollView;
    _titleView = [[TitleView alloc]initWithFrame:CGRectMake(0, 20 +44, WIDTH, 44)];
    NSArray * array = @[@"我的出售",@"我的出租"];
    _titleView.titles = array;
    _titleView.buttonSelectAtIndex = ^(NSInteger index){
        scrollview.contentOffset = CGPointMake(WIDTH*index, -64);
    };
    [self.view addSubview:_titleView];
}
-(void)addSubviewsToScrollView:(UIScrollView*)scrollView
{
    MyChuShouViewController * chushou = [[MyChuShouViewController alloc]init];
    MyChuZuViewController * chuzu = [[MyChuZuViewController alloc]init];
    NSArray * array = @[chushou,chuzu];
    
    for (int i = 0; i < 2; i++) {
        UIViewController * vc = array[i];
        vc.view.frame = CGRectMake(i*WIDTH, 0, WIDTH, HEIGHT  -64 -44);
        [_scrollView addSubview:vc.view];
        //
        [self addChildViewController:vc];
    }
    
    
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/WIDTH;
    _titleView.currentPage = index;
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
