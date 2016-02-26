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
#import "XWJSPGuigeViewController.h"
#import "XWJSPinfoViewController.h"
#import "XWJJiesuanViewController.h"
#import "XWJSPCommentController.h"
#import "XWJWebViewController.h"
#import "XWJImagesController.h"
@interface XWJSPDetailViewController ()<LCBannerViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property UIScrollView *scrollView;

@property UILabel *titleLabel;
@property UILabel *youhuLabel;
@property UILabel *shichangjiaLabel;
@property UILabel *xiaoliangLabel;
@property UILabel *contentLabel;
@property UIView *adView;
@property UIImageView *shangpinImg;
@property UITableView *tableView;
@property UIButton * dianpuBtn;
@property UILabel *headerLabel;
@property NSDictionary *goodsDic;
@property NSArray *comments ;
@property UIButton *button;
@property UILabel *gouwucheLabel;
@property NSMutableArray *btn;
@property NSString * gouwuCheCounts;
@property NSString *commentCount;
@property BOOL isLoad;
@end

#define PADDINGTOP 64
#define HEIGHT_VIEW1 (SCREEN_SIZE.width+60)
//#define HEIGHT_VIEW2 400
#define HEIGHT_VIEW3 250
#define HEIGHT_VIEW2 40

#define HEIGHT_VIEW4 250


