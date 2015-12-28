//
//  XWJSPDetailViewController.m
//  XWJ
//
//  Created by Sun on 15/12/26.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJSPDetailViewController.h"
#import "LCBannerView.h"
#import "XWJSPDetailTableViewCell.h"
#import "XWJAccount.h"
#import "XWJUtil.h"
#import "ProgressHUD/ProgressHUD.h"
#import "XWJYueLineViewController.h"
#import "XWJYouHuiViewController.h"
@interface XWJSPDetailViewController ()<LCBannerViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property UIScrollView *scrollView;

@property UILabel *titleLabel;
@property UILabel *youhuLabel;
@property UILabel *shichangjiaLabel;
@property UILabel *xiaoliangLabel;
@property UIView *adView;
@property UIImageView *shangpinImg;
@property UITableView *tableView;
@property UIButton * dianpuBtn;
@property UILabel *headerLabel;
@property NSDictionary *goodsDic;
@property NSArray *comments ;
@property UIButton *button;

@property NSMutableArray *btn;

@end

#define PADDINGTOP 64
#define HEIGHT_VIEW1 250
#define HEIGHT_VIEW2 400
#define HEIGHT_VIEW3 250
#define HEIGHT_VIEW4 250


@implementation XWJSPDetailViewController
@synthesize scrollView,titleLabel,youhuLabel,shichangjiaLabel,xiaoliangLabel,adView,dianpuBtn;
@synthesize shangpinImg,tableView,headerLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商品详情";
    
    scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];

    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(0, HEIGHT_VIEW1+HEIGHT_VIEW2+HEIGHT_VIEW3+20);
    [self addView];
    [self addView2];
    [self addView3];
    [self getDetail];
    
    tableView.dataSource =self;
    tableView.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"shoucang"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}
-(void)shoucang{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)addView3{
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW1+HEIGHT_VIEW2+10, SCREEN_SIZE.width, HEIGHT_VIEW3)];
    
    tableView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:tableView];
}
-(void)addView2{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW1+5, SCREEN_SIZE.width, HEIGHT_VIEW2)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    shangpinImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 25, SCREEN_SIZE.width-4, HEIGHT_VIEW2)];

    label.text = @"商品介绍";
    label.textColor = XWJGREENCOLOR;
    view.backgroundColor = [UIColor whiteColor];

    [view addSubview:label];
    [view addSubview:shangpinImg];
    [scrollView addSubview:view];
}
-(void)addView{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, HEIGHT_VIEW1)];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, SCREEN_SIZE.width, 20)];
    adView  = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.bounds.size.height, SCREEN_SIZE.width, 150)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, adView.frame.origin.y+adView.bounds.size.height, 120, 30)];

    youhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width, adView.frame.origin.y+adView.bounds.size.height, SCREEN_SIZE.width, 30)];
    shichangjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, label.frame.origin.y+label.bounds.size.height, 100, 30)];
    xiaoliangLabel = [[UILabel alloc] initWithFrame:CGRectMake(150,label.frame.origin.y+label.bounds.size.height, 150, 30)];
    
    shichangjiaLabel.font = [UIFont systemFontOfSize:14.0];
    xiaoliangLabel.font = [UIFont systemFontOfSize:14.0];
    
    dianpuBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    dianpuBtn.frame = CGRectMake(SCREEN_SIZE.width-80,adView.frame.origin.y+adView.bounds.size.height, 80, 40);
    [dianpuBtn setTitle:@"店铺" forState:UIControlStateNormal];
    [dianpuBtn setTitleColor:XWJGRAYCOLOR forState:UIControlStateNormal];
    youhuLabel.textColor = XWJColor(140, 0, 0);
    shichangjiaLabel.textColor = XWJGRAYCOLOR;
    xiaoliangLabel.textColor = XWJGRAYCOLOR;
    view.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:label];
    [view addSubview:youhuLabel];
    [view addSubview:shichangjiaLabel];
    [view addSubview:xiaoliangLabel];
    [view addSubview:adView];
