//
//  XWJHomeViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJHomeViewController.h"
#import "XWJHeader.h"
#import "XWJMyMessageController.h"
#import "XWJNoticeViewController.h"
#import "LCBannerView.h"
#import "XWJBingHouseViewController.h"
#import "XWJBindHouseTableViewController.h"
#import "XWJPay1ViewController.h"
#import "XWJZFViewController.h"
#import "XWJGuzhangViewController.h"
#import "XWJActivityViewController.h"
#import "XWJCity.h"
#import "XWJAccount.h"
#import "XWJADViewController.h"
#import "XWJShuoListViewController.h"
#import "XWJShangmenViewController.h"
#define  CELL_HEIGHT 150.0
#define  COLLECTION_NUMSECTIONS 3
#define  COLLECTION_NUMITEMS 1
#define  HEADER_HEIGHT 25.0

#define TAG 100

@interface XWJHomeViewController ()<XWJBindHouseDelegate,UIAlertViewDelegate>
@property (nonatomic)NSTimer *timer;
@property (nonatomic, assign) CGFloat timerInterval;
@property NSInteger currentPage;
@property BOOL isBind;
@property (nonatomic)NSInteger section;
@property NSMutableArray *notices;
@property NSMutableArray *shows ;
@property NSMutableArray *shuoArr ;
@end

@implementation XWJHomeViewController
CGFloat collectionCellHeight;
CGFloat collectionCellWidth;
static NSString *kcellIdentifier = @"homecollectionCellID2";
static NSString *kcellIdentifier1 = @"homecollectionCellID3";
static NSString *kcellIdentifier4 = @"homecollectionCellID4";

static NSString *kheaderIdentifier = @"headerIdentifier";
NSArray *footer;
-(void)viewDidLoad{
    
//    [self setNavigationBar2];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
   
//     [XWJCity instance].aid = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_id"];
    [XWJAccount instance].aid = [XWJAccount instance].aid;
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWJSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    footer = [NSArray arrayWithObjects:@"便民信息",@"商城信息",@"房屋信息", nil];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWJHomeCollectionCell2" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWJHomeCollectionCell3" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier1];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWJHomeCollectionCell4" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier4];

    self.shows = [NSMutableArray array];
    self.notices = [NSMutableArray array];
    [self getAd];
    
    
    self.collectionView.frame = CGRectMake(0, self.scrollView.frame.origin.y
                                           + self.scrollView.bounds.size.height+40, SCREEN_SIZE.width, (CELL_HEIGHT+HEADER_HEIGHT)*COLLECTION_NUMSECTIONS+100);
    CGFloat height = self.scrollView.bounds.size.height+self.adScrollView.bounds.size.height+self.mesScrollview.bounds.size.height+self.collectionView.bounds.size.height+100;
    
    self.backScollView.contentSize = CGSizeMake(SCREEN_SIZE.width, height);

//    送水 5，家政 6，鲜花 31，洗衣 7，蛋糕16
//    cateName = "\U6d17\U8863";
//    id = 7;
//    "parent_id" = 1;
    self.shuoArr = [NSMutableArray arrayWithObjects:@{@"cateName":@"送水",@"id":@"5",@"parent_id":@"1"},@{@"cateName":@"家政",@"id":@"6",@"parent_id":@"1"},@{@"cateName":@"洗衣",@"id":@"7",@"parent_id":@"1"},@{@"cateName":@"鲜花",@"id":@"31",@"parent_id":@"1"},@{@"cateName":@"蛋糕",@"id":@"16",@"parent_id":@"1"}, nil];
    
}
- (IBAction)qiandao:(UIButton *)sender {
}
- (IBAction)jifen:(UIButton *)sender {
}

-(void)msgClick:(UIButton *)sender{
    NSLog(@"click %ld",(long)sender.tag);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"scrolview width %f height %f",self.scrollView.bounds.size.width,self.scrollView.bounds.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self setNavigationBar2];
    NSLog(@"scrolview width %f height %f",self.scrollView.bounds.size.width,self.scrollView.bounds.size.height);
    NSLog(@"view width %f height %f",self.view.bounds.size.width,self.view.bounds.size.height);