@implementation XWJSPDetailViewController
@synthesize scrollView,titleLabel,youhuLabel,shichangjiaLabel,xiaoliangLabel,adView,dianpuBtn;
@synthesize shangpinImg,tableView,headerLabel,gouwucheLabel,contentLabel,isLoad;
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
    [self addView4];
    
    tableView.dataSource =self;
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"XWJSPDetail" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIImage *image = [UIImage imageNamed:@"shoucang"];
    UIImage *image2 = [UIImage imageNamed:@"quxiaoShoucang"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(shoucang:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:image2 forState:UIControlStateSelected];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    //    self.navigationItem.rightBarButtonItem = barButtonItem;
}
-(void)shoucang:(UIButton *)btn{
    btn.selected = !btn.selected;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self getDetail];

}
-(void)addView4{
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW1+HEIGHT_VIEW2+HEIGHT_VIEW2+12, SCREEN_SIZE.width, HEIGHT_VIEW3)];
    
    tableView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:tableView];
}
-(void)addView2{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW1+10, SCREEN_SIZE.width, HEIGHT_VIEW2)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, (HEIGHT_VIEW2-20)/2, 100, 20)];
    shangpinImg = [[UIImageView alloc] initWithFrame:CGRectMake(80, 5, SCREEN_SIZE.width-4-160, HEIGHT_VIEW2)];
    label.text = @"商品信息";
    //    label.textColor = XWJGREENCOLOR;
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_SIZE.width-110, (HEIGHT_VIEW2-30)/2, 100, 30);
    [btn setImage:[UIImage imageNamed:@"next2"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(shangpinClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag= 0;
    [view addSubview:btn];
    [view addSubview:label];
    //    [view addSubview:shangpinImg];
    [scrollView addSubview:view];
}
-(void)addView3{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW1+HEIGHT_VIEW2+11, SCREEN_SIZE.width, HEIGHT_VIEW2)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, (HEIGHT_VIEW2-20)/2, 100, 20)];
    label.text = @"商品规格";
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_SIZE.width-110, (HEIGHT_VIEW2-30)/2, 100, 30);
    [btn setImage:[UIImage imageNamed:@"next2"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(shangpinClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag= 1;
    [view addSubview:btn];
    [view addSubview:label];
    [scrollView addSubview:view];
}

-(void)shangpinClick:(UIButton *)btn{
    
    NSInteger tag  = btn.tag;
    switch (tag) {
        case 0:
        {
            XWJSPinfoViewController *view  = [[XWJSPinfoViewController alloc ] init];
            
            NSString * prop = [self.goodsDic objectForKey:@"description"]==[NSNull null]?nil:[self.goodsDic objectForKey:@"description"] ;
            
            if (prop&&![prop isEqualToString:@""]) {
                NSArray *imgs = [prop componentsSeparatedByString:@","];
                view.arr = imgs;
            }
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case 1:
        {
            XWJSPGuigeViewController *view  = [[XWJSPGuigeViewController alloc ] init];
            [self.navigationController pushViewController:view animated:NO];
        }
            break;
        case 2:{
            //            if (self.comments.count>0) {
            XWJSPCommentController *comment = [[XWJSPCommentController alloc ]init];
            comment.comments = self.comments;
            [self.navigationController pushViewController:comment animated:NO];
            //            }
        }
            break;
        default:
            break;
    }
}

-(void)addView{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, HEIGHT_VIEW1)];
    adView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.width-110)];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, adView.frame.origin.y+adView.frame.size.height-25, SCREEN_SIZE.width, 25)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment  = NSTextAlignmentCenter;
    titleLabel.alpha = 0.6;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, adView.frame.origin.y+adView.frame.size.height, 100, 30)];
    label.font = [UIFont systemFontOfSize:15];
    youhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width, adView.frame.origin.y+adView.bounds.size.height, SCREEN_SIZE.width, 30)];
    shichangjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, label.frame.origin.y+label.bounds.size.height, 120, 30)];
    xiaoliangLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width-80,adView.frame.origin.y+adView.bounds.size.height, 80, 30)];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, shichangjiaLabel.frame.origin.y+shichangjiaLabel.frame.size.height, SCREEN_SIZE.width-20, 100)];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
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
    [view addSubview:contentLabel];
    [view addSubview:adView];
    //    [view addSubview:dianpuBtn];
    [view addSubview:titleLabel];
    youhuLabel.text = @"￥ 80";
    shichangjiaLabel.text = @"市场价 :";
    xiaoliangLabel.text = @"销量： 100";
    titleLabel.text = @"农夫山泉 天然饮用水";
    label.text = @"业主专属价：";
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, shichangjiaLabel.bounds.size.height/2, shichangjiaLabel.bounds.size.width-65, 1)];
    line.backgroundColor =[UIColor lightGrayColor];
    [shichangjiaLabel addSubview:line];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, (HEIGHT_VIEW2-20)/2, 80, 20)];
    //    label.textColor = XWJGREENCOLOR;
    label.text  = @"商品评论";
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, (HEIGHT_VIEW2-20)/2, 150, 20)];
    headerLabel.textColor = [UIColor lightGrayColor];
    //    headerLabel.text = @"(0人参与评论)";
    headerLabel.text = [NSString stringWithFormat:@"(%@人参与评论)",self.commentCount];
    headerLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_SIZE.width-110, (HEIGHT_VIEW2-30)/2, 100, 30);
    [btn setImage:[UIImage imageNamed:@"next2"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(shangpinClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag= 2;
    [view addSubview:btn];
    [view addSubview:headerLabel];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.comments.count>5)
        return 5;
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)taView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLog(@"index path %ld",(long)indexPath.row);
    XWJSPDetailTableViewCell *cell;
    
    cell = [taView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJSPDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    /*
     anonymous = 0;
     "buyer_name" = 18561927376;
     comment = "     \U554a\U554a\U554a\n";
     evaluation = 5;
     "evaluation_time" = "2016-01-14";
     "goods_id" = 71;
     "rec_id" = 67;
     */
    //    cell.label1.text = [self.tabledata ];
    NSArray *arr = self.comments;
    
    if(arr&&arr.count>0){
        cell.label1.text =     [[arr objectAtIndex:indexPath.row] objectForKey:@"buyer_name"]==[NSNull null]?@"":[[arr objectAtIndex:indexPath.row] objectForKey:@"buyer_name"];
        cell.label2.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"comment"];
        cell.timeLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"evaluation_time"];
        
        NSString *url;
        if ([[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"]!=[NSNull null]) {
            url = [[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"];
        }
        
        //        if (url) {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headDefaultImg"]];
        //        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)addCar{
    
    NSString *stock =  [self.goodsDic objectForKey:@"stock"];
    
    if (![stock intValue]>0) {
        [ProgressHUD showError:@"库存不足！"];
        return;
    }
    NSString *url = ADDCAR_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"store_id"]] forKey:@"storeId"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"goods_id"]] forKey:@"goodsId"];
    [dict setValue:@"1" forKey:@"counts"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"price"]] forKey:@"unitPrice"];
    [dict setValue:@"1" forKey:@"flg"];//0加入购物车 1修改
    CLog(@"spdetail unitPrice %@",[self.goodsDic objectForKey:@"price"]);
    
    /*
     {"account":"177777777777","storeId":"4","goodsId":"4","counts":"1","unitPrice":"24","flg":"1"}
     */
    NSString * cart = [XWJUtil dataTOjsonString:dict];
    NSDictionary * carDic = [NSDictionary dictionaryWithObject:cart forKey:@"cart"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:carDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];
            
            if ([nu integerValue]== 1) {
                int count = self.gouwuCheCounts.intValue;
                count++;
                gouwucheLabel.text = [NSString stringWithFormat:@"%d",count];
                gouwucheLabel.hidden =NO;
                [ProgressHUD showSuccess:errCode];
            }else{
                [ProgressHUD showError:errCode];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getDetail{
    NSString *url = GETGOODDETAIL_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:self.goods_id  forKey:@"goods_id"];
    [dict setValue:[XWJAccount instance].account forKey:@"account"];
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
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            
            self.goodsDic = [dic objectForKey:@"goods"];
            self.comments = [dic objectForKey:@"comments"];
            self.commentCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]==[NSNull null]?@"0":[dic objectForKey:@"count"]];
            self.gouwuCheCounts = [NSString stringWithFormat:@"%@",[dic objectForKey:@"counts"]];
            
            if (isLoad) {
                
                if ([self.gouwuCheCounts isEqualToString:@"0"]) {
                    gouwucheLabel.hidden = YES;
                }else
                    gouwucheLabel.text= self.gouwuCheCounts;

                return ;
            }
            [self.tableView reloadData];
            self.tableView.contentSize = CGSizeMake(0, 100*self.goodsDic.count+150);
            //            self.adArr = [dic objectForKey:@"ad"];
            //            self.thumb = [dic objectForKey:@"thumb"];
            
            [self updateView];
            isLoad = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    //    XWJWebViewController * web = [[XWJWebViewController alloc] init];
    //    web.url = self.;
    //    [self.navigationController pushViewController:web animated:NO];
    XWJImagesController * image = [[XWJImagesController alloc] init];
    image.urls = [self.goodsDic valueForKey:@"goods_img_small"];
    [self.navigationController pushViewController:image animated:NO];
    
}

