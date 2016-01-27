//
//  MyOrderDetailViewController.m
//  XWJ
//
//  Created by lingnet on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "MyOrderDetailViewController.h"

#import "MyOrderDetailModel.h"

#import "MyOrderDetailModel1.h"

#import "MyOrderDetailModel2.h"

#import "MyOrderDetailTableViewCell.h"

#import "MyOrderDetailTableViewCell1.h"

#import "MyOrderDetailTableViewCell2.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

#import "UIImageView+WebCache.h"

#import "Masonry.h"

#import "AFNetworking.h"

#import "XWJUrl.h"

#import "ReturnIP.h"
#import "WXApi.h"
#import "CommonUtil.h"
#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@interface MyOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* _tableView;
    enum WXScene _scene;
    NSString *Token;
    long token_time;
}
//头标题
@property (nonatomic, strong) UIImageView* shangjiaHeadImageView;
@property (nonatomic, strong) UILabel* shangjiaLable;
//脚标题
@property (nonatomic, strong) UILabel* allGoodsLable;
@property (nonatomic, strong) UILabel* priceLable;
@property (nonatomic, strong) UIButton* daifukuanDeleBtn;
@property (nonatomic, strong) UIButton* daifukuanPayBtn;
@property (nonatomic, strong) UIButton* daishouhuoMakeSureBtn;
@property (nonatomic, strong) UIView* lineView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableArray *dataSourceArr1;
@property (nonatomic, strong) NSMutableArray *dataSourceArr2;

@property(nonatomic,copy)NSString* allGoodsNumAndYunfeiStr;
@property(nonatomic,copy)NSString* allGoodsPriceStr;
@property(nonatomic,copy)NSString* shangjiaHeadImageStr;
@property(nonatomic,copy)NSString* shangjiaTitleStr;

@property(nonatomic,copy)NSString* ipStr;
@property(nonatomic,copy)NSString* prePayIdStr;
@property(nonatomic,copy)NSString* myNoncestr;
@property(nonatomic,copy)NSString* apikeystr;
@property(nonatomic,copy)NSString* appid;
@property(nonatomic,copy)NSString* parterid;
@end

@implementation MyOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    token_time = 0;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    [WXApi registerApp:@"wx706df433748af20c" withDescription:@"demo 2.0"];
    self.dataSourceArr = [[NSMutableArray alloc] init];
    self.dataSourceArr1 = [[NSMutableArray alloc] init];
    self.dataSourceArr2 = [[NSMutableArray alloc] init];
    
    self.ipStr = [ReturnIP deviceIPAdress];
    
    [self createTableView];
    
    [self createRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popview) name:@"refreshorder" object:nil];

}

-(void)popview{
    [self.navigationController popViewControllerAnimated:NO];
}

