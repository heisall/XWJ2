//
//  XWJPay3ViewController.m
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJPay3ViewController.h"
#import "XWJdef.h"
#import "XWJPayWayTableViewCell.h"
#import "XWJAccount.h"
#import "WXApi.h"
#import "CommonUtil.h"
#import "ReturnIP.h"
#import "ProgressHUD/ProgressHUD.h"
#import "XWJPay1TableViewCell.h"
@interface XWJPay3ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSArray *array;
@property NSArray *payarray;
@property NSArray *zhifuIconArr;
@property CGFloat height;

@property(nonatomic,copy)NSString* ipStr;
@property(nonatomic,copy)NSString* prePayIdStr;
@property(nonatomic,copy)NSString* myNoncestr;
@property(nonatomic,copy)NSString* apikeystr;
@property(nonatomic,copy)NSString* appid;
@property(nonatomic,copy)NSString* parterid;
@end

#define  TAG 100
@implementation XWJPay3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"缴费详情";
    self.tabBarController.tabBar.hidden = YES;
    self.ipStr = [ReturnIP deviceIPAdress];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJPayWayView" bundle:nil] forCellReuseIdentifier:@"pay3cell2"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.payTableView.delegate = self;
    self.payTableView.dataSource = self;
    self.payTableView.tag = TAG;
    
    self.array = [NSArray arrayWithObjects:@"青岛市",@"海信花园",@"1号楼1单元101户", nil];
    self.payarray = [NSArray arrayWithObjects:@"微信支付", nil];
    self.zhifuIconArr = [NSArray arrayWithObjects:@"zhifuweixin", nil];
    self.height = 80;
    
    
    self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
    if([XWJAccount instance].headPhoto){
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[XWJAccount instance].headPhoto] placeholderImage:[UIImage imageNamed:@"headDefaultImg"]];
    }
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSString *imgBase64 = [usr valueForKey:@"photo"];
    //判断有没有图片；
    if (imgBase64) {
        NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:imgBase64 options:0];
        UIImage *img = [UIImage imageWithData:nsdataFromBase64String];
        self.userImageView.layer.masksToBounds = YES;
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
        self.userImageView.contentMode =UIViewContentModeScaleToFill;
        self.userImageView.image = img;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.payTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];

    self.zoneLabel.text = self.zone;
    self.doorLabel.text = self.door;
    self.totalLabel.text = [NSString stringWithFormat:@"总价：%@",self.totalPrice];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSuccess) name:@"changeSuccess" object:nil];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:@"changeSuccess"];
}
-(void)changeSuccess{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == TAG) {
        return 40.0;
    }
    
    NSArray *arr  = [self.selectListArr objectAtIndex:indexPath.row];
    CGFloat height  = arr.count*30+20;
    return height;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView.tag == TAG) {
        return 1;
    }
    return self.selectListArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView.tag == TAG) {
        
        UITableViewCell  *cell;
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"pay3cell2"];
        if (!cell) {
            cell = [[XWJPayWayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay3cell2"];
        }
        cell.imageView.image = [UIImage imageNamed:self.zhifuIconArr[indexPath.row]];
        cell.textLabel.text = self.payarray[indexPath.row];
        return cell;
    }
    
    XWJPay1TableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"pay1cell"];
    if (!cell) {
        cell = [[XWJPay1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay1cell"];
    }
    
    //    cell.selectionStyle = self.listUnpayBtn.selected?UITableViewCellSelectionStyleDefault: UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*
     "a_id" = 1;
     "b_id" = 4;
     "r_dy" = 2;
     "r_id" = 1101;
     "t_date" = 201507;
     "t_item" = "\U4f4f\U5b85\U7269\U4e1a\U670d\U52a1\U8d39";
     "t_lastdate" = "2015-07-01";
     "t_money" = "256.6";
     "t_sign" = 1;
     "t_thisdate" = "2015-07-31";
     */
    
    NSArray *arr =  [self.selectListArr objectAtIndex:indexPath.row];
    cell.label1.text = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:0]valueForKey:@"t_date"]];

    [cell setPaylist:[self.selectListArr objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
    }
    
}

#pragma mark - 数据请求
- (void)createPayRequest:(NSString*)orderid money:(NSString *)money{
    [ProgressHUD show:@""];
    
    CLog(@"请求的参数----%@\n-----%@\n-----%@\n",GETWUYEBILLINFO,self.ipStr,orderid);
    NSString* requestAddress = GETWUYEBILLINFO;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    NSDictionary *dicPara  = @{
                               @"orderId":orderid,
                               @"ip":self.ipStr,
                               @"money":money
                               };
    [manager POST:requestAddress parameters:dicPara
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              CLog(@"成功-----%@",responseObject);
              if ([responseObject[@"result"] intValue]) {
                  NSDictionary* dict = responseObject[@"data"];
                  self.prePayIdStr = dict[@"prepay_id"];
                  CLog(@"-----预订单----%@",self.prePayIdStr);
                  self.myNoncestr = dict[@"nonce_str"];
                  self.apikeystr = dict[@"apiKey"];
                  self.appid = dict[@"appid"];
                  self.parterid = dict[@"mch_id"];
                  
                  [[NSUserDefaults standardUserDefaults] setValue:dict[@"orderId"] forKey:@"orderid"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  
                  [self getWeChatPay];
              }
              [ProgressHUD dismiss];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              CLog(@"失败===%@", error);
              [ProgressHUD dismiss];
              
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
        CLog(@"*************7*********获取prePayId失败！");
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
    CLog(@"*********1***********result = %@", result);
    // md5加密
    NSString *signMD5 = [CommonUtil md5:result];
    // 微信规定签名英文大写
    signMD5 = signMD5.uppercaseString;
    // 打印检查
    CLog(@"*********2***********signMD5 = %@", signMD5);
    return signMD5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)surePay:(id)sender {
    [self createPayRequest:_orderids money:_totalPrice];
//    [self.navigationController popToRootViewControllerAnimated:YES ];
}

@end