-(void)updateView{
    
    
    /*
     @heIsAll 商品详情顶部的图片，使用字段goods_img_small，点击后的图片显示使用字段goods_img
     
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
    headerLabel.text = [NSString stringWithFormat:@"(%@人参与评论)",self.commentCount];
    
    if(self.isFromJifen)
        youhuLabel.text = [NSString stringWithFormat:@"%.2f积分",[[self.goodsDic valueForKey:@"price"]floatValue ]];
    else
        youhuLabel.text = [NSString stringWithFormat:@"￥ %.2f",[[self.goodsDic valueForKey:@"price"]floatValue ]];
    
    shichangjiaLabel.text = [NSString stringWithFormat:@"市场价: ￥%.2f",[[self.goodsDic valueForKey:@"old_price"] floatValue] ];
    xiaoliangLabel.text = [NSString stringWithFormat:@"销量：%@",[self.goodsDic objectForKey:@"sales"]];
    titleLabel.text = [self.goodsDic objectForKey:@"goods_name"];
    //    simple_desc
    
    CGSize size = CGSizeMake(contentLabel.frame.size.width, CGFLOAT_MAX);
    NSString * desc = [self.goodsDic objectForKey:@"simple_desc"]==[NSNull null]?@"":[self.goodsDic objectForKey:@"simple_desc"];
    //计算文字所占区域
    CGSize labelSize = [desc boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : contentLabel.font} context:nil].size;
    
    contentLabel.frame = CGRectMake(contentLabel.frame.origin.x
                                    , contentLabel.frame.origin.y, contentLabel.frame.size.width, labelSize.height);
    contentLabel.text = desc;
    [self addBottomBtn];
    NSString * prop = [self.goodsDic objectForKey:@"description"]==[NSNull null]?nil:[self.goodsDic objectForKey:@"description"] ;
    
    if (prop&&![prop isEqualToString:@""]) {
        NSArray *imgs = [prop componentsSeparatedByString:@","];
        
        //        NSMutableArray * imgs  = [NSMutableArray array];
        //        [imgs addObject:[img objectAtIndex:0]];
        //        [imgs addObject:[img objectAtIndex:0]];
        //        [imgs addObject:[img objectAtIndex:0]];
        
        if (imgs&&imgs.count>0) {
            UIView * view  =shangpinImg.superview;
            //            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, HEIGHT_VIEW2*imgs.count);
            //            [shangpinImg sd_setImageWithURL:[NSURL URLWithString:[imgs objectAtIndex:0]]];
            //            for (int i =1; i<imgs.count; i++) {
            //
            //                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(40, 25+HEIGHT_VIEW2*i, SCREEN_SIZE.width-4-80, HEIGHT_VIEW2)];
            //                [img sd_setImageWithURL:[NSURL URLWithString:[imgs objectAtIndex:i]]];
            //                [view addSubview:img];
            //            }
            
            
            if (self.comments.count==0) {
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }else{
                //                headerLabel.text = [NSString stringWithFormat:@"(%ld人参与评论)" ,self.comments.count];
                
                tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 40+self.comments.count*95+10);
            }
            
            [tableView reloadData];
            scrollView.contentSize  = CGSizeMake(0, HEIGHT_VIEW1+100+tableView.frame.size.height);
        }
    }
    
    
    
    NSMutableArray *URLs = [NSMutableArray array];
    
    if ([self.goodsDic objectForKey:@"goods_img_small"]!=[NSNull null]) {
        NSString *url = [self.goodsDic valueForKey:@"goods_img_small"];
        URLs = [NSMutableArray arrayWithArray:[url componentsSeparatedByString:@","]];
    }else
        [URLs addObject:[self.goodsDic objectForKey:@"default_image"]];
    
    //    UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,                                                                                           self.adView.bounds.size.height)];
    //    logoImgV.contentMode  = UIViewContentModeScaleAspectFit;
    //    [logoImgV sd_setImageWithURL:[NSURL URLWithString:[self.goodsDic objectForKey:@"default_image"]] placeholderImage:[UIImage imageNamed:@"demo"]];
    //
    //    [self.adView addSubview:logoImgV];
    
    
    
    if(URLs&&URLs.count>0)
        [self.adView addSubview:({
            
            LCBannerView *bannerView = [[LCBannerView alloc]initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width-80,
                                                                                     self.adView.bounds.size.height)
                                        
                                                                 delegate:self
                                                                imageURLs:URLs
                                                         placeholderImage:@"devAdv_default"
                                                            timerInterval:MAXFLOAT
                                            currentPageIndicatorTintColor:[UIColor redColor]
                                                   pageIndicatorTintColor:[UIColor whiteColor]
                                                                         :UIViewContentModeCenter];
            bannerView;
        })];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

-(void)addBottomBtn{
    
    if (self.isFromJifen) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = 60;
        button.frame = CGRectMake(0, SCREEN_SIZE.height-height, width, height);
        
        [button setTitle:@"立即兑换" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setBackgroundColor:XWJGREENCOLOR];
        [button setTitleColor:XWJGREENCOLOR forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toJiesuan) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        return;
    }
    
    self.btn = [NSMutableArray array];
    
    NSString *type = [self.goodsDic objectForKey:@"order_type"];
    
    if (type) {
        
        
        NSArray * typeArr = [type componentsSeparatedByString:@","];
        
        NSMutableArray * typeArr2 = [NSMutableArray array];
        //        [typeArr2 addObject:typeArr];
        
        for (NSString *s in typeArr) {
            if ([s isEqualToString:@"立即购买"]||[s isEqualToString:@"在线订购"]) {
                [typeArr2 insertObject:@"" atIndex:0];
                [typeArr2 addObject:@"加入购物车"];
                [typeArr2 addObject:@"立即购买"];
            }else
                [typeArr2 addObject:s];
        }
        
        if (typeArr2&&typeArr2.count>0) {
            
            NSInteger count =typeArr2.count;
            NSArray * title = typeArr2;
            
            CGFloat carWidth = 80;
            CGFloat width ;
            //            if ([typeArr2 containsObject:@""]) {
            //                width = (self.view.bounds.size.width-carWidth)/(count-1);
            //
            //            }else
            width = self.view.bounds.size.width/count;
            CGFloat height = 45;
            
            for (int i=0; i<count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                
                //                if ([[title objectAtIndex:i] isEqualToString:@""]) {
                //                    button.frame = CGRectMake((width+1)*i, SCREEN_SIZE.height-height, carWidth, height);
                //                }else
                button.frame = CGRectMake((width+1)*i, SCREEN_SIZE.height-height, width, height);
                button.tag = i;
                [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
                button.titleLabel.numberOfLines =2;
                UIImageView *imgView;
                if ([[title objectAtIndex:i] isEqualToString:@""]) {
                    
                    UIImage *buttonImage = [UIImage imageNamed:@"gouwuche_small"];
                    
                    //                    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:0 topCapHeight:floorf(buttonImage.size.height)];
                    //                    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
                    
                    imgView =  [[UIImageView alloc] initWithFrame:CGRectMake((button.bounds.size.width-buttonImage.size.width)/2,0 , buttonImage.size.width-2, buttonImage.size.height-2)];
                    imgView.image = buttonImage;
                    [button addSubview:imgView];
                    //                    button.contentMode = UIViewContentModeCenter;
                    button.titleLabel.font = [UIFont systemFontOfSize:11];
                    
                }else
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                
                if ([[title objectAtIndex:i] isEqualToString:@""]) {
                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                    //                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [button setTitleColor:XWJGREENCOLOR forState:UIControlStateNormal];
                    
                    gouwucheLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width, 0, 30, 20)];
                    gouwucheLabel.textAlignment = NSTextAlignmentLeft;
                    gouwucheLabel.font = [UIFont systemFontOfSize:12.0];
                    //                    label.text  =@"12";
                    if (self.gouwuCheCounts&&![self.gouwuCheCounts isEqualToString:@"0"]) {
                        
                        gouwucheLabel.text= self.gouwuCheCounts;
                    }
                    gouwucheLabel.textColor = [UIColor redColor];
                    gouwucheLabel.tag = 100;
                    [button addSubview:gouwucheLabel];
                    button.backgroundColor = XWJColor(251, 251, 251);
                    [button setTitle:@"购物车" forState:UIControlStateNormal];
                }else
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
        view.tel = [self.goodsDic objectForKey:@"tel"];
        [self.navigationController showViewController:view sender:nil];
        
    }else if([butn.titleLabel.text isEqualToString:@"优惠政策"]){
        XWJYouHuiViewController *con = [[XWJYouHuiViewController alloc] init];
        con.zhengce = [self.goodsDic objectForKey:@"policy"];
        [self.navigationController showViewController:con sender:nil];
        
    }else if([butn.titleLabel.text isEqualToString:@"立即购买"]){
        //        UIStoryboard *car  = [UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil];
        //        XWJYueLineViewController *view = [car instantiateViewControllerWithIdentifier:@"yuyueline"];
        //        [self.navigationController showViewController:view sender:nil];
        //        [self toJiesuan];
        
        [self addOrder:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"store_id"]]:YES :NO];
    }else if([butn.titleLabel.text isEqualToString:@"购物车"]){
        UIStoryboard *car  = [UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil];
        [self.navigationController showViewController:[car instantiateInitialViewController] sender:self];
    }
    
}

-(void)addOrder:(NSString *)storeid :(BOOL)isPay :(BOOL)isJIfen{
    NSString *url = ADDORDER_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    [dict setValue:storeid forKey:@"storeId"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];
            
            if ([nu integerValue]== 1) {
                
                XWJJiesuanViewController *con = [[UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"jiesuanview"];
                con.price = [NSString stringWithFormat:@"%.2f",[[self.goodsDic valueForKey:@"price"] floatValue]];
                
                NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:self.goodsDic];
                [dic setValue:[self.goodsDic valueForKey:@"default_image"] forKey:@"goods_image"];
                [dic setValue:@"1" forKey:@"quantity"];
                con.arr = [NSArray arrayWithObject:dic];
                con.isFromJiFen = isJIfen;
                con.isPay = isPay;
                [self.navigationController showViewController:con sender:nil];
                //                                [ProgressHUD showSuccess:errCode];
            }else{
                //                [ProgressHUD showError:errCode];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)checkoutIf{
    
}

-(void)toJiesuan{
    NSString *stock =  [self.goodsDic objectForKey:@"stock"];
    
    if (![stock intValue]>0) {
        [ProgressHUD showError:@"库存不足！"];
        return;
    }
    
    
    if(self.isFromJifen){
        NSString *jifen = [XWJAccount instance].jifen ;
        if ([jifen intValue]<[[self.goodsDic valueForKey:@"price"] intValue]) {
            [ProgressHUD showError:@"您的积分不足，可以坚持签到获取更多积分再来"];
            return;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"确定要兑换吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            
            [alert show];
            return;
        }
    }
    
    [ProgressHUD show:@""];
    NSString *url = ADDCAR_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"store_id"]] forKey:@"storeId"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"goods_id"]] forKey:@"goodsId"];
    [dict setValue:@"1" forKey:@"counts"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"price"]] forKey:@"unitPrice"];
    [dict setValue:@"1" forKey:@"flg"];//0加入购物车 1修改
    CLog(@"spdetail unitPrice %@",[self.goodsDic objectForKey:@"price"]);
    
    /*
     {"account":"177777777777","storeId":"4","goodsId":"4","counts":"1","unitPrice":"24","flg":"1"}
     */
    NSString * cart = [XWJUtil dataTOjsonString:dict];
    NSDictionary * carDic = [NSDictionary dictionaryWithObject:cart forKey:@"cart"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:carDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        [ProgressHUD dismiss];
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];
            
            if ([nu integerValue]== 1) {
                
                
            }else{
                [ProgressHUD showError:errCode];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        [ProgressHUD dismiss];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (1 == buttonIndex) {
        
        [self addOrder:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"store_id"]]:NO :YES];

//        [ProgressHUD show:@""];
//        NSString *url = ADDCAR_URL;
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        //    [dict setValue:@"1" forKey:@"store_id"];
//        [dict setValue:[XWJAccount instance].account  forKey:@"account"];
//        [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"store_id"]] forKey:@"storeId"];
//        [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"goods_id"]] forKey:@"goodsId"];
//        [dict setValue:@"1" forKey:@"counts"];
//        [dict setValue:[NSString stringWithFormat:@"%@",[self.goodsDic objectForKey:@"price"]] forKey:@"unitPrice"];
//        [dict setValue:@"1" forKey:@"flg"];//0加入购物车 1修改
//        CLog(@"spdetail unitPrice %@",[self.goodsDic objectForKey:@"price"]);
//        
//        /*
//         {"account":"177777777777","storeId":"4","goodsId":"4","counts":"1","unitPrice":"24","flg":"1"}
//         */
//        NSString * cart = [XWJUtil dataTOjsonString:dict];
//        NSDictionary * carDic = [NSDictionary dictionaryWithObject:cart forKey:@"cart"];
//        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//        [manager PUT:url parameters:carDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            CLog(@"%s success ",__FUNCTION__);
//            [ProgressHUD dismiss];
//            
//            if(responseObject){
//                NSDictionary *dic = (NSDictionary *)responseObject;
//                CLog(@"dic %@",dic);
//                NSString *errCode = [dic objectForKey:@"errorCode"];
//                NSNumber *nu = [dic objectForKey:@"result"];
//                
//                if ([nu integerValue]== 1) {
//                    
//                    
//                }else{
//                    [ProgressHUD showError:errCode];
//                }
//                
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            CLog(@"%s fail %@",__FUNCTION__,error);
//            [ProgressHUD dismiss];
//        }];
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
