//
//  XWJShuoListViewController.m
//  XWJ
//
//  Created by Sun on 15/12/21.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJShuoListViewController.h"
#import "LCBannerView.h"
#import "XWJShuolistTableViewCell.h"
#import "XWJMerDetailListController.h"
#import "XWJGroupBuyTableViewCell.h"
#import "XWJSPDetailViewController.h"
#import "XWJWebViewController.h"
#import "XWJAccount.h"

#import "TQStarRatingView.h"

@interface XWJShuoListViewController()<LCBannerViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property UIView *adView;
@property NSMutableArray *tabledata;
@property NSMutableArray *groupBuy;
@property UIView * typeContainView;
@property NSMutableArray *thumbArr;
@property NSMutableArray *adArr;
@property NSMutableArray *btn;
@property UITableView *tableView;

@property(nonatomic,retain)NSMutableArray* starArr;
@end
#define PADDINGTOP 22.0
//#define BTN_WIDTH 100.0
#define BTN_WIDTH  SCREEN_SIZE.width/5
#define BTN_HEIGHT 50.0

@implementation XWJShuoListViewController
@synthesize adView,tabledata,type,typeContainView,groupBuy;
-(void)viewDidLoad{

    [super viewDidLoad];
    self.thumbArr = [NSMutableArray array];
    self.adArr = [NSMutableArray array];
    tabledata = [NSMutableArray array];
    self.starArr = [[NSMutableArray alloc] init];
//    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.title = @"商户列表";
    [self getShuoMore];

//    [self addView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)imgclick{
    
        XWJWebViewController * web = [[XWJWebViewController alloc] init];
        NSString *url  = [[self.adArr objectAtIndex:0] objectForKey:@"url"];
        web.url = url;
        [self.navigationController pushViewController:web animated:NO];
    
}

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index{
    XWJWebViewController *web = [[XWJWebViewController alloc] init];
    
    NSString *url  = [[self.adArr objectAtIndex:index] objectForKey:@"url"];
    web.url = url;
    [self.navigationController  showViewController:web sender:self];
}
//添加视图
-(void)addView{

    adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.width/2)];

    self.btn = [NSMutableArray array];


    UIScrollView *scroll  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, PADDINGTOP+adView.bounds.size.height,BTN_WIDTH, SCREEN_SIZE.height-PADDINGTOP-adView.bounds.size.height)];
    BOOL isFind = FALSE;
    for (int i =0; i<self.thumbArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0,  i*(BTN_HEIGHT+1), BTN_WIDTH, BTN_HEIGHT);
        [btn setTitle:[[self.thumbArr objectAtIndex:i] objectForKey:@"cateName"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"shuonormal"] forState:UIControlStateNormal];
        
        [btn setTitleColor:XWJColor(77, 78, 79) forState:UIControlStateNormal];
        [btn setTitleColor:XWJGREENCOLOR forState:UIControlStateSelected];
        btn.tag = i+100;
        btn.titleLabel.font  = [UIFont systemFontOfSize:14.0];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn addObject:btn];
        [scroll addSubview:btn];
        if ([[self.dic valueForKey:@"id"] integerValue]==[[[self.thumbArr objectAtIndex:i] valueForKey:@"id"] integerValue]) {
            isFind = TRUE;
            [self btnclick:btn];
        }
    }
    
    if (!isFind) {
        [self btnclick:[self.btn objectAtIndex:0]];
    }
    
    scroll.contentSize = CGSizeMake(BTN_WIDTH, self.thumbArr.count*(BTN_HEIGHT+1)+100);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(BTN_WIDTH, scroll.frame.origin.y, SCREEN_SIZE.width-BTN_WIDTH, scroll.bounds.size.height)];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJShuoTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJTuangouCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:scroll];
    
    [self.view addSubview:adView];
    
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnclick:(UIButton *)butn{
    NSInteger index = butn.tag-100;
    for (UIButton *b in self.btn) {
        b.selected = NO;
    }
    butn.selected = !butn.selected;
    [self getMerList:index];
}

