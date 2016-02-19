//
//  XWJNewHouseDetailViewController.m
//  XWJ
//
//  Created by Sun on 15/12/12.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJNewHouseDetailViewController.h"
#import "XWJNewHouseInfoViewController.h"
#import "XWJAccount.h"
#import "XWJHouseMapController.h"
#import "XWJHouseInfoCell.h"
#import "LCBannerView.h"
#import "XWJWebViewController.h"
#import "UMSocial.h"

@interface XWJNewHouseDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LCBannerViewDelegate,UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *houseImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (nonatomic) NSMutableArray *tableData1;
@property NSArray *URLs;
@property (weak, nonatomic) IBOutlet UIButton *btnShouCang;

@property (nonatomic) NSMutableArray *tableData;
@property NSMutableArray *photos;
@property NSMutableArray *buts;
@property CGFloat height;

@property(nonatomic,copy)NSString* shareImageStr;
@property(nonatomic,copy)NSString* sharecontStr;
@property(nonatomic,copy)NSString* shareUrl;

@end

@implementation XWJNewHouseDetailViewController
@synthesize  URLs;

#define TAG 100
- (void)viewDidLoad {
    [super viewDidLoad];
    
 self.tableData = [NSMutableArray array];
//    初始化楼盘信息的数组
    
    self.tableData1 = [NSMutableArray arrayWithObjects:@"开       盘",@"地       址",@"状       态",@"优       惠",@"特       点",@"最新动态",@"周边配套",@"详细信息", nil];

    self.photos = [NSMutableArray array];
    
//    [self.tableData addObjectsFromArray:[NSArray arrayWithObjects:@"开盘 2015-5-1",@"地址 青岛市崂山区崂山路25号",@"状态 在售",@"优惠 交5000可98折 ", nil]];

    self.sharecontStr  = @"";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.textColor = XWJGREENCOLOR;
    label.text = @"楼盘信息";
    [view addSubview:label];
    self.infoTableView.tableHeaderView = view;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self getXinFangdetail];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

}
#pragma mark - 分享按钮响应
- (IBAction)share:(id)sender {
    CLog(@"分享");
    UIImageView* temIV = [[UIImageView alloc] init];
    
    [temIV sd_setImageWithURL:[NSURL URLWithString:self.shareImageStr] placeholderImage:[UIImage imageNamed:@"devAdv_default"]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56938a23e0f55aac1d001cb6"
                                      shareText:self.sharecontStr
                                     shareImage:temIV.image
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
    
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"海信地产，值得信赖";

    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat: @"http://admin.hisenseplus.com/win/t_cm_roomhuxing.aspx?id=%@",[self.dic valueForKey:@"id"]];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =[NSString stringWithFormat:@"http://admin.hisenseplus.com/win/t_cm_roomhuxing.aspx?id=%@",[self.dic valueForKey:@"id"]];
}

#pragma mark - //实现回调方法（可选)
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        CLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

-(void)shouCang{
    NSString *url = GETXINFANGSHOUCANG_URL;
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        /*
         userid	登录用户id	String
         type	类型（1：买新房，2：二手房，3：出租房）	String,1,2,3
         lpId	楼盘id	String
         */
        XWJAccount *account = [XWJAccount instance];
        [dict setValue:[self.dic valueForKey:@"id"]  forKey:@"lpId"];
        [dict setValue:@"1"  forKey:@"type"];
        [dict setValue: account.uid  forKey:@"userid"];
//    NSString *collect = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"isCollected"]];
    
    if (self.btnShouCang.selected) {
        [dict setValue:@"1" forKey:@"isCollect"];
    }else{
        [dict setValue:@"0" forKey:@"isCollect"];
    }
//    if ([collect isEqualToString:@"0"]) {
//        [dict setValue:@"1" forKey:@"isCollect"];
//    }else{
//        [dict setValue:@"0" forKey:@"isCollect"];
//    }
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            CLog(@"%s success ",__FUNCTION__);
            
            if(responseObject){
                NSDictionary *dict = (NSDictionary *)responseObject;
                CLog(@"dic %@",dict);
                NSNumber *res =[dict objectForKey:@"result"];
                if ([res intValue] == 1) {
                    
                    NSString *errCode = [dict objectForKey:@"errorCode"];
                    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alertview.delegate = self;
                    [alertview show];
                    
//                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CLog(@"%s fail %@",__FUNCTION__,error);
            
        }];
    
}


- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    XWJWebViewController *web = [[XWJWebViewController alloc] init];
    
    web.url = URLs[index];
    [self.navigationController  showViewController:web sender:self];
}

-(void)getXinFangdetail{
    NSString *url = GETXINFANGDETAIL_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[self.dic valueForKey:@"id"]  forKey:@"areaId"];
    [dict setValue:[XWJAccount instance].uid forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *resdic = (NSDictionary *)responseObject;
            
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            self.dic  = [resdic objectForKey:@"house"]==[NSNull null]?nil:[resdic objectForKey:@"house"];
            [self.photos addObjectsFromArray:[resdic objectForKey:@"photo"]];
            self.tableData = [NSMutableArray array];
            [self.tableData addObject:[NSString  stringWithFormat:@"%@",[self.dic objectForKey:@"kpsj"]==[NSNull null]?@"":[self.dic objectForKey:@"kpsj"]]] ;
            [self.tableData addObject:[NSString  stringWithFormat:@"%@%@%@",[self.dic objectForKey:@"cityName"],[self.dic objectForKey:@"quyu"],[self.dic objectForKey:@"weiZhi"]]] ;
            [self.tableData addObject:[NSString  stringWithFormat:@"%@",[self.dic objectForKey:@"zt"]==[NSNull null]?@"":[self.dic objectForKey:@"zt"]]] ;
            [self.tableData addObject:[NSString  stringWithFormat:@"%@",[self.dic objectForKey:@"yhxx"]==[NSNull null]?@"":[self.dic objectForKey:@"yhxx"]]] ;
//            特点、最新动态、周边配套和详细信息
            [self.tableData addObject:[NSString  stringWithFormat:@"%@",[self.dic objectForKey:@"td"]==[NSNull null]?@"":[self.dic objectForKey:@"td"]]] ;
            [self.tableData addObject:[NSString  stringWithFormat:@"%@",[self.dic objectForKey:@"zxdt"]==[NSNull null]?@"":[self.dic objectForKey:@"zxdt"]]] ;
            [self.tableData addObject:[NSString  stringWithFormat:@"%@",[self.dic objectForKey:@"zbpt"]==[NSNull null]?@"":[self.dic objectForKey:@"zbpt"]]] ;
            [self.tableData addObject:[NSString  stringWithFormat:@"%@",[self.dic objectForKey:@"xxxx"]==[NSNull null]?@"":[self.dic objectForKey:@"xxxx"]]] ;

            
            self.nameLabel.text = [self.dic objectForKey:@"lpmc"]==[NSNull null]?@"":[self.dic objectForKey:@"lpmc"];
            self.sharecontStr = self.nameLabel.text;
            self.moneyLabel.text = [NSString stringWithFormat:@"开盘 %@",[self.dic objectForKey:@"jiage"]== [NSNull null ]?@"":[self.dic objectForKey:@"jiage"]];
//            [self.locationBtn setTitle:[NSString  stringWithFormat:@"地址 %@%@%@",[self.dic objectForKey:@"cityName"],[self.dic objectForKey:@"quyu"],[self.dic objectForKey:@"weiZhi"]] forState:UIControlStateNormal];
            [self.timeBtn setTitle:[self.dic objectForKey:@"kpsj"]==[NSNull null]?@"": [self.dic objectForKey:@"kpsj"]forState:UIControlStateNormal];
            
            NSString *houseurl;
            if ([self.dic valueForKey:@"zst"] != [NSNull null]) {
                houseurl = [self.dic  valueForKey:@"zst"];
            }else{
                houseurl = @"";
            }
            
            NSString *collect = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"isCollected"]==[NSNull null]?@"":[self.dic objectForKey:@"isCollected"]];

            if ([collect isEqualToString:@"0"]) {
                self.btnShouCang.selected = NO;
            }else{
                self.btnShouCang.selected = YES;
            }
            
            URLs = [houseurl componentsSeparatedByString:@","];
            [self.houseImg addSubview:({
                
                float time = 3.0f;
                if (URLs.count==1) {
                    time = MAXFLOAT;
                }
                self.shareImageStr = [URLs objectAtIndex:0];
                LCBannerView *bannerView = [[LCBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                                          self.houseImg.bounds.size.height)
                                            
                                                                      delegate:self
                                                                     imageURLs:URLs
                                                              placeholderImage:nil
                                                                 timerInterval:time
                                                 currentPageIndicatorTintColor:XWJGREENCOLOR
                                                        pageIndicatorTintColor:[UIColor whiteColor]
                                                                              :UIViewContentModeScaleAspectFit];
                bannerView;
            })];