//    NSArray * arr= [NSArray arrayWithObjects:@"故障报修",@"在线缴费",@"我要投诉",@"物业监督",@"物业监督", nil];
    NSArray * arr= [NSArray arrayWithObjects:@"物业通知",@"社区活动",@"物业监督",@"物业报修",@"物业投诉", @"物业账单",nil];

    NSArray * business= [NSArray arrayWithObjects:@"hometongzhi",@"homehuodong",@"homewy",@"homegz",@"homets",@"homejf", nil];

    NSInteger count = arr.count;
    CGFloat width = self.view.bounds.size.width/4;
    CGFloat height = self.scrollView.bounds.size.height;
    self.scrollView.contentSize = CGSizeMake(width*count, height);
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, 0, width, height);
        button.tag = TAG+i;
        
        [button setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
//        button.titleLabel.text= [arr objectAtIndex:i];
        button.contentMode = UIViewContentModeCenter;
        [button setImage:[UIImage imageNamed:[business objectAtIndex:i] ] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(45, -25, 0, 0)];
        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }

}


/*
 errorCode = "";
 hoursead =     (
 );
 lifad =     (
 );
 notices =     (
 {
 id = 10;
 title = "\U65b0\U95fb\U64ad\U62a5\U2014\U2014\U6d77\U4fe1\U5730\U4ea7\U7b2c\U4e00\U5c4a\U7279\U79cd\U5175\U8bad\U7ec3\U8425\U6b63\U5f0f\U5f00\U8425\U5566\Uff01";
 types = 1;
 },
 {
 id = 5;
 title = "\U6d77\U4fe1\U201c\U4fe1\U6211\U5bb6\U201d\U667a\U6167\U793e\U533aAPP\U5f00\U59cb\U6d4b\U8bd5\U4e86\U3002";
 types = 0;
 }
 );
 result = 1;
 shopad =     (
 );
 topad =     (
 {
 "A_id" = 1;
 Content = "<null>";
 Description = "<null>";
 ID = 1;
 Photo = "http://www.hisenseplus.com/HisenseUpload/ad_photo/W020151201665410133194.jpg";
 Types = "\U5916\U94fe";
 url = "http://shop.hisense.com/ad/kongtiao20151127.html";
 },
 {
 "A_id" = 1;
 Content = "<null>";
 Description = "<null>";
 ID = 2;
 Photo = "http://www.hisenseplus.com/HisenseUpload/ad_photo/banner_yyxz_qd.jpg";
 Types = "\U5916\U94fe";
 url = "http://www.haixindichan.com/yiyunxiaozhenQD/index.html";
 }
 );
 */
///index/ads
-(void)getAd{
    NSString *url = GETAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:[XWJCity instance].aid  forKey:@"a_id"];
