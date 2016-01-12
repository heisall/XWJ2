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
#import "ProgressHUD/ProgressHUD.h"
#define PADDINGTOP 22.0
#define BTN_WIDTH 100.0
#define BTN_HEIGHT 50.0
@interface XWJMerDetailListController()<UITableViewDataSource,UITableViewDelegate,LCBannerViewDelegate>{
    UIView *backview;
    UIScrollView *helperView;
}
@property NSMutableArray *btn;
@property UIView * typeContainView;
@property UIView *adView;
@property UIScrollView *scroll;
@property UITableView *tableView;
@property NSArray *goodsArr;
@property NSMutableArray *cates;
@property UIButton *typeBtn ;
@property UILabel *typeLabel;
@property NSDictionary *store;
@property   UIImageView *imgView;
@property NSInteger lpIndex;

@end
@implementation XWJMerDetailListController

@synthesize scroll,typeBtn,typeLabel,imgView;
-(void)viewDidLoad{
    
    [super viewDidLoad];
//    self.thumbArr = [NSMutableArray array];
//    self.adArr = [NSMutableArray array];
//    tabledata = [NSMutableArray array];
//    [self getShuoMore];
    
//        _adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.height/4)];
    scroll  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    self.navigationItem.title = @"商品列表";

    self.adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.height/4)];

//    self.adView.backgroundColor =[UIColor blackColor];
    [scroll addSubview:self.adView];
    

    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self addView];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJShanghuCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    scroll.contentSize =CGSizeMake(0, 800);
    [self.view addSubview:scroll];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
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
    cell.pricee.text = [NSString stringWithFormat:@"￥ %.1f",[[[arr objectAtIndex:indexPath.row] valueForKey:@"price"] floatValue]];
    
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
    [ProgressHUD show:@""];
    if (self.lpIndex !=0) {

        [dict setValue:[[self.cates objectAtIndex:self.lpIndex] objectForKey:@"cate_id"] forKey:@"cateId"];
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
        
        [ProgressHUD dismiss];
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            
            
            self.goodsArr = [dic objectForKey:@"goods"];
            self.store = [dic objectForKey:@"store"];
            self.cates = [NSMutableArray arrayWithArray:[dic objectForKey:@"cates"]];
            NSDictionary *di = [NSDictionary dictionaryWithObjectsAndKeys:@"全部",@"cate_name",@"",@"cate_id", nil];
            [self.cates insertObject:di atIndex:0];
            [self.tableView reloadData];
            
            self.tableView.frame  =CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y
                                            , self.tableView.frame
                                              .size.width, 100*self.goodsArr.count);
            self.scroll.contentSize = CGSizeMake(0, 100*self.goodsArr.count+150);
//            self.adArr = [dic objectForKey:@"ad"];
//            self.thumb = [dic objectForKey:@"thumb"];
            NSMutableArray *URLs = [NSMutableArray array];
         
            if ([self.store valueForKey:@"store_banner"] ==[NSNull null]){
                return;
            }
            [URLs addObject:[self.store valueForKey:@"store_banner"]];
            
//            [self addView];
//            if(URLs&&URLs.count>0)
//                [self.adView addSubview:({
//                    
//                    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
//                                                                                            self.adView.bounds.size.height)
//                                                
//                                                                        delegate:self
//                                                                       imageURLs:URLs
//                                                                placeholderImage:nil
//                                                                   timerInterval:3.0f
//                                                   currentPageIndicatorTintColor:[UIColor redColor]
//                                                          pageIndicatorTintColor:[UIColor whiteColor]];
//
//                    bannerView;
//                })];

            UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,                                                                                           self.adView.bounds.size.height)];
            logoImgV.contentMode  = UIViewContentModeRedraw;
            [logoImgV sd_setImageWithURL:[NSURL URLWithString:[self.store valueForKey:@"store_banner"]] placeholderImage:[UIImage imageNamed:@"demo"]];
            UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
            back.frame = CGRectMake(10, 5, 30, 30);
            [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.adView.bounds
                                                                            .size.height-30, SCREEN_SIZE.width, 30)];
            titleLabel.textAlignment  = NSTextAlignmentCenter;
            titleLabel.backgroundColor = [UIColor blackColor];
            titleLabel.alpha = 0.4;
            titleLabel.text = [self.store valueForKey:@"store_name"];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:15];
            [self.adView addSubview:logoImgV];
            [self.adView addSubview:titleLabel];
            [self.adView addSubview:back];
            [back addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self.store valueForKey:@"store_ad"] ==[NSNull null]){
                return;
            }
