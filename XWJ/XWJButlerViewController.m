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
    //判断是否为游客模式
    if([XWJAccount instance].isYouke){
        self.room.text  = @"";
    }else
    if ([XWJAccount instance].array&&[XWJAccount instance].array.count>0) {
        for (NSDictionary *dic in [XWJAccount instance].array ) {
            if ([[dic valueForKey:@"isDefault"] integerValue]== 1) {
                self.room.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"A_name"]];
            }
        }
    }
    self.scrollView.contentSize = CGSizeMake(0, SCREEN_SIZE.height+100);
}

//获取绑定山庄的详细信息
-(void)getGuanjiaAD{
    NSString *url = GETGUANJIAAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
     a_id	小区a_id	String
     userid	用户id	String
     */

    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    [dict setValue:[NSString stringWithFormat:@"%@",[XWJAccount instance].uid] forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            
            self.notices = [dic objectForKey:@"ads"];
            
            self.roomDic = [dic objectForKey:@"room"];
            
            if([XWJAccount instance].isYouke){
                self.room.text  = @"";
            }else{
                self.room.text = [NSString stringWithFormat:@"%@%@号楼%@单元%@",[self.roomDic objectForKey:@"A_name"]==[NSNull null]?@"":[self.roomDic objectForKey:@"A_name"],[self.roomDic objectForKey:@"b_id"]==[NSNull null]?@"":[self.roomDic objectForKey:@"b_id"],[self.roomDic objectForKey:@"r_dy"]==[NSNull null]?@"":[self.roomDic objectForKey:@"r_dy"],[self.roomDic objectForKey:@"r_id"]==[NSNull null]?@"":[self.roomDic objectForKey:@"r_id"]];
            }
            
            NSMutableArray *URLs = [NSMutableArray array];
            for (NSDictionary
                 *dic in self.notices) {
                [URLs addObject:[dic valueForKey:@"Photo"]];
                
            }
            
            if(URLs&&URLs.count>0)
                [self.adView addSubview:({
                    
                    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,self.adView.bounds.size.height)
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
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

//添加具体的模块
-(void)addView{
    for (int i=0; i<8; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guanjia%d",i+1]] forState:UIControlStateNormal];
        btn.frame = CGRectMake((SCREEN_SIZE.width/4+1)*(i%4), self.room.frame.origin.y+self.room.bounds.size.height+10 + ((int)(i/4))*(SCREEN_SIZE.width/4+1), SCREEN_SIZE.width/4 , SCREEN_SIZE.width/4 );
        btn.tag = i;
        [btn setTitleColor:XWJGREENCOLOR forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        CLog(@"btn %@",[XWJUtil deviceString]);
        //对不同型号的手机进行适配
        if ([[XWJUtil deviceString] isEqualToString:@"iPhone 6 plus"]) {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(15, 25, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(70, -28, 0, 0)];
        }else{
            [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(60, -37, 0, 0)];
        }

        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
}
// 初始化数据
-(void)initData{
    
//    物业通知、社区活动、物业监督、物业报修、物业投诉、物业账单、海信地产、二手房源
    self.titles = [NSArray arrayWithObjects:@"物业通知",@"社区活动",@"物业监督",@"物业报修",@"物业投诉", @"物业账单",@"海信地产",@"二手房源",nil];
    
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
    zf.type = 0;
    
    UIStoryboard *guzhang = [UIStoryboard storyboardWithName:@"GuzhanStoryboard" bundle:nil];
    XWJGuzhangViewController *gz = [guzhang instantiateInitialViewController];
    gz.type = 1;
    
    XWJGuzhangViewController *gz2 = [guzhang instantiateInitialViewController];
    gz2.type = 2;
    
    XWJZFViewController *secondF = [story instantiateInitialViewController];
    secondF.type = 1;
    self.vConlers = [NSArray arrayWithObjects:notice,notice2,wu,gz,gz2,pay,zf,secondF,nil];
}

//添加按钮的点击事件
-(void)btnclick:(UIButton *)btn{
    
//       如果是游客模式就没法使用报修投诉和账单功能
       if ([XWJAccount instance].isYouke&&((btn.tag == 3)||(btn.tag  == 5)||(btn.tag == 4))) {
       UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有绑定房间，请绑定后使用。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertview.delegate = self;
       [alertview show];
      }else{
    
    [self.navigationController showViewController:[self.vConlers objectAtIndex:btn.tag] sender:nil];
    
      }
}

//如果是游客模式可以继续选择城市
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
    bind.title = @"城市选择";
    bind.delegate = self;
    bind->mode = HouseCity;
    [self.navigationController showViewController:bind sender:nil];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getGuanjiaAD];
    
    if([XWJAccount instance].isYouke){
        self.navigationItem.title = [NSString stringWithFormat:@"%@",[[XWJCity instance].district valueForKey:@"a_name"]];
    }else
        if ([XWJAccount instance].array&&[XWJAccount instance].array.count>0) {
            for (NSDictionary *dic in [XWJAccount instance].array ) {
                if ([[dic valueForKey:@"isDefault" ] integerValue]== 1) {
                    self.navigationItem.title = [NSString stringWithFormat:@"%@",[dic valueForKey:@"A_name"]];
                }
            }
        }
    
    UIImage *image = [UIImage imageNamed:@"homemes"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;

    self.navigationItem.leftBarButtonItem = nil;

    self.tabBarController.tabBar.hidden = NO;    
}
-(void)showList{

}
//选中某个广告图片的时候进入广告web页
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    CLog(@"you clicked image in %@ at index: %ld", bannerView, (long)index);
    
    if (self.notices) {
        if ([[[self.notices objectAtIndex:index] objectForKey:@"Types"] isEqualToString:@"外链"]) {
            XWJWebViewController *web = [[XWJWebViewController alloc] init];
            
            NSString *url  = [[self.notices objectAtIndex:index] objectForKey:@"url"];
            web.url = url;
            [self.navigationController  showViewController:web sender:self];
        }
    }
}




@end