-(void)getMerList:(NSInteger)index{
    NSString *url = GETSHLIST_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[[self.thumbArr objectAtIndex:index] objectForKey:@"id"] forKey:@"cateId"];
    [dict setValue:@"0" forKey:@"pageindex"];
    [dict setValue:@"20" forKey:@"countperpage"];
    
    /*
     pageindex	第几页	String,从0开始
     countperpage	每页条数	String
     cateId	商户分类	String
     */
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            tabledata = [dic objectForKey:@"data"]==[NSNull null]?nil:[dic objectForKey:@"data"];

            groupBuy = [dic objectForKey:@"groupBuy"]==[NSNull null]?nil:[dic objectForKey:@"groupBuy"];
            if(tabledata&&tabledata.count>0){
                for (NSDictionary* dic in tabledata) {
                    [self.starArr addObject:dic[@"star"]];
                }
                [self.tableView reloadData];
                self.tableView.hidden = NO;
                self.tableView.contentSize =CGSizeMake(0,self.tabledata.count*100+100+self.groupBuy.count*100);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getShuoMore{
    NSString *url = GETLIFEMORE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    [dict setValue:[self.dic objectForKey:@"parent_id"] forKey:@"parent_id"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            
            self.adArr = [dic objectForKey:@"ad"];
                        self.thumbArr = [dic objectForKey:@"thumb"];
            [self addView];
            
            NSMutableArray *URLs = [NSMutableArray array];
            
            for (NSDictionary *d in self.adArr) {
                [URLs addObject:[d valueForKey:@"Photo"]];
            }
            if(URLs&&URLs.count>0){
                
                if (URLs.count == 1) {
                    
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.frame = CGRectMake(0, 0, self.adView.frame.size.width, self.adView.frame.size.height) ;
                    [self.adView addSubview:imageView];
                    imageView.userInteractionEnabled = YES;
                    
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[URLs lastObject]] placeholderImage:nil];
                    UITapGestureRecognizer* singleRecognizer;
                    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgclick)];
                    //点击的次数
                    singleRecognizer.numberOfTapsRequired = 1;
                    [imageView addGestureRecognizer:singleRecognizer];
                }else
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
            UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
            back.frame = CGRectMake(10, 5, 30, 30);
            [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [adView addSubview:back];
            [back addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(10, 5, 30, 30);
        [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [adView addSubview:back];
        [back addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.groupBuy&&self.groupBuy.count>0) {
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.guzhangArr.count;
    if (section ==0) {
        return tabledata.count;
    }else{
        return self.groupBuy.count;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:XWJGREENCOLOR];
    footer.textLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section ==1){
        return  @"团购商品";
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLog(@"index path %ld",(long)indexPath.row);
    
    if (indexPath.section==0) {
        XWJShuolistTableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[XWJShuolistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        /*
         logo = "<null>";
         prop = "<null>";
         sname = "\U6d01\U5229\U8fbe";
         sorder = 65535;
         visits = 0;
         */
        //    cell.label1.text = [self.tabledata ];
        for (UIView * subview in [cell.xingView subviews]) {
            [subview removeFromSuperview];
        }
        TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, (70/5)*[self.starArr[indexPath.row] intValue], 15) numberOfStar:[self.starArr[indexPath.row] intValue]];
        starRatingView.isNOhua = YES;
        [cell.xingView addSubview:starRatingView];
        NSArray *arr = self.tabledata;
        
        cell.label1.text =     [[arr objectAtIndex:indexPath.row] objectForKey:@"sname"];
//        cell.label2.text = [NSString stringWithFormat:@"查看人数:%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"visits"]];
        
        if ([[arr objectAtIndex:indexPath.row] objectForKey:@"logo"]!=[NSNull null]) {
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"demo"]];
        }else{
            [cell.imgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"demo"]];
            
        }
        
        NSString * prop = [[arr objectAtIndex:indexPath.row] objectForKey:@"prop"]==[NSNull null]?nil:[[arr objectAtIndex:indexPath.row] objectForKey:@"prop"] ;
        
        //    NSString *prop = @"有点甜,杭州的,中央特供";
        cell.tedeView.hidden = YES;
        if (prop&&![prop isEqualToString:@""]) {
            NSArray *teseArr;
            if([prop rangeOfString:@","].length>0)
                teseArr = [prop componentsSeparatedByString:@","];
            else
             teseArr = [prop componentsSeparatedByString:@"，"];
            if (teseArr&&teseArr.count>0) {
                cell.tedeView.hidden = NO;
                CGFloat wid = 0.0;
                
                for (UIView * subview in [cell.tedeView subviews]) {
                        [subview removeFromSuperview];
                }
                for (int i =0; i<teseArr.count; i++) {
                    
                    UIView *view = [cell.tedeView viewWithTag:100+i];
                    UIFont* theFont = [UIFont systemFontOfSize:8];

//                    if (view) {
//                        [(UIButton *)view setTitle:[teseArr objectAtIndex:i] forState:UIControlStateNormal];
//                        [view removeFromSuperview];
//                    }else{
                        
                        
                        CGSize size = CGSizeMake(CGFLOAT_MAX,view.frame.size.height);
                        
                        //计算文字所占区域
                        CGSize labelSize = [[teseArr objectAtIndex:i] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : theFont} context:nil].size;
                        //                    CGSize sizeName = [[teseArr objectAtIndex:i] sizeWithFont:theFont
                        //                                          constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                        //                                              lineBreakMode:NSLineBreakByWordWrapping];
                        view.frame = CGRectMake(view.frame.origin.x, view.frame
                                                .origin.y,labelSize.width, view.frame.size.height);
                        
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(1+wid, 0, labelSize.width, 20)];
                        [btn setBackgroundImage:[UIImage imageNamed:@"kuang" ] forState:UIControlStateNormal];
                        //                btn.enabled = NO;
                        btn.titleLabel.font = theFont;
                        [btn setTitle:[teseArr objectAtIndex:i] forState:UIControlStateNormal];
                        [btn setTitleColor:XWJGREENCOLOR forState:UIControlStateNormal];
                        btn.tag  = 100+i;
                        [cell.tedeView addSubview:btn];
                        wid = wid+labelSize.width+1;

//                    }

 
                }
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        XWJGroupBuyTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[XWJGroupBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        
        
        /*
         "default_image" = "http://www.hisenseplus.com/ecmall/data/files/store_77/goods_37/small_201512291700375318.png";
         "end_time" = "2016-01-27";
         "goods_id" = 71;
         "goods_name" = "\U3010\U5b98\U65b9\U5305\U90ae\U3011\U65b0\U98de\U592953\U5ea6500\U6beb\U5347\U8305\U53f0+\U4e94\U661f53\U5ea6500\U6beb\U5347\U8d35\U5dde\U8305\U53f0\U9171\U9999";
         "old_price" = 2200;
         price = 2192;
         */
        NSArray * arr = self.groupBuy;
        NSString * url = [[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"demo"]];
        cell.contentLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
        cell.price1Label.text = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.price2Label.text = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"old_price"]];
        [cell.dateBtn setTitle:[[arr objectAtIndex:indexPath.row] objectForKey:@"end_time"] forState:UIControlStateDisabled];