//            [imgView sd_setImageWithURL:[NSURL URLWithString:[self.store valueForKey:@"store_ad"]] placeholderImage:[UIImage imageNamed:@"demo"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        [ProgressHUD dismiss];

    }];
}

-(void)showSortView:(UIButton *)btn{
    //添加半透明背景图
    backview=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.window.frame.size.height)];
    backview.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    backview.tag=4444;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonClicked)];
    backview.userInteractionEnabled = YES;
    [backview addGestureRecognizer:tap];
    [self.view.window addSubview:backview];
    
    //    //添加helper视图
    float kHelperOrign_X=30;
    float kHelperOrign_Y=(self.view.frame.size.height-300)/2+64;
    helperView=[[UIScrollView alloc]initWithFrame:CGRectMake(kHelperOrign_X, kHelperOrign_Y,self.view.frame.size.width-2*kHelperOrign_X, 300)];
    helperView.backgroundColor=[UIColor whiteColor];
    helperView.layer.cornerRadius=5;
    helperView.tag=1002;
    helperView.clipsToBounds=YES;
    [backview addSubview:helperView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
    titleLabel.textColor=[UIColor colorWithRed:95.0/255.0 green:170.0/255.0 blue:249.0/255.0 alpha:1];
    titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [helperView addSubview:titleLabel];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, helperView.frame.size.width, 2)];
    line.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1];
    [helperView addSubview:line];
    
    NSMutableArray *array = [NSMutableArray array];
    NSInteger  count = 0  ;
    
    

    array  = self.cates;
    count = array.count;
    
    for (int i=0; i<count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 40+40*i, helperView.frame.size.width, 40);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
        label.text= [[array objectAtIndex:i] valueForKey:@"cate_name"];
        [button addSubview:label];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width-20-10, 10, 20, 20)];
        imageView.tag=7001;
        [button addSubview:imageView];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 40-1, helperView.frame.size.width, 1)];
        line.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1];
        [button addTarget:self action:@selector(sortTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=60001+i;
        [button addSubview:line];
        
        [helperView addSubview:button];
    }
    helperView.contentSize = CGSizeMake(0, 40*(count+1));
}
-(void)closeButtonClicked{
    //    UIView *backview=[self.view.window viewWithTag:3333];
    [backview removeFromSuperview];
}

-(void)sortTypeButtonClicked:(UIButton *)button{
    [self closeButtonClicked];
    NSInteger index = button.tag - 60001;
    NSLog(@"selcet id %ld",index);
    self.lpIndex = index;
//    self.typeLabel.text = [NSString stringWithFormat:@"%@",[[self.cates objectAtIndex:index] objectForKey:@"cate_name"]];
    
    [((UIButton *)[self.btn objectAtIndex:0]) setTitle:[NSString stringWithFormat:@"%@",[[self.cates objectAtIndex:index] objectForKey:@"cate_name"]] forState:UIControlStateNormal];
 
    [self getShanghuoDetailNew:0];
}

-(void)addView{
    
    self.btn = [NSMutableArray array];
    NSInteger count = 3;
    CGFloat width = self.view.bounds.size.width/3;
    CGFloat height = 40;
    UIView * line  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame = CGRectMake(0, self.adView.frame.origin.y+self.adView.bounds.size.height, SCREEN_SIZE.width, 30);
    [typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    typeBtn.backgroundColor  =[UIColor whiteColor];
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 60, 20)];
    [typeBtn addTarget:self action:@selector(showSortView:) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text  = @"全部";
    [typeBtn addSubview:line];
    [typeBtn addSubview:typeLabel];
    [typeBtn setImage:[UIImage imageNamed:@"pulldown"] forState:UIControlStateNormal];
    typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [scroll addSubview:typeBtn];
//    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.adView.frame.origin.y+self.adView.bounds.size.height+30, SCREEN_SIZE.width, 100)];
    
//    [scroll addSubview:imgView];
    CGFloat btny = self.adView.frame.origin.y+self.adView.bounds.size.height;
    NSArray * title = [NSArray arrayWithObjects:@"全部",@"销量",@"价格", nil];
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
        [scroll addSubview:button];
        

    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, btny+height, SCREEN_SIZE.width, SCREEN_SIZE.height-btny+height)];
    [scroll addSubview:self.tableView];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self getShanghuoDetailNew:0];
    ((UIButton*)self.btn[0]).selected=YES;
    [((UIButton*)self.btn[0]) sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(void)typeclick:(UIButton *)butn{
    NSInteger index = butn.tag;
    for (UIButton *b in self.btn) {
        b.selected = NO;
    }
    butn.selected = !butn.selected;
    
    if (index == 0) {
        [self showSortView:butn];
    }else
        [self getShanghuoDetailNew:index];
    
}
@end
