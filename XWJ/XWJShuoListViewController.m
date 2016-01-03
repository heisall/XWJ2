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
@interface XWJShuoListViewController()<LCBannerViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property UIView *adView;
@property NSMutableArray *tabledata;
@property NSMutableArray *groupBuy;
@property UIView * typeContainView;
@property NSMutableArray *thumbArr;
@property NSMutableArray *adArr;
@property NSMutableArray *btn;
@property UITableView *tableView;
@end
#define PADDINGTOP 64.0
//#define BTN_WIDTH 100.0
#define BTN_WIDTH  SCREEN_SIZE.width/4
#define BTN_HEIGHT 50.0

@implementation XWJShuoListViewController
@synthesize adView,tabledata,type,typeContainView,groupBuy;
-(void)viewDidLoad{

    [super viewDidLoad];
    self.thumbArr = [NSMutableArray array];
    self.adArr = [NSMutableArray array];
    tabledata = [NSMutableArray array];

    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.title = @"商户列表";
    [self getShuoMore];

//    [self addView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)addView{
    adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.height/4)];
    self.btn = [NSMutableArray array];


    UIScrollView *scroll  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, PADDINGTOP+adView.bounds.size.height,BTN_WIDTH, SCREEN_SIZE.height-PADDINGTOP-adView.bounds.size.height)];
    for (int i =0; i<self.thumbArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0,  i*(BTN_HEIGHT+1), BTN_WIDTH, BTN_HEIGHT);
        [btn setTitle:[[self.thumbArr objectAtIndex:i] objectForKey:@"cateName"] forState:UIControlStateNormal];
        

        
        [btn setBackgroundImage:[UIImage imageNamed:@"shuoselect"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"shuonormal"] forState:UIControlStateNormal];
        
        [btn setTitleColor:XWJColor(77, 78, 79) forState:UIControlStateNormal];
        [btn setTitleColor:XWJGREENCOLOR forState:UIControlStateSelected];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn addObject:btn];
        [scroll addSubview:btn];
        if ([[self.dic valueForKey:@"id"] integerValue]==[[[self.thumbArr objectAtIndex:i] valueForKey:@"id"] integerValue]) {
            [self btnclick:btn];
        }
    }
    scroll.contentSize = CGSizeMake(BTN_WIDTH, self.thumbArr.count*(BTN_HEIGHT+1)+100);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(BTN_WIDTH, scroll.frame.origin.y, SCREEN_SIZE.width-BTN_WIDTH, scroll.bounds.size.height)];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJShuoTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJTuangouCell" bundle:nil] forCellReuseIdentifier:@"cell2"];


//    table.backgroundColor = [UIColor grayColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:scroll];
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
    //    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_id"];
    
    //    [dict setValue:@"1" forKey:@"a_id"];
    //    [dict setValue:[XWJAccount instance].uid forKey:@"userid"];
    /*
     pageindex	第几页	String,从0开始
     countperpage	每页条数	String
     cateId	商户分类	String
     */
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            tabledata = [dic objectForKey:@"data"];

            groupBuy = [dic objectForKey:@"groupBuy"];
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            self.tableView.contentSize =CGSizeMake(0,self.tabledata.count*100+100+self.groupBuy.count*110);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getShuoMore{
    NSString *url = GETLIFEMORE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[self.dic objectForKey:@"parent_id"] forKey:@"parent_id"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            
            self.adArr = [dic objectForKey:@"ad"];
                        self.thumbArr = [dic objectForKey:@"thumb"];
            
            [self addView];
            
            NSMutableArray *URLs = [NSMutableArray array];
            
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


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.groupBuy&&self.groupBuy.count>0) {
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 95;
    }
    return 110;
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
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section ==1){
        return  @"团购商品";
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index path %ld",(long)indexPath.row);
    
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
        NSArray *arr = self.tabledata;
        
        cell.label1.text =     [[arr objectAtIndex:indexPath.row] objectForKey:@"sname"];
        cell.label2.text = [NSString stringWithFormat:@"查看人数:%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"visits"]];
        
        if ([[arr objectAtIndex:indexPath.row] objectForKey:@"logo"]!=[NSNull null]) {
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"demo"]];
        }else{
            [cell.imgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"demo"]];
            
        }
        
        NSString * prop = [[arr objectAtIndex:indexPath.row] objectForKey:@"prop"]==[NSNull null]?nil:[[arr objectAtIndex:indexPath.row] objectForKey:@"prop"] ;
        
        //    NSString *prop = @"有点甜,杭州的,中央特供";
        cell.tedeView.hidden = YES;
        if (prop&&![prop isEqualToString:@""]) {
            NSArray *teseArr = [prop componentsSeparatedByString:@","];
            if (teseArr&&teseArr.count>0) {
                cell.tedeView.hidden = NO;
                CGFloat wid = 34.0;
                for (int i =0; i<teseArr.count; i++) {
                    
                    UIView *view = [cell.tedeView viewWithTag:100+i];
                    if (view) {
                        [(UIButton *)view setTitle:[teseArr objectAtIndex:i] forState:UIControlStateNormal];
                        
                    }else{
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(1+i*wid, 0, wid, 20)];
                        [btn setBackgroundImage:[UIImage imageNamed:@"kuang" ] forState:UIControlStateNormal];
                        //                btn.enabled = NO;
                        btn.titleLabel.font = [UIFont systemFontOfSize:8];
                        [btn setTitle:[teseArr objectAtIndex:i] forState:UIControlStateNormal];
                        [btn setTitleColor:XWJGREENCOLOR forState:UIControlStateNormal];
                        btn.tag  = 100+i;
                        [cell.tedeView addSubview:btn];
                    }
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
        XWJMerDetailListController *list= [[XWJMerDetailListController alloc] init];
        list.dic = [self.tabledata objectAtIndex:indexPath.row];
        [self.navigationController showViewController:list sender:self];
    }else{
        XWJSPDetailViewController *list= [[XWJSPDetailViewController alloc] init];
        //    list.dic = [self.goodsArr objectAtIndex:indexPath.row];
        list.goods_id = [[self.groupBuy objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
        [self.navigationController showViewController:list sender:self];
    }
}

@end