//        [cell.qiangBtn setTitle:[[arr objectAtIndex:indexPath.row] objectForKey:@"end_time"] forState:UIControlStateNormal];
        cell.qiangBtn.tag = indexPath.row;
        [cell.qiangBtn addTarget:self action:@selector(jiangGroup:) forControlEvents:UIControlEventTouchUpInside];
        cell.qiangView.layer.masksToBounds = YES;
        cell.qiangView.layer.cornerRadius = 6.0;
        cell.qiangView.layer.borderWidth = 1.0;
        cell.qiangView.layer.borderColor = [XWJGREENCOLOR CGColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)jiangGroup:(UIButton *)btn{
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 4) {
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
//        [self.navigationController showViewController:[storyboard instantiateViewControllerWithIdentifier:@"suggestStory"] sender:nil];
//    }
//    if (indexPath.row == 6) {
//        
//        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
//        [UIApplication sharedApplication].keyWindow.rootViewController = [loginStoryboard instantiateInitialViewController];
//    }
    
    if (indexPath.section==0) {
//        address里面存着url
//        sgrade=4
        
        NSDictionary *dic = [self.tabledata objectAtIndex:indexPath.row];
        if ([dic objectForKey:@"sgrade"]&&[[NSString stringWithFormat:@"%@",[dic objectForKey:@"sgrade"]] isEqualToString:@"4"]) {
            XWJWebViewController *web= [[XWJWebViewController alloc] init];
            web.url= [dic objectForKey:@"address"];
            [self.navigationController showViewController:web sender:self];

        }else{
            XWJMerDetailListController *list= [[XWJMerDetailListController alloc] init];
            list.dic = [self.tabledata objectAtIndex:indexPath.row];
            [self.navigationController showViewController:list sender:self];
        }
    }else{
        XWJSPDetailViewController *list= [[XWJSPDetailViewController alloc] init];
        //    list.dic = [self.goodsArr objectAtIndex:indexPath.row];
        list.goods_id = [[self.groupBuy objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
        [self.navigationController showViewController:list sender:self];
    }
}

@end
