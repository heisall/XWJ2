//
//  XWJSHuoViewController.m
//  XWJ
//
//  Created by Sun on 15/12/20.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJSHuoViewController.h"
#import "XWJWebViewController.h"
#import "LCBannerView.h"
#import "XWJShuoListViewController.h"
#import "XWJMyMessageController.h"
#import "XWJSPDetailViewController.h"
#import "XWJGroupBuyTableViewCell.h"
#import "XWJAccount.h"
#import "XWJCity.h"
#import "XWJGroupViewController.h"
#import "XWJWebViewController.h"
#import "XWJYouhuiController.h"
#define PADDINGTOP 64.0
@interface XWJSHuoViewController()<LCBannerViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    CGFloat typeBtnheight;
}

@property NSMutableArray *array1;
@property NSMutableArray *array2;
@property NSMutableArray *array3;
@property NSMutableArray *array4;
@property NSMutableArray *array5;

@property NSInteger selecttype;
@property NSMutableArray *adArr;
@property NSMutableArray *adleftArr;
@property NSMutableArray *adrightArr;
@property NSMutableArray *groupBuy;

@property NSMutableArray *hengView;
@property NSMutableArray *thumbArr;

@property NSMutableArray *btn;

@property UIView * typeContainView;
@property UIView *adView;
@property UIScrollView *scroll;

@property UITableView *tableView;

@end

@implementation XWJSHuoViewController

@synthesize array1,array2,array3,array4,scroll,tableView,groupBuy;
-(void)viewDidLoad{
    [super viewDidLoad];
    
    array1 =[NSMutableArray array];
    array2 =[NSMutableArray array];
    array3 =[NSMutableArray array];
    array4 =[NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    scroll  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    [self.view addSubview:scroll];
    scroll.contentSize = CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height+100);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [self addView];
    [self getGShuoAD];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 580, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"XWJTuangouCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self.scroll addSubview:tableView];
    
    [self getGroup:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"gouwuche"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(gouwuche) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = nil;
    UIImage *image1 = [UIImage imageNamed:@"homemes"];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, image1.size.width, image1.size.height);
    [btn1 addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:image1 forState:UIControlStateNormal];
    UIBarButtonItem *rbarButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rbarButtonItem;
    
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
}

-(void)showList{
    UIViewController * con = [[XWJMyMessageController alloc] init];
    [self.navigationController showViewController:con sender:nil];
}
//跳转到购物车
-(void)gouwuche{
    UIStoryboard *car  = [UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil];
    [self.navigationController showViewController:[car instantiateInitialViewController] sender:self];
}
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    CLog(@"you clicked image in %@ at index: %ld", bannerView, (long)index);
    
    if (self.adArr) {
        if ([[[self.adArr objectAtIndex:index] objectForKey:@"Types"] isEqualToString:@"外链"]) {
            XWJWebViewController *web = [[XWJWebViewController alloc] init];
            
            NSString *url  = [[self.adArr objectAtIndex:index] objectForKey:@"url"];
            web.url = url;
            [self.navigationController  showViewController:web sender:self];
        }
    }
    CLog(@"notice click");
    
}
-(void)imgclick{
    if ([[[self.adArr objectAtIndex:0] objectForKey:@"Types"] isEqualToString:@"外链"]) {
        
        XWJWebViewController * web = [[XWJWebViewController alloc] init];
        NSString *url  = [[self.adArr objectAtIndex:0] objectForKey:@"url"];
        web.url = url;
        [self.navigationController pushViewController:web animated:NO];
    }
}
//增加分类栏
-(void)addView{
    self.adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.height/4)];
    
    self.btn = [NSMutableArray array];
    self.hengView = [NSMutableArray array];
    NSInteger count = 4;
    CGFloat width = self.view.bounds.size.width/4;
    CGFloat height = 50;
    CGFloat btny = self.adView.frame.origin.y+self.adView.bounds.size.height+10;
    NSArray * title = [NSArray arrayWithObjects:@"上门",@"商户",@"食品",@"家装", nil];
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, btny, width, height);
        button.tag = i;
        
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        //        [button setBackgroundImage:[UIImage imageNamed:@"shuoselect"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"shuonormal"] forState:UIControlStateNormal];
        
        [button setTitleColor:XWJColor(77, 78, 79) forState:UIControlStateNormal];
        [button setTitleColor:XWJGREENCOLOR forState:UIControlStateSelected];
        
        UIView * hView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 2)];
        hView.backgroundColor = XWJGREENCOLOR;
        hView.tag = i;
        
        if (i==0) {
            hView.hidden = NO;
        }else
            hView.hidden = YES;
        //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        ////        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        //        [button setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 0, 0)];
        //        [button setTitleEdgeInsets:UIEdgeInsetsMake(45, -25, 0, 0)];
        //        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(typeclick:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:hView];
        [self.btn addObject:button];
        [self.hengView addObject:hView];
        
        [scroll addSubview:button];
    }
    ((UIButton*)self.btn[0]).selected=YES;
    _typeContainView = [[UIView alloc] initWithFrame:CGRectMake(0, btny+40, SCREEN_SIZE.width, SCREEN_SIZE.height-btny)];
    //    _typeContainView.backgroundColor = [UIColor redColor];
    [scroll addSubview:_typeContainView];
    [scroll addSubview:self.adView];
}

