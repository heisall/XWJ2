//
//  XWJMerDetailListController.m
//  XWJ
//
//  Created by Sun on 15/12/24.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMerDetailListController.h"
#import "XWJShangHuTableViewCell.h"
#import "LCBannerView.h"
#import "XWJSPDetailViewController.h"
#import "XWJAccount.h"
#define PADDINGTOP 64.0
#define BTN_WIDTH 100.0
#define BTN_HEIGHT 50.0
@interface XWJMerDetailListController()<UITableViewDataSource,UITableViewDelegate,LCBannerViewDelegate>
@property NSMutableArray *btn;
@property UIView * typeContainView;
@property UIView *adView;
@property UIScrollView *scroll;
@property UITableView *tableView;
@property NSArray *goodsArr;
@property NSDictionary *store;
@end
@implementation XWJMerDetailListController

@synthesize scroll;
-(void)viewDidLoad{
    
    [super viewDidLoad];
//    self.thumbArr = [NSMutableArray array];
//    self.adArr = [NSMutableArray array];
//    tabledata = [NSMutableArray array];
//    [self getShuoMore];
    
//        _adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.height/4)];
//    scroll  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    self.navigationItem.title = @"商品列表";

    self.adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.height/5)];

//    self.adView.backgroundColor =[UIColor blackColor];
    [self.view addSubview:self.adView];
    
        self.automaticallyAdjustsScrollViewInsets = NO;

    [self addView];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJShanghuCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    self.tableView.delegate =self;
    self.tableView.dataSource =self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index path %ld",(long)indexPath.row);
    XWJShangHuTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJShangHuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
    NSArray *arr = self.goodsArr;
    
    cell.title.text =     [[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    cell.chakan.text = [NSString stringWithFormat:@"查看人数:%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"views"]];
    cell.pricee.text = [NSString stringWithFormat:@"￥ %@",[[arr objectAtIndex:indexPath.row] objectForKey:@"price"]];
    
    if ([[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"]!=[NSNull null]) {
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"]] ];
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    XWJSPDetailViewController *list= [[XWJSPDetailViewController alloc] init];
//    list.dic = [self.goodsArr objectAtIndex:indexPath.row];
    list.goods_id = [[self.goodsArr objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
    [self.navigationController showViewController:list sender:self];
}

//0 zx 1 xl 2 jp
-(void)getShanghuoDetailNew:(NSInteger)type{
    NSString *url = GETLIFESTORE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[self.dic objectForKey:@"id"] forKey:@"store_id"];
    switch (type) {
        case 0:
            [dict setValue:@"0" forKey:@"zx"];
            break;
        case 1:
            [dict setValue:@"0" forKey:@"xl"];
            break;
        case 2:
            [dict setValue:@"0" forKey:@"jg"];
            break;
        default:
            break;
    }
    [dict setValue:@"0" forKey:@"pageindex"];
    [dict setValue:@"100" forKey:@"countperpage"];
//    [dict setValue:[XWJAccount instance].account forKey:@"account"];
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
            
            self.goodsArr = [dic objectForKey:@"goods"];
            self.store = [dic objectForKey:@"store"];
            
            [self.tableView reloadData];
            self.tableView.contentSize = CGSizeMake(0, 100*self.goodsArr.count+150);
//            self.adArr = [dic objectForKey:@"ad"];
//            self.thumb = [dic objectForKey:@"thumb"];
            NSMutableArray *URLs = [NSMutableArray array];
         
            if ([self.store valueForKey:@"store_banner"] ==[NSNull null]){
                return;
            }
            [URLs addObject:[self.store valueForKey:@"store_banner"]];
            
//            [self addView];
            if(URLs&&URLs.count>0)
                [self.adView addSubview:({
                    
                    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                                            self.adView.bounds.size.height)
                                                
                                                                        delegate:self
                                                                       imageURLs:URLs
                                                                placeholderImage:nil
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
    
    self.btn = [NSMutableArray array];
    NSInteger count = 3;
    CGFloat width = self.view.bounds.size.width/3;
    CGFloat height = 60;
    CGFloat btny = self.adView.frame.origin.y+self.adView.bounds.size.height+10;
    NSArray * title = [NSArray arrayWithObjects:@"最新",@"销量",@"价格", nil];
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, btny, width, height);
        button.tag = i;
        
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"shuoselect"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"shuonormal"] forState:UIControlStateNormal];
        
        [button setTitleColor:XWJColor(77, 78, 79) forState:UIControlStateNormal];
        [button setTitleColor:XWJGREENCOLOR forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(typeclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn addObject:button];
        [self.view addSubview:button];
        

    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, btny+height, SCREEN_SIZE.width, SCREEN_SIZE.height-btny+height)];
    [self.view addSubview:self.tableView];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    ((UIButton*)self.btn[0]).selected=YES;
    [((UIButton*)self.btn[0]) sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(void)typeclick:(UIButton *)butn{
    NSInteger index = butn.tag;
    for (UIButton *b in self.btn) {
        b.selected = NO;
    }
    butn.selected = !butn.selected;
    
    [self getShanghuoDetailNew:index];
    
}
@end
