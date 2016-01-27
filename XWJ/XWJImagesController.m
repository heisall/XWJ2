//
//  XWJImagesController.m
//  XWJ
//
//  Created by Sun on 16/1/27.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJImagesController.h"
#import "LCBannerView.h"

@interface XWJImagesController()<LCBannerViewDelegate>

@end
@implementation XWJImagesController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSMutableArray *URLs = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.urls) {
        URLs = [NSMutableArray arrayWithArray:[self.urls componentsSeparatedByString:@","]];
    }
    //    UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,                                                                                           self.adView.bounds.size.height)];
    //    logoImgV.contentMode  = UIViewContentModeScaleAspectFit;
    //    [logoImgV sd_setImageWithURL:[NSURL URLWithString:[self.goodsDic objectForKey:@"default_image"]] placeholderImage:[UIImage imageNamed:@"demo"]];
    //
    //    [self.adView addSubview:logoImgV];
    
    
    
    if(URLs&&URLs.count>0)
        [self.view addSubview:({
            

            LCBannerView *bannerView = [[LCBannerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                                    self.view.bounds.size.height)
                                        
                                                                delegate:self
                                                               imageURLs:URLs
                                                        placeholderImage:@"devAdv_default"
                                                           timerInterval:MAXFLOAT
                                           currentPageIndicatorTintColor:[UIColor redColor]
                                                  pageIndicatorTintColor:[UIColor whiteColor]:UIViewContentModeCenter];
            bannerView;
        })];
}

@end