-(void)showHeng:(NSInteger)index{
    for (UIView *view in self.hengView) {
        
        if (view.tag == index) {
            view.hidden = NO;
        }else
            view.hidden = YES;
    }
}

-(void)addTypeOneView:(NSArray*)arr{
    NSInteger hang = 4;
    CGFloat paddingLeft =35;
    CGFloat paddingTop = 100;
    NSInteger count = arr.count;
    CGFloat width = self.view.bounds.size.width/hang-10;
    CGFloat height = width;
    CGFloat labelWidth = 50;
    for (int i=0; i<count; i++) {
        
        if (i>7) {
            break;
        }
        
        UIImageView *button = [[UIImageView alloc] init];
        
        button.frame = CGRectMake((width+10)*(i%hang)+paddingLeft/2, paddingLeft+i/hang*paddingTop, width-paddingLeft, height-paddingLeft);
        button.tag = 1000+i;
        button.userInteractionEnabled = YES;
        button.contentMode = UIViewContentModeCenter;
        NSString *url;
        if ([[arr objectAtIndex:i] valueForKey:@"thumb"] != [NSNull null]) {
            url = [[arr objectAtIndex:i] valueForKey:@"thumb"];
        }else{
            url = @"";
        }
        button.contentMode =  UIViewContentModeScaleAspectFill;
        [button sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"demo"]];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        [button addGestureRecognizer:singleRecognizer];
        
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake((width+10)*(i%hang)+paddingLeft/2+(width-labelWidth)/2-5, paddingLeft+i/hang*paddingTop+height-25, labelWidth, 30)];
        
        label.text = [[arr objectAtIndex:i] valueForKey:@"cateName"];
        label.font = [UIFont systemFontOfSize:13.0];
        [self.typeContainView addSubview:label];
        [self.typeContainView addSubview:button];
        
    }
    
    CGFloat img_width = self.view.bounds.size.width/2;
    CGFloat img_height = 70;
    
    //    if (self.adleftArr.count>0&&self.adrightArr.count>0) {
    
    UIButton * but ;
    for (int i=0; i<2; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        
        button.frame = CGRectMake((img_width+1)*(i), 2*height+40+self.typeContainView.frame.origin.y+paddingLeft+i/hang*paddingTop, img_width, img_height);
        button.tag = 1000+i;
        button.userInteractionEnabled = YES;
        
        NSString *url ;
        if (i==0) {
            if (self.adleftArr &&self.adleftArr.count>0) {
                url = [NSString stringWithFormat:@"%@",[[self.adleftArr objectAtIndex:0]objectForKey:@"Photo"]];
            }
        }else
            if (self.adrightArr&&self.adrightArr.count>0) {
                url = [NSString stringWithFormat:@"%@",[[self.adrightArr objectAtIndex:0]objectForKey:@"Photo"]];
            }
        
        //            [button sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"demo"]];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgesingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        [button addGestureRecognizer:singleRecognizer];
        but =button;
        if(i==0){
            [button setTitle:@"社区团购" forState:UIControlStateNormal];
            [button setBackgroundColor:XWJColor(252, 150, 146)];
        }
        else{
            [button setTitle:@"商城优惠" forState:UIControlStateNormal];
            [button setBackgroundColor:XWJColor(144, 167, 237)];
            
        }
        [self.scroll addSubview:button];
    }
    UIButton *but2;
    for (int i=0; i<2; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake((img_width+1)*(i),1+but.frame.origin.y+but.frame.size.height, img_width, img_height);
        button.tag = 1002+i;
        button.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgesingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        [button addGestureRecognizer:singleRecognizer];
        
        but2 =button;
        
        if(i==0){
            [button setTitle:@"海信广场" forState:UIControlStateNormal];
            [button setBackgroundColor:XWJColor(83, 190, 187)];
            
        }
        else{
            [button setTitle:@"海信商城" forState:UIControlStateNormal];
            [button setBackgroundColor:XWJColor(252, 177, 133)];
            
        }
        [self.scroll addSubview:button];
    }
    
    tableView.frame = CGRectMake(tableView.frame.origin.x, but2.frame.origin.y+but2.frame.size.height, tableView.frame.size.width, self.groupBuy.count*110);
    
    
    //    }
}