//    [view addSubview:dianpuBtn];
    [view addSubview:titleLabel];
    youhuLabel.text = @"￥ 80";
    shichangjiaLabel.text = @"市场价 100";
    xiaoliangLabel.text = @"销量： 100";
    titleLabel.text = @"农夫山泉 天然饮用水";
    label.text = @"业主专属价：";

    [scrollView addSubview:view];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 80, 20)];
    label.textColor = XWJGREENCOLOR;
    label.text  = @"商品评论";
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 2, 200, 20)];
    headerLabel.textColor = XWJGRAYCOLOR;
    headerLabel.text = @"人参与评论";
    [view addSubview:headerLabel];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)taView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index path %ld",(long)indexPath.row);
    XWJSPDetailTableViewCell *cell;
    
    cell = [taView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJSPDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    /*
     "default_image" = "http://www.hisenseplus.com/ecmall/data/files/store_4/goods_32/small_201512191643527793.jpg";
     "goods_id" = 3;
     "goods_name" = "\U519c\U592b\U5c71\U6cc9\U5929\U7136\U5927\U6876\U6c341L";
     "old_price" = 0;
     price = 14;
     sales = 0;
     stock = 98;
     views = 10;
     */
    //    cell.label1.text = [self.tabledata ];
    NSArray *arr = self.comments;

    if(arr&&arr.count>0){
        cell.label1.text =     [[arr objectAtIndex:indexPath.row] objectForKey:@"buyer_name"];
        cell.label2.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"comment"];
        cell.timeLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"evaluation_time"];

        if ([[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"]!=[NSNull null]) {
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"]] ];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)addCar{
    NSString *url = ADDCAR_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"store_id"]] forKey:@"storeId"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"goods_id"]] forKey:@"goodsId"];
    [dict setValue:@"1" forKey:@"counts"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"price"]] forKey:@"unitPrice"];
    [dict setValue:@"0" forKey:@"flg"];//0加入购物车 1修改
    
    /*
     {"account":"177777777777","storeId":"4","goodsId":"4","counts":"1","unitPrice":"24","flg":"1"}
     */
    NSString * cart = [XWJUtil dataTOjsonString:dict];
    NSDictionary * carDic = [NSDictionary dictionaryWithObject:cart forKey:@"cart"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:carDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];
      
            if ([nu integerValue]== 1) {
                [ProgressHUD showSuccess:errCode];
            }else{
                [ProgressHUD showError:errCode];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getDetail{
    NSString *url = GETGOODDETAIL_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:self.goods_id  forKey:@"goods_id"];
    /*
     
     store_id	商户id	String
     zx	最新排序字段	String,0正序1,倒序
     xl	销量排序字段	String,0正序1,倒序
     jg	价格排序字段	String,0正序1,倒序
     pageindex	第几页	String,从0开始
     countperpage	每页几条	String
     */
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            
            self.goodsDic = [dic objectForKey:@"goods"];
            self.comments = [dic objectForKey:@"comments"];
            
            [self.tableView reloadData];
            self.tableView.contentSize = CGSizeMake(0, 100*self.goodsDic.count+150);
            //            self.adArr = [dic objectForKey:@"ad"];
            //            self.thumb = [dic objectForKey:@"thumb"];
        
            [self updateView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)updateView{
    
    
    /*
     goods =     {
     "default_image" = "http://www.hisenseplus.com/ecmall/data/files/store_4/goods_106/small_201512191645061221.jpg";
     "goods_id" = 4;
     "goods_img" = "http://www.hisenseplus.com/ecmall/data/files/store_4/goods_106/201512191645061221.jpg";
     "goods_img_small" = "http://www.hisenseplus.com/ecmall/data/files/store_4/goods_106/small_201512191645061221.jpg";
     "goods_name" = "\U519c\U592b\U5c71\U6cc9 \U5929\U7136\U996e\U7528\U6c344L*4\U6876 \U6574\U7bb1";
     "old_price" = 0;
     "order_type" = "\U62e8\U6253\U7535\U8bdd,\U5728\U7ebf\U8ba2\U8d2d";
     policy = "";
     price = 24;
     sales = 0;
     stock = 97;
     "store_id" = 4;
     tel = 18712312323;
     views = 9;
     };
     */
    
//    if(self.comments&&self.comments.count>0)
    headerLabel.text = [NSString stringWithFormat:@"(%lu人参与评论)",(unsigned long)self.comments.count];
    youhuLabel.text = [NSString stringWithFormat:@"￥ %@",[self.goodsDic objectForKey:@"price"]];
    shichangjiaLabel.text = [NSString stringWithFormat:@"市场价: ￥%@",[self.goodsDic objectForKey:@"old_price"] ];
    xiaoliangLabel.text = [NSString stringWithFormat:@"销量：%@件",[self.goodsDic objectForKey:@"sales"]];
    titleLabel.text = [self.goodsDic objectForKey:@"goods_name"];
    
    [self addBottomBtn];
    NSString * prop = [self.goodsDic objectForKey:@"goods_img"]==[NSNull null]?nil:[self.goodsDic objectForKey:@"goods_img"] ;
    
    if (prop&&![prop isEqualToString:@""]) {
        NSArray *imgs = [prop componentsSeparatedByString:@","];
        
//        NSMutableArray * imgs  = [NSMutableArray array];
//        [imgs addObject:[img objectAtIndex:0]];
//        [imgs addObject:[img objectAtIndex:0]];
//        [imgs addObject:[img objectAtIndex:0]];

        if (imgs&&imgs.count>0) {
            UIView * view  =shangpinImg.superview;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, HEIGHT_VIEW2*imgs.count);
            [shangpinImg sd_setImageWithURL:[NSURL URLWithString:[imgs objectAtIndex:0]]];

            for (int i =1; i<imgs.count; i++) {
                
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 25+HEIGHT_VIEW2*i, SCREEN_SIZE.width-4, HEIGHT_VIEW2)];
                [img sd_setImageWithURL:[NSURL URLWithString:[imgs objectAtIndex:i]]];
                [view addSubview:img];
            }
            
            tableView.frame = CGRectMake(tableView.frame.origin.x, HEIGHT_VIEW1+view.frame.size.height+5, tableView.frame.size.width, HEIGHT_VIEW3);
            [tableView reloadData];
            scrollView.contentSize  = CGSizeMake(0, HEIGHT_VIEW1+HEIGHT_VIEW3+view.frame.size.height);
        }
    }
    
    
    
    NSMutableArray *URLs = [NSMutableArray array];
    [URLs addObject:[self.goodsDic objectForKey:@"default_image"]];
    
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

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)addBottomBtn{
    self.btn = [NSMutableArray array];

    NSString *type = [self.goodsDic objectForKey:@"order_type"];
    
    if (type) {
        

        NSArray * typeArr = [type componentsSeparatedByString:@","];
    
        NSMutableArray * typeArr2 = [NSMutableArray array];
//        [typeArr2 addObject:typeArr];
        for (NSString *s in typeArr) {
            if ([s isEqualToString:@"立即购买"]||[s isEqualToString:@"在线订购"]) {
                [typeArr2 addObject:@""];
                [typeArr2 addObject:@"加入购物车"];
                [typeArr2 addObject:@"立即购买"];
            }else
            [typeArr2 addObject:s];
        }
        
        if (typeArr2&&typeArr2.count>0) {
            
            NSInteger count =typeArr2.count;
            NSArray * title = typeArr2;
            CGFloat width = self.view.bounds.size.width/count;
            CGFloat height = 60;
            
            for (int i=0; i<count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake((width+1)*i, SCREEN_SIZE.height-height, width, height);
                button.tag = i;
                
                [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
//                [button setBackgroundImage:[UIImage imageNamed:@"shuoselect"] forState:UIControlStateSelected];
//                [button setBackgroundImage:[UIImage imageNamed:@"shuonormal"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setBackgroundColor:XWJGREENCOLOR];
//                [button setTitleColor:XWJColor(77, 78, 79) forState:UIControlStateNormal];
                [button setTitleColor:XWJGREENCOLOR forState:UIControlStateSelected];
                
                [button addTarget:self action:@selector(typeclick:) forControlEvents:UIControlEventTouchUpInside];
                [self.btn addObject:button];
                [self.view addSubview:button];
            }
        }

    }


}

-(void)typeclick:(UIButton *)butn{

    if ([butn.titleLabel.text isEqualToString:@"拨打电话"]) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[self.goodsDic objectForKey:@"tel"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if([butn.titleLabel.text isEqualToString:@"加入购物车"]){
        [self addCar];
//        UIStoryboard *car  = [UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil];
    }else if([butn.titleLabel.text isEqualToString:@"在线预约"]){
        UIStoryboard *car  = [UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil];
        XWJYueLineViewController *view = [car instantiateViewControllerWithIdentifier:@"yuyueline"];
        view.goodid = [self.goodsDic objectForKey:@"goods_id"];
        view.stordid = [self.goodsDic objectForKey:@"store_id"];
        view.goodname = [self.goodsDic objectForKey:@"goods_name"];
        [self.navigationController showViewController:view sender:nil];
        
    }else if([butn.titleLabel.text isEqualToString:@"优惠政策"]){
        XWJYouHuiViewController *con = [[XWJYouHuiViewController alloc] init];
        con.zhengce = [self.goodsDic objectForKey:@"policy"];
        [self.navigationController showViewController:con sender:nil];

    }else if([butn.titleLabel.text isEqualToString:@"立即购买"]){
//        UIStoryboard *car  = [UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil];
//        XWJYueLineViewController *view = [car instantiateViewControllerWithIdentifier:@"yuyueline"];
//        [self.navigationController showViewController:view sender:nil];
    }
    
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