- (float)isIOS7{
    
    float height;
    if (IOS7) {
        height=64.0;
    }else{
        height=44.0;
    }
    return height;
}
#pragma mark - 初始化tableView
- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self isIOS7], self.view.frame.size.width, self.view.frame.size.height-[self isIOS7]) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIImageView *tableBg = [[UIImageView alloc] initWithImage:nil];
    tableBg.backgroundColor = [self colorWithHexString:@"eeeeee"];
    [_tableView setBackgroundView:tableBg];
    //分割线类型
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    //_tableView.backgroundColor = [UIColor colorWithRed:190 green:30 blue:96 alpha:1];
    [self.view addSubview:_tableView];
}
#pragma mark - tableView行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataSourceArr.count;
    }else if (section == 1){
        return self.dataSourceArr1.count;
    }
    return self.dataSourceArr2.count;
}
#pragma mark - tableVie点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - 自定义tableView
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"section";
        MyOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[MyOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        MyOrderDetailModel *model = nil;
        if (indexPath.row < self.dataSourceArr.count) {
            model = [self.dataSourceArr objectAtIndex:indexPath.row];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configueUI:model];
        
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellIdentifier = @"section1";
        MyOrderDetailTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[MyOrderDetailTableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        MyOrderDetailModel1 *model = nil;
        if (indexPath.row < self.dataSourceArr1.count) {
            model = [self.dataSourceArr1 objectAtIndex:indexPath.row];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configueUI:model];
        
        return cell;
    }else if (indexPath.section == 2){
        static NSString *cellIdentifier = @"section2";
        MyOrderDetailTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[MyOrderDetailTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        MyOrderDetailModel2 *model = nil;
        if (indexPath.row < self.dataSourceArr2.count) {
            model = [self.dataSourceArr2 objectAtIndex:indexPath.row];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configueUI:model];
        
        return cell;
    }
    return nil;
    
}
#pragma mark - tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyOrderDetailModel *model = nil;
        if (indexPath.row < self.dataSourceArr.count) {
            model = [self.dataSourceArr objectAtIndex:indexPath.row];
        }
        return [MyOrderDetailTableViewCell hyb_heightForIndexPath:indexPath config:^(UITableViewCell *sourceCell) {
            MyOrderDetailTableViewCell *cell = (MyOrderDetailTableViewCell *)sourceCell;
            // 配置数据
            [cell configueUI:model];
        }];
    }else if (indexPath.section == 1){
        MyOrderDetailModel1 *model = nil;
        if (indexPath.row < self.dataSourceArr1.count) {
            model = [self.dataSourceArr1 objectAtIndex:indexPath.row];
        }
        return [MyOrderDetailTableViewCell1 hyb_heightForIndexPath:indexPath config:^(UITableViewCell *sourceCell) {
            MyOrderDetailTableViewCell1 *cell = (MyOrderDetailTableViewCell1 *)sourceCell;
            // 配置数据
            [cell configueUI:model];
        }];
    }
    MyOrderDetailModel2 *model = nil;
    if (indexPath.row < self.dataSourceArr2.count) {
        model = [self.dataSourceArr2 objectAtIndex:indexPath.row];
    }
    return [MyOrderDetailTableViewCell2 hyb_heightForIndexPath:indexPath config:^(UITableViewCell *sourceCell) {
        MyOrderDetailTableViewCell2 *cell = (MyOrderDetailTableViewCell2 *)sourceCell;
        // 配置数据
        [cell configueUI:model];
    }];
}
#pragma mark - tableView组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
#pragma mark - 创建头标题
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 65)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIView* linV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 5)];
        linV.backgroundColor = [self colorWithHexString:@"eeeeee"];
        [headView addSubview:linV];
        
        self.shangjiaHeadImageView = [[UIImageView alloc] init];
        self.shangjiaHeadImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.shangjiaHeadImageView.layer.cornerRadius = 20;
        //        self.shangjiaHeadImageView.backgroundColor = [UIColor redColor];
        [self.shangjiaHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.shangjiaHeadImageStr] placeholderImage:[UIImage imageNamed:@"devAdv_default"]];
        self.shangjiaHeadImageView.layer.masksToBounds = YES;
        [headView addSubview:self.shangjiaHeadImageView];
        [self.shangjiaHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.mas_equalTo(linV.mas_bottom).offset(5);
            make.height.mas_offset(40);
            make.width.mas_offset(40);
        }];
        
        self.shangjiaLable = [[UILabel alloc] init];
        [headView addSubview:self.shangjiaLable];
        self.shangjiaLable.numberOfLines = 2;
        self.shangjiaLable.text = self.shangjiaTitleStr;
        self.shangjiaLable.font = [UIFont systemFontOfSize:14];
        
        [self.shangjiaLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(self.shangjiaHeadImageView.mas_right).offset(5);
            make.right.mas_equalTo(-5);
            make.height.mas_offset(60);
        }];
        
        return headView;
    }
    return nil;
}
#pragma mark - 脚标题
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIView* aaLine = [[UIView alloc] init];
        [headView addSubview:aaLine];
        aaLine.backgroundColor = [self colorWithHexString:@"9f9f9f"];
        [aaLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_offset(0.5);
        }];
        
        self.allGoodsLable = [[UILabel alloc] init];
        [headView addSubview:self.allGoodsLable];
        self.allGoodsLable.numberOfLines = 1;
        self.allGoodsLable.text = self.allGoodsNumAndYunfeiStr;
        self.allGoodsLable.font = [UIFont systemFontOfSize:12];
        
        [self.allGoodsLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-120);
            make.height.mas_offset(12);
        }];
        
        self.priceLable = [[UILabel alloc] init];
        [headView addSubview:self.priceLable];
        self.priceLable.numberOfLines = 1;
        self.priceLable.textColor = [self colorWithHexString:@"ad0512"];
        self.priceLable.text = self.allGoodsPriceStr;//@"￥0.0";
        self.priceLable.font = [UIFont systemFontOfSize:12];
        
        [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7);
            make.right.mas_equalTo(-5);
            make.height.mas_offset(12);
        }];
        
        self.lineView = [[UIView alloc] init];
        [headView addSubview:self.lineView];
        self.lineView.backgroundColor = [self colorWithHexString:@"eeeeee"];
        self.lineView.alpha = 0.4;
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.priceLable.mas_bottom).offset(5);
            make.right.mas_equalTo(0);
            make.height.mas_offset(0.5);
        }];
        
        if ([self.isDaishouhuo intValue]) {
            
            self.daishouhuoMakeSureBtn = [[UIButton alloc] init];
            [self.daishouhuoMakeSureBtn addTarget:self action:@selector(makeSureClick) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:self.daishouhuoMakeSureBtn];
            [self.daishouhuoMakeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.daishouhuoMakeSureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.daishouhuoMakeSureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.daishouhuoMakeSureBtn.backgroundColor = [self colorWithHexString:@"00adac"];
            [self.daishouhuoMakeSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.lineView.mas_bottom).offset(5);
                make.right.mas_equalTo(-5);
                make.height.mas_offset(30);
                make.width.mas_offset(60);
            }];
        }else{
            
            self.daifukuanPayBtn = [[UIButton alloc] init];
            [self.daifukuanPayBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:self.daifukuanPayBtn];
            [self.daifukuanPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.daifukuanPayBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.daifukuanPayBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            self.daifukuanPayBtn.backgroundColor = [self colorWithHexString:@"00adac"];
            [self.daifukuanPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.lineView.mas_bottom).offset(5);
                make.right.mas_equalTo(-5);
                make.height.mas_offset(30);
                make.width.mas_offset(60);
            }];
            
            self.daifukuanDeleBtn = [[UIButton alloc] init];
            [self.daifukuanDeleBtn addTarget:self action:@selector(deleClick) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:self.daifukuanDeleBtn];
            [self.daifukuanDeleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.daifukuanDeleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.daifukuanDeleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.daifukuanDeleBtn.layer setBorderWidth:1];//设置边界的宽度
            //            [self.daifukuanDeleBtn.layer setBorderColor:[self colorWithHexString:@"eeeeee"]];
            self.daifukuanDeleBtn.backgroundColor = [UIColor whiteColor];
            [self.daifukuanDeleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.daifukuanPayBtn);
                make.right.mas_equalTo(self.daifukuanPayBtn.mas_leftMargin).offset(-20);
                make.height.mas_offset(30);
                make.width.mas_offset(60);
            }];
        }
        
        return headView;
    }
    return nil;
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:@"refreshorder"];
}
#pragma mark - 确认收货响应
- (void)makeSureClick{
    NSLog(@"确认收货");
    [self createMakeSureRequest];
}
#pragma mark - 立即付款响应
- (void)payClick{
    NSLog(@"立即付款");
    [self createPayRequest:self.orderId];
}
#pragma mark - 删除订单响应
- (void)deleClick{
    NSLog(@"删除订单");
    [self createDeleOrderRequest];
}
#pragma mark - 头标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (2 == section) {
        return 55;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 65;
    }
    return 0;
}
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
- (UIColor *) colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
#pragma mark - 数据请求
- (void)createRequest{
    NSLog(@"请求的参数----%@\n----%@\n-----%@",self.status,self.orderId,MYORDERDETAIL);
    NSString* requestAddress = MYORDERDETAIL;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:requestAddress parameters:@{
                                              @"orderId":self.orderId,
                                              @"status":self.status,
                                              }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                  NSLog(@"没有返回信息");
              }else{
                  NSLog(@"---%@",responseObject);
                  MyOrderDetailModel* model = [[MyOrderDetailModel alloc] init];
                  NSDictionary* resultDic = [responseObject objectForKey:@"data"];
                  if ([@"11" isEqualToString:self.status]) {
                      model.payStatusStr = @"待付款";
                  }else if ([@"30" isEqualToString:self.status]){
                      model.payStatusStr = @"待收货";
                  }
                  /************************************/
                  model.orderNumStr = [NSString stringWithFormat:@"订单编号：%@",resultDic[@"order_sn"]];
                  model.sendTimeStr = [NSString stringWithFormat:@"提交时间：%@",resultDic[@"add_time"]];
                  model.payTypeStr = @"微信支付";
                  [self.dataSourceArr addObject:model];
                  /************************************/
                  NSDictionary* temArr = resultDic[@"extm"];
                  MyOrderDetailModel1* model1 = [[MyOrderDetailModel1 alloc] init];
                  //这个地方返回的数据有问题
                  model1.goodsManStr = [NSString stringWithFormat:@"收货人：%@",temArr[@"consignee"]];
                  model1.phoneStr = resultDic[@"phone_tel"];
                  model1.goodAddStr = [NSString stringWithFormat:@"收货地址：%@",temArr[@"address"]];
                  [self.dataSourceArr1 addObject:model1];
                  NSLog(@"=========第二个数据源====%@====%ld",self.dataSourceArr1,self.dataSourceArr1.count);
                  /************************************/
                  NSArray* temArr1 = resultDic[@"detail"];
                  float temPriceAll = 0;
                  NSLog(@"商品数组-----%@",temArr1);
                  for (NSDictionary* dic in temArr1) {
                      MyOrderDetailModel2* model2 = [[MyOrderDetailModel2 alloc] init];
                      model2.goodsHeadImageStr = dic[@"goods_image"];
                      model2.goodsDesStr = dic[@"goods_name"];
                      model2.goodNumStr = [NSString stringWithFormat:@"￥%.2f × %d",[dic[@"price"] floatValue],[dic[@"quantity"] intValue]];
                      temPriceAll += [dic[@"price"] floatValue]*[dic[@"quantity"] intValue];
                      [self.dataSourceArr2 addObject:model2];
                  }
                  
                  self.allGoodsNumAndYunfeiStr = [NSString stringWithFormat:@"共计%lu件商品      运费：￥%.2f",(unsigned long)temArr1.count,[resultDic[@"shipping_fee"] floatValue]];
                  self.allGoodsPriceStr = [NSString stringWithFormat:@"￥%.2f",temPriceAll + [resultDic[@"shipping_fee"] floatValue]];
                  if (![resultDic[@"store_logo"] isKindOfClass:[NSNull class]]) {
                      self.shangjiaHeadImageStr = resultDic[@"store_logo"];
                  }
                  self.shangjiaTitleStr = resultDic[@"seller_name"];
                  
                  [_tableView reloadData];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"失败===%@", error);
          }];
}
#pragma mark - 删除订单数据请求
- (void)createDeleOrderRequest{
    NSLog(@"请求的参数----%@\n----%@\n-----%@",self.status,self.orderId,DELEORDER);
    NSString* requestAddress = DELEORDER;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:requestAddress parameters:@{
                                             @"orderId":self.orderId,
                                             }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([[responseObject objectForKey:@"result"] intValue]) {
                 [self.makeSureDelegate makeSureOrder:self.makeUsreNum];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"失败===%@", error);
         }];
}
#pragma mark - 确认收货数据请求
- (void)createMakeSureRequest{
    NSLog(@"请求的参数----%@\n----%@\n-----%@",self.status,self.orderId,MAKESUREORDER);
    NSString* requestAddress = MAKESUREORDER;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:requestAddress parameters:@{
                                             @"orderId":self.orderId,
                                             @"status":self.status
                                             }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"---%@",responseObject);
             if ([[responseObject objectForKey:@"result"] intValue]) {
                 [self.makeSureDelegate makeSureOrder:self.makeUsreNum];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"失败===%@", error);
         }];
}
#pragma mark - 数据请求
- (void)createPayRequest:(NSString*)orderid{
    NSLog(@"请求的参数----%@\n-----%@\n-----%@\n",GETPAYINFO,self.ipStr,orderid);
    NSString* requestAddress = GETPAYINFO;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:requestAddress parameters:@{
                                              @"orderId":orderid,
                                              @"ip":self.ipStr
                                              }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"成功-----%@",responseObject);
              if ([responseObject[@"result"] intValue]) {
                  NSDictionary* dict = responseObject[@"data"];
                  self.prePayIdStr = dict[@"prepay_id"];
                  NSLog(@"-----预订单----%@",self.prePayIdStr);
                  self.myNoncestr = dict[@"nonce_str"];
                  self.apikeystr = dict[@"apiKey"];
                  self.appid = dict[@"appid"];
                  self.parterid = dict[@"mch_id"];
                  [self getWeChatPay];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"失败===%@", error);
          }];
}