-(void)imgesingleTap:(UITapGestureRecognizer *)image{
    
    //    if (self.adleftArr.count>0&&self.adrightArr.count>0)
    //        return;
    NSInteger tag =     image.view.tag-1000;
    
    switch (tag) {
        case 0:
        {
            XWJGroupViewController *group  = [[XWJGroupViewController alloc] init];
            [self.navigationController showViewController:group sender:nil];
        }
            break;
        case 1:
        {
            XWJYouhuiController *you = [[XWJYouhuiController alloc] init];
            [self.navigationController pushViewController:you animated:NO];
            
            //            [self getYouHui];
            //            XWJWebViewController * web = [[XWJWebViewController alloc] init];
            //            web.url = @"";
            //            [self.navigationController pushViewController:web animated:NO];
        }
            break;
        case 2:
        {
            NSString *url;
            
            if (self.adleftArr&&self.adleftArr.count>0) {
                url = [[self.adleftArr objectAtIndex:0] valueForKey:@"url"];
                
                XWJWebViewController * web = [[XWJWebViewController alloc] init];
                web.url = url;
                //                [self.navigationController pushViewController:web animated:NO];
                [self.navigationController showViewController:web sender:nil];
                
            }
        }
            break;
        case 3:
        {
            
            NSString *url;
            
            if (self.adrightArr&&self.adrightArr.count>0) {
                
                url= [[self.adrightArr objectAtIndex:0] valueForKey:@"url"];
                XWJWebViewController * web = [[XWJWebViewController alloc] init];
                web.url = url;
                [self.navigationController showViewController:web sender:nil];
                //                [self.navigationController sh:web animated:NO];
            }
            
        }
            break;
        default:
            break;
    }
    /*
     XWJWebViewController *web  = [[XWJWebViewController alloc]init];
     if (tag==0) {
     if (self.adleftArr.count>0) {
     
     web.url = [[self.adleftArr objectAtIndex:0]objectForKey:@"url"];
     }else
     return;
     
     }else{
     if (self.adrightArr.count>0) {
     web.url = [[self.adrightArr objectAtIndex:0]objectForKey:@"url"];
     }else
     return;
     }
     [self.navigationController showViewController:web sender:nil];
     */
}
-(void)singleTap:(UITapGestureRecognizer *)image{
    NSInteger index = image.view.tag;
    //    CLog(@"single tap %lu",index);
    NSArray *array ;
    switch (_selecttype) {
        case 1:
            array = array1;
            break;
        case 2:
            array = array2;
            break;
        case 3:
            array = array3;
            break;
        case 4:
            array = array4;
            break;
        default:
            break;
    }
    
    XWJShuoListViewController * list= [[XWJShuoListViewController alloc] init];
    NSDictionary *dic = [array objectAtIndex:index-1000];
    if ([[dic objectForKey:@"cateName"] isEqualToString:@"更多"]) {
        list.dic = [array objectAtIndex:0];
    }else
        list.dic = [array objectAtIndex:index-1000];
    [self.navigationController showViewController:list sender:self];
}