//        [dict setValue:[XWJAccount instance].aid  forKey:@"a_id"];
            [dict setValue:@"1" forKey:@"a_id"];

    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            
            self.notices = [dic objectForKey:@"notices"];
            self.shows = [dic objectForKey:@"topad"];
            
            NSMutableArray *titls = [NSMutableArray array];
            for (NSDictionary *dic in self.notices) {
                [titls addObject:[dic valueForKey:@"title"]];
            }
            
            NSMutableArray *URLs = [NSMutableArray array];
            for (NSDictionary
                  *dic in self.shows) {
                [URLs addObject:[dic valueForKey:@"Photo"]];

            }
            
            if(URLs&&URLs.count>0)
            [self.adScrollView addSubview:({
                
                LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                                        self.adScrollView.bounds.size.height)
                                            
                                                                    delegate:self
                                                                   imageURLs:URLs
                                                            placeholderImage:@"devAdv_default"
                                                               timerInterval:3.0f
                                               currentPageIndicatorTintColor:[UIColor redColor]
                                                      pageIndicatorTintColor:[UIColor whiteColor]];
                bannerView;
            })];
            
            if (titls&&titls.count>0)
                [self.mesScrollview addSubview:({
                
                LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                                        self.mesScrollview.bounds.size.height)
                                            
                                                                    delegate:self
                                                                      titles:titls timerInterval:2.0
                                               currentPageIndicatorTintColor:[UIColor clearColor] pageIndicatorTintColor:[UIColor clearColor]];
                bannerView;
            })];
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);

    }];
    
    
}
-(void)click:(UIButton*)sender{
    UIStoryboard * wuy = [UIStoryboard storyboardWithName:@"WuyeStoryboard" bundle:nil];
    UIViewController *wu = [wuy instantiateInitialViewController];
    
//    UIStoryboard * noticeStory = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
//    XWJNoticeViewController *notice = [noticeStory instantiateViewControllerWithIdentifier:@"notice"];
    
    XWJNoticeViewController *notice = [self.storyboard instantiateViewControllerWithIdentifier:@"noticeController"];
    XWJNoticeViewController *notice2 = [self.storyboard instantiateViewControllerWithIdentifier:@"noticeController"];
    notice.type  = @"0";
    notice2.type  = @"1";
    XWJPay1ViewController *pay = [self.storyboard instantiateViewControllerWithIdentifier:@"pay1"];

    UIStoryboard *guzhang = [UIStoryboard storyboardWithName:@"GuzhanStoryboard" bundle:nil];
    XWJGuzhangViewController *gz = [guzhang instantiateInitialViewController];
    gz.type = 1;
    
    XWJGuzhangViewController *gz2 = [guzhang instantiateInitialViewController];
    gz2.type = 2;
    
//    self.isBind = [[NSUserDefaults standardUserDefaults] boolForKey:@"bind"];
    self.isBind = [XWJAccount instance].aid?YES:NO;
//    self.isBind = YES;
    NSArray *jump = [NSArray arrayWithObjects:notice,notice2,wu,gz,gz2,pay, nil];

    if (!self.isBind&&((sender.tag-TAG == 3)||(sender.tag - TAG == 5)||(sender.tag - TAG == 4))) {
//        
//        XWJCity *city = [XWJCity instance];
//
//        [city getCity:^(NSArray *arr) {
//
//            NSLog(@"arr %@",arr);
//            NSMutableArray *arr2 = [NSMutableArray array];
//            
//            for (NSDictionary *dic in arr) {
//                [arr2 addObject:[dic valueForKey:@"CityName"]];
//            }
//        }];
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有绑定房间，请绑定后使用。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertview.delegate = self;
        [alertview show];
        
 
    }else{
//        if(sender.tag -TAG >1)
//            return;
        
        
        [self.navigationController showViewController:[jump objectAtIndex:sender.tag-TAG] sender:nil];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
    bind.title = @"城市选择";
    //            bind.dataSource = [NSArray arrayWithObjects:@"青岛市",@"济南市",@"威海市",@"烟台市",@"临沂市", nil];
    
    //        bind.dataSource = arr2;
    bind.delegate = self;
    bind->mode = HouseCity;
    [self.navigationController showViewController:bind sender:nil];
}

#pragma bindhouse delegate
-(void)didSelectAtIndex:(NSInteger)index Type:(HouseMode)type{
    XWJCity *city = [XWJCity instance];
    switch (type) {
        case HouseCity:{
            
            [city selectCity:index];
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"小区选择";
            //            bind.dataSource = [NSArray arrayWithObjects:@"湖岛世家",@"花瓣里",@"依云小镇",@"湖岛世家",@"花瓣里",@"依云小镇",@"湖岛世家",@"花瓣里",@"依云小镇",@"湖岛世家",@"花瓣里",@"依云小镇", nil];
//            bind.dataSource = arr2;
            bind.delegate = self;
            bind->mode = HouseCommunity;
            
            [self.navigationController showViewController:bind sender:nil];
            
//            [city getDistrct:^(NSArray *arr) {
//                NSLog(@"district  %@",arr);
//                NSMutableArray *arr2 = [NSMutableArray array];
//                
//                for (NSDictionary *dic in arr) {
//                    [arr2 addObject:[dic valueForKey:@"a_name"]];
//                }
//                
//            }];
            

        }
            break;
        case HouseCommunity:{
            
            [city selectDistrict:index];

            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"楼座选择";
//            bind.dataSource = [NSArray arrayWithObjects:@"一号楼",@"二号楼",@"三号楼", @"四号楼",@"五号楼",@"六号楼", @"七号楼",@"八号楼",@"九号楼", @"十号楼",@"十一号楼",@"十二号楼", nil];
            bind.delegate = self;
            bind->mode = HouseFlour;
            [self.navigationController showViewController:bind sender:nil];
        }
            break;
        case HouseFlour:{
            
            [city selectBuilding:index];

            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"房间选择";
//            bind.dataSource = [NSArray arrayWithObjects:@"01单元001",@"01单元002",@"01单元003", @"01单元004",@"01单元005",@"01单元006",@"01单元007",@"01单元008",@"01单元009",@"01单元010",@"01单元011",@"01单元012",nil];
            bind.delegate = self;
            bind->mode = HouseRoomNumber;
            [self.navigationController showViewController:bind sender:nil];
        }
            break;
        case HouseRoomNumber:{
            
            [city selectRoom:index];

//            self.tabBarController.tabBar.hidden = NO;

//            XWJTabViewController *tab = [[XWJTabViewController alloc] init];
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            window.rootViewController = tab;
            
//                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                        [UIApplication sharedApplication].keyWindow.rootViewController = [story instantiateInitialViewController];
//                XWJBingHouseViewController *bind = [[XWJBingHouseViewController alloc] initWithNibName:@"XWJBingHouseViewController" bundle:nil];
            
//            self.isBind = TRUE;
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
            [self.navigationController showViewController:[story instantiateViewControllerWithIdentifier:@"bindhouse1"] sender:nil];
            
        }
            break;
        default:
            break;
    }
}

-(void)getDetailAD:(NSInteger)index{
    NSString *url = GETDETAILAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[[self.notices objectAtIndex:index] valueForKey:@"id"]  forKey:@"id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];

    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
            XWJActivityViewController * acti = [storyboard instantiateViewControllerWithIdentifier:@"activityDetail"];
            
//            XWJADViewController *acti =[[XWJADViewController alloc] init];
            acti.dic  = [dic objectForKey:@"data"];
            acti.type = [acti.dic valueForKey:@"Types"];
            [self.navigationController showViewController:acti sender:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    NSLog(@"you clicked image in %@ at index: %ld", bannerView, (long)index);
    if (bannerView.titles) {
        
        [self getDetailAD:index];
        

//        XWJNoticeViewController *notice = [self.storyboard instantiateViewControllerWithIdentifier:@"noticeController"];
        
//        [self.navigationController showViewController:notice sender:nil];
        NSLog(@"notice click");
    }else{
        
        
//#define KEY_AD_TITLE @"Title"
//#define KEY_AD_TIME  @"addTime"
//#define KEY_AD_CONTENT @"description"
//#define KEY_AD_CLICKCOUNT @"ClickCount"
//#define KEY_AD_URL @"content"
//#define KEY_AD_ID  @"id"
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
//        XWJActivityViewController * acti = [storyboard instantiateViewControllerWithIdentifier:@"activityDetail"];
//        NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
//        [dic setValue:[[self.shows objectAtIndex:index] objectForKey:@"Content"] forKey:KEY_AD_TITLE];
//        [dic setValue:[[self.shows objectAtIndex:index] objectForKey:@"Description"] forKey:KEY_AD_CONTENT];
//        
//        [dic setValue:[[self.shows objectAtIndex:index] objectForKey:@"url"] forKey:KEY_AD_URL];
//        [dic setValue:[[self.shows objectAtIndex:index] objectForKey:@"Types"] forKey:@"Types"];
//        [dic setValue:[[self.shows objectAtIndex:index] objectForKey:@"ID"] forKey:KEY_AD_ID];

        XWJADViewController *acti= [[XWJADViewController alloc] init];
        acti.dic  = [self.shows objectAtIndex:index];
//        acti.type = [acti.dic valueForKey:@"Types"];
        
        [self.navigationController showViewController:acti sender:nil];
    }
}

-(void)setNavigationBar2{
    

        NSString *ti = [[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoqu"];
    if (ti) {
        
        self.navigationItem.title = ti;
    }else
        self.navigationItem.title = @"依云小镇";
    
    
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
    
}


#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    collectionCellHeight = self.collectionView.frame.size.height/COLLECTION_NUMSECTIONS-1;
//    collectionCellWidth = self.collectionView.frame.size.width/COLLECTION_NUMITEMS-1;
    return COLLECTION_NUMSECTIONS;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    collectionCellHeight = self.collectionView.frame.size.height/COLLECTION_NUMSECTIONS-1;
    collectionCellWidth = self.collectionView.frame.size.width/COLLECTION_NUMITEMS-1;

    return COLLECTION_NUMITEMS;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.section == 2) {
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier1 forIndexPath:indexPath];
        
        NSArray *array1 = [NSArray arrayWithObjects: @"house0",@"house1",@"house2",nil];

        for (int i= 0; i<3; i++) {
            UIButton *button = (UIButton *)[cell viewWithTag:i+1];
            
            [button setBackgroundImage:[UIImage imageNamed:[array1 objectAtIndex:i]] forState:UIControlStateNormal];
            button.titleLabel.text = @"2";
            [button addTarget:self action:@selector(colleciotnCellclick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }else if (indexPath.section==0){
        //重用cell
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
      
        NSArray *array1 = [NSArray arrayWithObjects:@"homess",@"homejz", @"homexy",@"homexh",@"homedg",nil];
        NSArray *array2 = [NSArray arrayWithObjects:@"shangjia0",@"shangjia1",@"shangjia2", @"shangjia3",@"shangjia4",nil];
        for (int i= 0; i<5; i++) {
            UIButton *button = (UIButton *)[cell viewWithTag:i+1];
            if (indexPath.section == 0) {
                [button setBackgroundImage:[UIImage imageNamed:[array1 objectAtIndex:i]] forState:UIControlStateNormal];
                button.titleLabel.text = @"0";

            }else{
                [button setBackgroundImage:[UIImage imageNamed:[array2 objectAtIndex:i]] forState:UIControlStateNormal];
                    button.titleLabel.text = @"1";

            }
            [button addTarget:self action:@selector(colleciotnCellclick:) forControlEvents:UIControlEventTouchUpInside];

        }

    }else{
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier4 forIndexPath:indexPath];
        
//        NSArray *array1 = [NSArray arrayWithObjects:@"homess",@"homejz", @"homexy",@"homexh",@"homedg",nil];
//        NSArray *array2 = [NSArray arrayWithObjects:@"shangjia0",@"shangjia1",@"shangjia2", @"shangjia3",@"shangjia4",nil];
        for (int i= 0; i<5; i++) {
            UIView *view = (UIView *)[cell viewWithTag:i+1];
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer* singleRecognizer;
            singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shangchengclick:)];
            //点击的次数
            singleRecognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:singleRecognizer];
        }
    }
    return cell;
    
}