//            [self.houseImg sd_setImageWithURL:[NSURL URLWithString:houseurl] placeholderImage:[UIImage imageNamed:@"newhouse"]];
            
            self.infoTableView.frame = CGRectMake(self.infoTableView.frame.origin.x, self.infoTableView.frame.origin.y, self.infoTableView.frame.size.width, self.height);

            [self.infoTableView reloadData];
//            self.infoTableView.contentSize = CGSizeMake(0, 30*self.tableData.count+60);
            NSInteger count = self.photos.count;
            CGFloat width = self.view.bounds.size.width/3;
            CGFloat height = self.scrollView.bounds.size.height;
            self.scrollView.contentSize = CGSizeMake((width+5)*count+10, height);
//            if(count>6)
//                count = 6;
            for (int i=0; i<count; i++) {
                UIImageView *button = [[UIImageView alloc ] init];
                button.frame = CGRectMake(5+(width+5)*i, 0, width, height);
                button.tag = TAG+i;
                button.userInteractionEnabled = YES;

                NSString *url;
                if ([[self.photos objectAtIndex:i] valueForKey:@"hxt"] != [NSNull null]) {
                    url = [[self.photos objectAtIndex:i] valueForKey:@"hxt"];
                }else{
                    url = @"";
                }

                [button sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
                UITapGestureRecognizer* singleRecognizer;
                singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
                //点击的次数
                singleRecognizer.numberOfTapsRequired = 1;
                [button addGestureRecognizer:singleRecognizer];

                button.backgroundColor = [UIColor whiteColor];

                [self.scrollView addSubview:button];
            }
            self.infoTableView.frame = CGRectMake(self.infoTableView.frame.origin.x, self.infoTableView.frame.origin.y, self.infoTableView.frame.size.width, self.height+40);
            [self.infoTableView setNeedsDisplay];
            //            [self.houseArr addObjectsFromArray:arr];
                        [self.infoTableView reloadData];
            self.backScrollView.contentSize = CGSizeMake(0, self.infoTableView.frame.origin.y+self.infoTableView.bounds.size.height+100);
//                        CLog(@"dic %@",resdic);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
//    NSInteger index = iv.tag -TAG;
    UIImageView *iv = (UIImageView *)recognizer.view;
//    NSInteger index=  recognizer.view.tag;
  XWJNewHouseInfoViewController  *vie = [self.storyboard instantiateViewControllerWithIdentifier:@"newhouseinfo"];
//    vie.dic = self.dic;
    vie.dic = [NSMutableDictionary dictionary];
    [vie.dic setDictionary:self.dic];
    [vie.dic setObject:iv.image forKey:@"image"];
    vie.urls = self.photos;
    
    [self.navigationController showViewController:vie sender:nil];
    CLog(@"click ");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text =  [self.tableData objectAtIndex:indexPath.row];

   CGSize size =   [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    self.height = self.height + size.height;
    return size.height+10;
//    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJHouseInfoCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cztablecell"];
    if (!cell) {
        cell = [[XWJHouseInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cztablecell"];
    }
    // Configure the cell...
//    cell.detailTextLabel.text = [self.tableData objectAtIndex:indexPath.row];

    cell.label1.text = [self.tableData1 objectAtIndex:indexPath.row];

    cell.label2.text = [self.tableData objectAtIndex:indexPath.row];



    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)yuyuekanfang:(UIButton *)sender {
    
    NSString *tel = [self.dic objectForKey:@"lxdh"];
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
- (IBAction)shoucang:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self shouCang];
}
- (IBAction)ditu:(UIButton *)sender {
    
    XWJHouseMapController *map = [self.storyboard instantiateViewControllerWithIdentifier:@"housemap"];
    NSString *loc  = [self.dic objectForKey:@"gps"];
//    loc = @"36.120";
    if (![loc isEqual:[NSNull null]]) {
        map.lati = [[loc componentsSeparatedByString:@"."][0] floatValue];
        map.lon = [[loc componentsSeparatedByString:@"."][1] floatValue];
        [self.navigationController showViewController:map sender:nil];
    }
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