-(void)getYouHui{
    NSString *url = GETYOUHUI_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
     pageindex	第几页	String,从0开始
     countperpage	每页条数	String
     cateId	商户分类	String
     */
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getGShuoAD{
    NSString *url = GETLIFEAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_id"];
    
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    //    [dict setValue:[XWJAccount instance].uid forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            
            _selecttype = 1;
            self.adArr = [dic objectForKey:@"ad"];
            self.adleftArr = [dic objectForKey:@"ad_left"];
            self.adrightArr = [dic objectForKey:@"ad_right"];
            
            //            self.thumbArr = [dic objectForKey:@"jz"];
            self.array1 =  [dic objectForKey:@"sm"];
            self.array2 =  [dic objectForKey:@"sh"];
            self.array3 =  [dic objectForKey:@"sp"];
            self.array4 =  [dic objectForKey:@"jz"];
            self.array5 =  [dic objectForKey:@"tg"];
            
            NSMutableArray *URLs = [NSMutableArray array];
            for (NSDictionary
                 *dic in self.adArr) {
                [URLs addObject:[dic valueForKey:@"Photo"]];
            }
            
            
            //            for (NSDictionary *d in self.thumbArr) {
            //                NSNumber *num  =[d objectForKey:@"parent_id"];
            //                switch ([num intValue]) {
            //                    case 1:
            //                        [self.array1 addObject:d];
            //                        break;
            //                    case 2:
            //                        [self.array2 addObject:d];
            //                        break;
            //                    case 3:
            //                        [self.array3 addObject:d];
            //                        break;
            //                    case 4:
            //                        [self.array4 addObject:d];
            //                        break;
            //                    default:
            //                        break;
            //                }
            //
            //            }
            [self addTypeOneView:self.array1];
            
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
                {
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
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getGroup:(NSInteger)index{
    NSString *url = GETGROUP_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //    [dict setValue:[[self.thumbArr objectAtIndex:index] objectForKey:@"id"] forKey:@"cateId"];
    //    [dict setValue:@"0" forKey:@"pageindex"];
    //    [dict setValue:@"20" forKey:@"countperpage"];
    
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
            
            groupBuy = [dic objectForKey:@"data"];
            [tableView reloadData];
            //            tableView.contentSize =CGSizeMake(0,100+self.groupBuy.count*110);
            tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, self.groupBuy.count*110);
            scroll.contentSize = CGSizeMake(SCREEN_SIZE.width, 150+SCREEN_SIZE.height+self.groupBuy.count*110);
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)typeclick:(UIButton *)butn{
    NSInteger index = butn.tag;
    for (UIButton *b in self.btn) {
        b.selected = NO;
    }
    butn.selected = !butn.selected;
    
    [self showHeng:index];
    _selecttype = index+1;
    
    for (UIView * v in self.typeContainView.subviews) {
        [v removeFromSuperview];
    }
    NSArray *array ;
    switch (_selecttype) {
        case 1:
            array = array1;
            break;
        case 2:
            array = array2;
            break;
        case 3:
            array = array3;
            break;
        case 4:
            array = array4;
            break;
        default:
            break;
    }
    
    [self addTypeOneView:array];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return groupBuy.count;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:XWJGREENCOLOR];
    footer.textLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //    if(section ==1){
    //        return  @"团购商品";
    //    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLog(@"index path %ld",(long)indexPath.row);
    
    
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
    NSArray * arr = groupBuy;
    NSString * url = [[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"demo"]];
    cell.contentLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    cell.price1Label.text = [NSString stringWithFormat:@"￥%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"price"]];
    cell.price2Label.text = [NSString stringWithFormat:@"￥%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"old_price"]];
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
-(void)jiangGroup:(UIButton *)btn{
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XWJSPDetailViewController *list= [[XWJSPDetailViewController alloc] init];
    //    list.dic = [self.goodsArr objectAtIndex:indexPath.row];
    list.goods_id = [[self.groupBuy objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
    [self.navigationController showViewController:list sender:self];
    
}

@end