-(void)shangchengclick:(UITapGestureRecognizer *)ges{
    [self.tabBarController setSelectedIndex:2];

//    switch (view.tag) {
//        case 1:
//        {
//            
//        }
//            break;
//        case 2:
//        {
//            
//        }
//            break;
//        case 3:
//        {
//            
//        }
//            break;
//        case 4:
//        {
//            
//        }
//            break;
//        case 5:
//        {
//            
//        }
//            break;
//        default:
//            break;
//    }
    
}
-(void)colleciotnCellclick:(UIButton *)btn{
//    NSLog(@"%p %@",__FUNCTION__,btn);
    NSLog(@"title %@ tag %lu",btn.titleLabel.text,btn.tag);
    
    int section = [btn.titleLabel.text intValue];
    switch (section) {
        case 0:
        {
            XWJShuoListViewController * list= [[XWJShuoListViewController alloc] init];
//            list.dic = [self.thumb objectAtIndex:index-1000];
            list.dic = [self.shuoArr objectAtIndex:btn.tag-1];
            [self.navigationController showViewController:list sender:self];
            
//            [self.tabBarController setSelectedIndex:2];
        }
            break;
        case 1:
        {
            [self.tabBarController setSelectedIndex:2];
            
//            [self.navigationController showViewController:[[UIStoryboard storyboardWithName:@"XWJShangchengStoryboard" bundle:nil] instantiateInitialViewController]sender:nil];
        }
            break;
        case 2:{
            
            UIStoryboard * story = [UIStoryboard storyboardWithName:@"XWJZFStoryboard" bundle:nil];
            switch (btn.tag) {
                case 1:
                {
                    XWJZFViewController *view = [story instantiateInitialViewController];
                    view.type = 0;
                    [self.navigationController showViewController:view sender:nil];
                }
                    break;
                case 2:{
                    XWJZFViewController *view = [story instantiateInitialViewController];
                    view.type = 1;
                    [self.navigationController showViewController:view sender:nil];
                }
                    break;
                case 3:{
                    XWJZFViewController *view = [story instantiateInitialViewController];
                    view.type = 2;
                    [self.navigationController showViewController:view sender:nil];
                }
                    break;
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }

 
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
//        reuseIdentifier = kfooterIdentifier;
    }else{
        reuseIdentifier = kheaderIdentifier;
    }
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[view viewWithTag:1];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        label.text = footer[indexPath.section];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        view.backgroundColor = [UIColor lightGrayColor];
        label.text = footer[indexPath.section];
    }
    
    UIButton *button  = (UIButton*)[view viewWithTag:2];
    button.tag = 100+indexPath.section;
    [button addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

-(void)headerClick:(UIButton *)btn{
    NSInteger index =btn.tag-100;
    
    if (index ==0) {
        XWJShangmenViewController *shangmen  =[[XWJShangmenViewController alloc] init];
        [self.navigationController showViewController:shangmen sender:nil];
    }else if(index == 1){
        [self.tabBarController setSelectedIndex:2];
    }
    NSLog(@"header %ld ",index);
    
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width,height;
    width = self.collectionView.frame.size.width;
//    height = (self.collectionView.frame.size.height - HEADER_HEIGHT*COLLECTION_NUMSECTIONS)/3;
    height = CELL_HEIGHT;
//        if (indexPath.item == 0) {
//            return CGSizeMake(width, height);
//        }
//        return CGSizeMake(width/2, height/2);
    
    return CGSizeMake(width, height);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);//分别为上、左、下、右
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={self.view.bounds.size.width,HEADER_HEIGHT};
    return size;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={0,0};
    return size;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%p %@",__FUNCTION__,indexPath);
//    self.section = indexPath.section;
//
//    switch (indexPath.section) {
//        case 0:
//            break;
//            
//        default:
//            break;
//    }
    
//    UIViewController * con = [[XWJMyMessageController alloc] init];
//    [self.navigationController showViewController:con sender:nil];
//        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//        [cell setBackgroundColor:[UIColor greenColor]];
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor clearColor]];

}
-(void)showList{
//    UIStoryboard *wuyStory = [UIStoryboard storyboardWithName:@"WuyeStoryboard" bundle:nil];
//    [self.navigationController showViewController:[wuyStory instantiateInitialViewController] sender:nil];
    UIViewController * con = [[XWJMyMessageController alloc] init];
    [self.navigationController showViewController:con sender:nil];
}

@end
