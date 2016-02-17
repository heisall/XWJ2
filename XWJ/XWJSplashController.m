//
//  XWJSplashController.m
//  XWJ
//
//  Created by Sun on 16/1/26.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJSplashController.h"

@interface XWJSplashController()<UIScrollViewDelegate>
@property UIScrollView* scrollView;
@property NSInteger count;
@end
@implementation XWJSplashController
@synthesize scrollView;

-(void)viewDidLoad{
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width
                                                               , SCREEN_SIZE.height)];
    self.count = 3;
    for (int i=0; i<self.count; i++) {
        
        UIImageView*imv = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_SIZE.width, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
//        UIImage *image = [UIImage imageNamed:@"splash3"];

        
        
        imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"splash%d",i+1]];
        imv.userInteractionEnabled = YES;
        if (i==0) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREEN_SIZE.width-80, (SCREEN_SIZE.height- 80)/2, 80, 80);

            [btn addTarget:self action:@selector(scroll1) forControlEvents:UIControlEventTouchUpInside];
          
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 addTarget:self action:@selector(gologin) forControlEvents:UIControlEventTouchUpInside];
            btn1.frame = CGRectMake(0, (SCREEN_SIZE.height-80), SCREEN_SIZE.width, 80);

            [imv addSubview:btn];
            [imv addSubview:btn1];
        }
        
        if (i==1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREEN_SIZE.width-80, (SCREEN_SIZE.height- 80)/2, 80, 80);
            [btn addTarget:self action:@selector(scroll2) forControlEvents:UIControlEventTouchUpInside];
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(0, (SCREEN_SIZE.height-80), SCREEN_SIZE.width, 80);
            [btn1 addTarget:self action:@selector(gologin) forControlEvents:UIControlEventTouchUpInside];
            [imv addSubview:btn];
            [imv addSubview:btn1];
        }
        
        if (i==self.count-1) {
            
            UITapGestureRecognizer* singleRecognizer;
            singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gologin)];
            //点击的次数
            singleRecognizer.numberOfTapsRequired = 1;
            [imv addGestureRecognizer:singleRecognizer];
        }
        imv.userInteractionEnabled = YES;
        [scrollView addSubview:imv];
    }
    
    scrollView.scrollsToTop = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize =CGSizeMake(self.count*SCREEN_SIZE.width, 0);
    [self.view addSubview:scrollView];
}
-(void)scroll2{
    self.scrollView.contentOffset = CGPointMake(SCREEN_SIZE.width*2, 0);
}
-(void)scroll1{
    self.scrollView.contentOffset = CGPointMake(SCREEN_SIZE.width, 0);
}
-(void)gologin{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLaunched"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
    self.view.window.rootViewController = [loginStoryboard instantiateInitialViewController];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollW = self.scrollView.frame.size.width;
    NSInteger currentPage = self.scrollView.contentOffset.x / scrollW;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat scrollW = self.scrollView.frame.size.width;
    NSInteger currentPage = self.scrollView.contentOffset.x / scrollW;
    [self.scrollView setContentOffset:CGPointMake(self.count * scrollW, 0) animated:NO];
}
@end
