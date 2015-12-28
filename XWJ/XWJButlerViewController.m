//
//  XWJButlerViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJButlerViewController.h"
#import "XWJButlerViewController.h"
#import "LCBannerView.h"
#import "XWJNoticeViewController.h"
#import "XWJGuzhangViewController.h"
#import "AFNetworking.h"
#import "XWJCity.h"
#import "XWJPay1ViewController.h"
#import "XWJZFViewController.h"
#import "XWJAccount.h"
#import "XWJWebViewController.h"
#import "XWJUtil.h"
@implementation XWJButlerViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self addView];
    
    [self getGuanjiaAD];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"huname"]) {
//        self.room.text =  [[NSUserDefaults standardUserDefaults] objectForKey:@"huname"];
//    }
    
    if ([XWJAccount instance].array&&[XWJAccount instance].array.count>0) {
        for (NSDictionary *dic in [XWJAccount instance].array ) {
            if ([[dic valueForKey:@"isDefault" ] integerValue]== 1) {
                self.room.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"A_name"]];
            }
        }
    }
;
}

-(void)getGuanjiaAD{
    NSString *url = GETGUANJIAAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
     a_id	小区a_id	String
     userid	用户id	String
     */
    
    //    [dict setValue:[XWJCity instance].aid  forKey:@"a_id"];
//    [dict setValue:@"1"  forKey:@"a_id"];
//    NSString *userid = [XWJAccount in];
//    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_id"];
    
//    [dict setValue:@"1" forKey:@"a_id"];
        [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];

    [dict setValue:[XWJAccount instance].uid forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            
            self.notices = [dic objectForKey:@"ads"];
            
            self.roomDic = [dic objectForKey:@"room"];
            
            self.room.text = [NSString stringWithFormat:@"%@%@号楼%@单元%@",[self.roomDic objectForKey:@"A_name"]==[NSNull null]?@"":[self.roomDic objectForKey:@"A_name"],[self.roomDic objectForKey:@"b_id"]==[NSNull null]?@"":[self.roomDic objectForKey:@"b_id"],[self.roomDic objectForKey:@"r_dy"]==[NSNull null]?@"":[self.roomDic objectForKey:@"r_dy"],[self.roomDic objectForKey:@"r_id"]==[NSNull null]?@"":[self.roomDic objectForKey:@"r_id"]];
            NSMutableArray *URLs = [NSMutableArray array];
            for (NSDictionary
                 *dic in self.notices) {
                [URLs addObject:[dic valueForKey:@"Photo"]];
                
            }
            
            if(URLs&&URLs.count>0)
                [self.adView addSubview:({
                    
                    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                                            self.adView.bounds.size.height)
                                                
                                                                        delegate:self
                                                                       imageURLs:URLs
                                                                placeholderImage:@"devAdv_default"
                                                                   timerInterval:3.0f
                                                   currentPageIndicatorTintColor:[UIColor redColor]
                                                          pageIndicatorTintColor:[UIColor whiteColor]];
                    bannerView;
                })];

            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)addView{
    for (int i=0; i<7; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guanjia%d",i+1]] forState:UIControlStateNormal];
        btn.frame = CGRectMake((SCREEN_SIZE.width/4+1)*(i%4), self.room.frame.origin.y+self.room.bounds.size.height+60 + ((int)(i/4))*(SCREEN_SIZE.width/4+1), SCREEN_SIZE.width/4 , SCREEN_SIZE.width/4 );
        btn.tag = i;
//        btn.backgroundColor = XWJColor(124, 197, 193);
        [btn setTitleColor:XWJGREENCOLOR forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        if ([[XWJUtil deviceString] isEqualToString:@"iPhone 6 plus"]) {
            
            [btn setImageEdgeInsets:UIEdgeInsetsMake(15, 25, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(70, -28, 0, 0)];
        }else{
            [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(60, -37, 0, 0)];
        }
        
//        btn.al
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

-(void)initData{
    self.titles = [NSArray arrayWithObjects:@"物业通知",@"社区活动",@"故障报修",@"投诉表扬", @"物业账单",@"物业监督",@"房屋租赁",nil];

    
    UIStoryboard * HomeStoryboard = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
    XWJNoticeViewController *notice = [HomeStoryboard instantiateViewControllerWithIdentifier:@"noticeController"];
    notice.type  = @"0";
    XWJNoticeViewController *notice2 = [HomeStoryboard instantiateViewControllerWithIdentifier:@"noticeController"];
    notice2.type  = @"1";
    
    
    UIStoryboard * wuy = [UIStoryboard storyboardWithName:@"WuyeStoryboard" bundle:nil];
    UIViewController *wu = [wuy instantiateInitialViewController];
    
    XWJPay1ViewController *pay = [HomeStoryboard instantiateViewControllerWithIdentifier:@"pay1"];
    
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"XWJZFStoryboard" bundle:nil];

    XWJZFViewController *zf = [story instantiateInitialViewController];
    zf.type = 2;
    UIStoryboard *guzhang = [UIStoryboard storyboardWithName:@"GuzhanStoryboard" bundle:nil];
    XWJGuzhangViewController *gz = [guzhang instantiateInitialViewController];
    gz.type = 1;
    
    XWJGuzhangViewController *gz2 = [guzhang instantiateInitialViewController];
    gz2.type = 2;
    self.vConlers = [NSArray arrayWithObjects:notice,notice2,gz,gz2,pay,wu,zf,nil];
}

-(void)btnclick:(UIButton *)btn{
    [self.navigationController showViewController:[self.vConlers objectAtIndex:btn.tag] sender:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"管家";
    self.navigationItem.leftBarButtonItem = nil;

    self.tabBarController.tabBar.hidden = NO;
//    NSString *ti =[NSString stringWithFormat:@"%@%@",[[XWJCity instance].district valueForKey:@"a_name"]?[[XWJCity instance].district valueForKey:@"a_name"]:@"",[[XWJCity instance].buiding valueForKey:@"b_name"]?[[XWJCity instance].buiding valueForKey:@"b_name"]:@""];
//    self.room.text  = ti;
//    [self addView];

//    [self getGuanjiaAD];
    
//    /******************** internet ********************/
//    NSArray *URLs = @[@"http://admin.guoluke.com:80/userfiles/files/admin/201509181707000766.png",
//                      @"http://admin.guoluke.com:80/userfiles/files/admin/201509181707000766.png",
//                      @"http://img.guoluke.com/upload/201509091054250274.jpg"];
//    [self.adView addSubview:({
//        
//        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
//                                                                                self.adView.bounds.size.height)
//                                    
//                                                            delegate:self
//                                                           imageURLs:URLs
//                                                    placeholderImage:nil
//                                                       timerInterval:3.0f
//                                       currentPageIndicatorTintColor:[UIColor redColor]
//                                              pageIndicatorTintColor:[UIColor whiteColor]];
//        bannerView;
//    })];
    
}

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    NSLog(@"you clicked image in %@ at index: %ld", bannerView, (long)index);
    
    if (self.notices) {
        if ([[[self.notices objectAtIndex:index] objectForKey:@"Types"] isEqualToString:@"外链"]) {
            XWJWebViewController *web = [[XWJWebViewController alloc] init];
            
            NSString *url  = [[self.notices objectAtIndex:index] objectForKey:@"url"];
            web.url = url;
            [self.navigationController  showViewController:web sender:self];
        }
    }
        //        UIStoryboard *FindStory =[UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
        //        UIViewController *mesCon = [FindStory instantiateViewControllerWithIdentifier:@"activityDetail"];
//        XWJNoticeViewController *notice = [self.storyboard instantiateViewControllerWithIdentifier:@"noticeController"];
//        [self.navigationController showViewController:notice sender:nil];
        NSLog(@"notice click");
    
}
@end