// 调起微信支付，传进来商品名称和价格
- (void)getWeChatPay{
    NSString *prePayid;
    prePayid = self.prePayIdStr;
    //---------------------------获取prePayId结束------------------------------
    
    if(prePayid){
        NSString *timeStamp = [self genTimeStamp];
        // 调起微信支付
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = self.parterid;
        request.prepayId = prePayid;
        request.package = @"Sign=WXPay";
        request.nonceStr = self.myNoncestr;
        request.timeStamp = [timeStamp intValue];
        
        // 这里要注意key里的值一定要填对， 微信官方给的参数名是错误的，不是第二个字母大写
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: self.appid               forKey:@"appid"];
        [signParams setObject: self.parterid           forKey:@"partnerid"];
        [signParams setObject: request.nonceStr      forKey:@"noncestr"];
        [signParams setObject: request.package       forKey:@"package"];
        [signParams setObject: timeStamp             forKey:@"timestamp"];
        [signParams setObject: request.prepayId      forKey:@"prepayid"];
        //生成签名
        NSString *sign  = [self genSign:signParams];
        //添加签名
        request.sign = sign;
        [WXApi sendReq:request];
    } else{
        NSLog(@"*************7*********获取prePayId失败！");
    }
}
#pragma mark - 生成各种参数

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

/**
 * 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪
 */
- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"myt_%@", [self genTimeStamp]];
}

- (NSString *)genOutTradNo
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

#pragma mark - 签名
/** 签名 */
- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序, 因为微信规定 ---> 参数名ASCII码从小到大排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //生成 ---> 微信规定的签名格式
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    // 拼接API密钥
    NSString *result = [NSString stringWithFormat:@"%@&key=%@", signString, self.apikeystr];
    // 打印检查
    NSLog(@"*********1***********result = %@", result);
    // md5加密
    NSString *signMD5 = [CommonUtil md5:result];
    // 微信规定签名英文大写
    signMD5 = signMD5.uppercaseString;
    // 打印检查
    NSLog(@"*********2***********signMD5 = %@", signMD5);
    return signMD5;
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
