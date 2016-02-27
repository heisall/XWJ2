//
//  XWJPay1ViewController.m
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJPay1ViewController.h"
#import "XWJPay1TableViewCell.h"
#import "XWJAccount.h"
#import "WXApi.h"
#import "CommonUtil.h"
#import "ReturnIP.h"
@interface XWJPay1ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSArray *array;
@property NSMutableArray *payListArr;
@property NSMutableDictionary *roomDic;
@property NSMutableArray *selection;


@property(nonatomic,copy)NSString* ipStr;
@property(nonatomic,copy)NSString* prePayIdStr;
@property(nonatomic,copy)NSString* myNoncestr;
@property(nonatomic,copy)NSString* apikeystr;
@property(nonatomic,copy)NSString* appid;
@property(nonatomic,copy)NSString* parterid;
@end

@implementation XWJPay1ViewController
@synthesize selection;
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self headAD];
//    [self getZhangDan];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.ipStr = [ReturnIP deviceIPAdress];

    [self getGuanjiaAD ];
    self.payListArr = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"物业账单";
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.listUnpayBtn.selected = YES;
    selection = [NSMutableArray array];
    self.array = [NSArray arrayWithObjects:@"青岛市",@"海信花园",@"1号楼1单元101户",@"", nil];
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
//    [self countPrice];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

//获取用户的界面的详细信息
-(void)headAD{
    NSString *url = GETGUANJIAAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    
    [dict setValue:[NSString stringWithFormat:@"%@",[XWJAccount instance].uid] forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic哈哈哈 %@",dic);
            self.roomDic = [dic objectForKey:@"room"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}
//获取管家界面的详细信息
-(void)getGuanjiaAD{
    NSString *url = GETGUANJIAAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    
    [dict setValue:[NSString stringWithFormat:@"%@",[XWJAccount instance].uid] forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic********rr %@",dic);
            
            
            self.roomDic = [dic objectForKey:@"room"];
             CLog(@"dic %@",self.roomDic);
            if([XWJAccount instance].isYouke){

            }else{
                self.zoneLabel.text = [self.roomDic objectForKey:@"A_name"];
                self.doorLabel.text = [NSString stringWithFormat:@"%@号楼%@单元%@",[self.roomDic objectForKey:@"b_id"],[self.roomDic objectForKey:@"r_dy"],[self.roomDic objectForKey:@"r_id"]];
                [self getZhangDan];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    

}
//获取详细的账单
-(void)getZhangDan{
    /*
     a_id	小区a_id
     b_id	楼座b_id
     r_dy	房间r_dy
     r_id	房间r_id
     */
        NSString *url = GETFZHANGDAN_URL;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
        [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    
            NSString * bid =[self.roomDic valueForKey:@"b_id"]==[NSNull null]?@"":[self.roomDic valueForKey:@"b_id"];
    NSString *rdy=
    [self.roomDic valueForKey:@"r_dy"]==[NSNull null]?@"":[self.roomDic valueForKey:@"r_dy"];
//    通过三目运算符来判断是否为空，如果为null数据就用空的字符串来代替，如果不为null就直接为真实的数据
    NSString *rid= [self.roomDic valueForKey:@"r_id"]==[NSNull null]?@"":[self.roomDic valueForKey:@"r_id"];
    
        [dict setValue:bid forKey:@"b_id"];
        [dict setValue:rdy forKey:@"r_dy"];
        [dict setValue:rid forKey:@"r_id"];
    
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            CLog(@"%s success ",__FUNCTION__);
            
            if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"+++==dic%@",dic);
            self.payListArr = [dic objectForKey:@"data"];
                
                
            [self.tableView reloadData];

                if (self.payListArr.count>0) {

                int count = self.payListArr.count/3;
                for (int i=0; i<count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
                }
            }
                CLog(@"dic ++++%@",self.payListArr);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CLog(@"%s fail %@",__FUNCTION__,error);
            
        }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.payListArr.count/3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJPay1TableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"pay1cell"];
    if (!cell) {
        cell = [[XWJPay1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay1cell"];
    }
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
    cell.label1.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*3] valueForKey:@"t_date"]];
    cell.label2.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*3] valueForKey:@"t_item"]];
    cell.label3.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*3] valueForKey:@"t_money"]];
    cell.label4.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*3+1] valueForKey:@"t_item"]];
    cell.label5.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*3+1] valueForKey:@"t_money"]];
    cell.label6.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*3+2] valueForKey:@"t_item"]];
    cell.label7.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*3+2] valueForKey:@"t_money"]];

    return cell;
}
- (IBAction)qubuZD:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.listUnpayBtn.selected = !btn.selected;
}
- (IBAction)weijiao:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.listAllBtn.selected = !sender.selected;
}
//全部选择按钮
- (IBAction)quanXuan:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSInteger count = self.payListArr.count/3;
    for (int i=0; i<count; i++) {
        
        if (sender.selected) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }else{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

            [self tableView:self.tableView didDeselectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - 数据请求
- (void)createPayRequest:(NSString*)orderid{
    CLog(@"请求的参数----%@\n-----%@\n-----%@\n",GETPAYINFO,self.ipStr,orderid);
    NSString* requestAddress = GETPAYINFO;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:requestAddress parameters:@{
                                              @"orderId":orderid,
                                              @"ip":self.ipStr
                                              }
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
                  [self getWeChatPay];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              CLog(@"失败===%@", error);
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

-(void)countPrice{
    
    float total= 0;
    for (NSIndexPath *path in selection) {
        

        NSDictionary *dic1  = [self.payListArr objectAtIndex:path.row] ;
        NSDictionary *dic2  = [self.payListArr objectAtIndex:path.row+1] ;
        NSDictionary *dic3  = [self.payListArr objectAtIndex:path.row+2] ;
        total =  total + [[dic1  objectForKey:@"t_money"] floatValue] +[[dic2  objectForKey:@"t_money"] floatValue] +[[dic3  objectForKey:@"t_money"] floatValue];
        
    }
    self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",total];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [selection addObject:indexPath];
    //    UITableViewCell *oneCell = [table cellForRowAtIndexPath: indexPath];
    //    if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
    //        oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    } else
    //        oneCell.accessoryType = UITableViewCellAccessoryNone;
    [self countPrice];
    CLog(@"didSelectRowAtIndexPath %@",selection);
}

- (void)tableView:(UITableView *)table didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [selection removeObject:indexPath];
    
    //    UITableViewCell *oneCell = [table cellForRowAtIndexPath: indexPath];
    //    if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
    //        oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    } else
    //        oneCell.accessoryType = UITableViewCellAccessoryNone;
    CLog(@"didDeselectRowAtIndexPath %@",selection);
    [self countPrice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //r Dispose of any resources that can be recreated.
}

@end
