//
//  XWJYouhuiController.m
//  XWJ
//
//  Created by Sun on 16/1/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJYouhuiController.h"
#import "XWJAccount.h"
#import "XWJWebViewController.h"
@interface XWJYouhuiController(){
    CGFloat height ;
}
@property UIScrollView * scrollView;
@property NSArray * ads;
@end
@implementation XWJYouhuiController
@synthesize scrollView,ads;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 62, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    height = SCREEN_SIZE.height/4;
    self.navigationItem.title = @"商城优惠";
    [self.view addSubview:scrollView];
    [self getYouHui];
}

-(void)getYouHui{
    NSString *url = GETYOUHUI_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
     pageindex	第几页	String,从0开始
     countperpage	每页条数	String
     cateId	商户分类	String
     */
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            ads = [dic objectForKey:@"ad"];
            [self addADView];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)addADView{
    for (int i = 0; i<ads.count; i++) {
        NSDictionary *dic = [ads objectAtIndex:i];
        NSString *url =   [dic objectForKey:@"Photo"];
        
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*(height+15), self.scrollView.bounds.size.width, height)];
        iv.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        iv.tag = i ;
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        [iv addGestureRecognizer:singleRecognizer];
        [iv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        [scrollView addSubview:iv];
    }
    scrollView.contentSize  = CGSizeMake(0, ads.count*(height+5)+62);
}

-(void)singleTap:(UITapGestureRecognizer *)btn{
    NSInteger index = btn.view.tag;
    
    NSLog(@"计数%ld",index);
    
    XWJWebViewController *web = [[XWJWebViewController alloc] init];
    web.url  = [[ads objectAtIndex:index] objectForKey:@"url"];
    [self.navigationController pushViewController:web animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden  = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden  = NO;
}

@end
