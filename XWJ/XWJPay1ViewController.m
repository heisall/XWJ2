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
#import "ProgressHUD/ProgressHUD.h"
#import "XWJPay3ViewController.h"
@interface XWJPay1ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSArray *array;
@property NSArray *payListArr;

@property NSMutableArray *selectListArr;


@property NSMutableDictionary *roomDic;
@property NSMutableArray *selection;

@property(nonatomic,copy)NSString* ipStr;
@property(nonatomic,copy)NSString* prePayIdStr;
@property(nonatomic,copy)NSString* myNoncestr;
@property(nonatomic,copy)NSString* apikeystr;
@property(nonatomic,copy)NSString* appid;
@property(nonatomic,copy)NSString* parterid;

@property float totalPrice;
@property NSMutableString* orderIds;
@end

@implementation XWJPay1ViewController
const int payNum = 2;
const float cellheight =  30.0;

@synthesize selection;
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self headAD];
//    [self getZhangDan];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.ipStr = [ReturnIP deviceIPAdress];

//    [self getGuanjiaAD ];
    self.payListArr = [[NSArray alloc]init];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSuccess) name:@"changeSuccess" object:nil];

//    [self countPrice];

}

-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:@"changeSuccess"];
}
-(void)changeSuccess{
    [self getGuanjiaAD];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self getGuanjiaAD ];

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
                [self getZhangDanType:@"0"];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    

}
//获取详细的账单
-(void)getZhangDanType:(NSString *) type{
    
    
    [ProgressHUD show:@""];
    selection = [NSMutableArray array];
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
    
    if (type) {
        [dict setValue:type forKey:@"sign"];
    }
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            CLog(@"%s success ",__FUNCTION__);
            
            if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"+++==dic%@",dic);
            NSArray *arr = [dic objectForKey:@"data"];
                
            self.payListArr = [self fenlei:arr];
                
            [self.tableView reloadData];
            self.totalLabel.text = @"";
            if (self.payListArr.count>0) {

//                int count = self.payListArr.count/payNum;
//                for (int i=0; i<count; i++) {
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
//                    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
//                }
            }
                CLog(@"dic ++++%@",self.payListArr);
            }
            [ProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CLog(@"%s fail %@",__FUNCTION__,error);
            [ProgressHUD dismiss];
        }];
}

-(NSArray *)fenlei:(NSArray *)array{
    
    if (!array||array.count==0) {
        return nil;
    }
    NSMutableArray *retArr = [NSMutableArray array];
    
    NSString *date = [[array objectAtIndex:0] objectForKey:@"t_date"];
    NSMutableArray *monthArr =  [NSMutableArray array];
    for (NSDictionary *dic in array) {
        
        if ([date isEqualToString:[dic objectForKey:@"t_date"]]) {

        }else{
            [retArr addObject:monthArr];
            monthArr = [NSMutableArray array];
            date = [dic objectForKey:@"t_date"];
        }
        [monthArr addObject:dic];

    }
    [retArr addObject:monthArr];

    return retArr;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr  = [self.payListArr objectAtIndex:indexPath.row];
    CGFloat height  = arr.count*cellheight+20;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count;
//    if (self.payListArr.count&&self.payListArr.count<payNum) {
//        count = 1;
//    }else{
//        count = (int)ceilf((float)self.payListArr.count/(float)payNum);
//    }
    count = self.payListArr.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJPay1TableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"pay1cell"];
    if (!cell) {
        cell = [[XWJPay1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay1cell"];
    }
    
//    cell.selectionStyle = self.listUnpayBtn.selected?UITableViewCellSelectionStyleDefault: UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectImgView.hidden = !self.listUnpayBtn.selected;
    
    if ([selection containsObject:indexPath]) {
        cell.selectImgView.highlighted = YES;
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
    
    NSArray *arr =  [self.payListArr objectAtIndex:indexPath.row];
    BOOL hidden  = YES;
    if(self.listAllBtn.selected&&([[[arr objectAtIndex:0]valueForKey:@"t_sign"] intValue]==0))
        hidden = NO;
        cell.unpayImaView.hidden = hidden;
    
    cell.label1.text = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:0]valueForKey:@"t_date"]];
    [cell setPaylist:[self.payListArr objectAtIndex:indexPath.row]];
    return cell;
}

- (IBAction)jiaoFei:(id)sender {
    
//    float total= 0;
//    NSMutableString *orderIds = [NSMutableString string];
//    for (NSIndexPath *path in selection) {
//        
//        
//        NSDictionary *dic1  = [self.payListArr objectAtIndex:path.row*payNum] ;
//        NSDictionary *dic2  = [self.payListArr objectAtIndex:path.row*payNum+1] ;
//        NSDictionary *dic3  = [self.payListArr objectAtIndex:path.row*payNum+2] ;
//        total =  total + [[dic1  objectForKey:@"t_money"] floatValue] +[[dic2  objectForKey:@"t_money"] floatValue] +[[dic3  objectForKey:@"t_money"] floatValue];
//        
//        [orderIds appendFormat:@",%@,%@,%@",[dic1  objectForKey:@"id"],[dic2  objectForKey:@"id"],[dic3  objectForKey:@"id"]];
//    }
//    NSString *totalPrice = [NSString stringWithFormat:@"%.2f",total];
//    [orderIds deleteCharactersInRange:NSMakeRange(0, 1)];
//    [orderIds appendString:@","];
    
    if (self.listUnpayBtn.selected&&selection.count>0) {
        
        XWJPay3ViewController * pay3 = [self.storyboard instantiateViewControllerWithIdentifier:@"pay3"];
        
        pay3.headImage = self.userImageView.image;
        pay3.zone = self.zoneLabel.text;
        pay3.door = self.doorLabel.text;
        pay3.totalPrice = [NSString stringWithFormat:@"%.2f",_totalPrice];
        pay3.orderids = _orderIds;
        pay3.selectListArr = self.selectListArr;
        [self.navigationController pushViewController:pay3 animated:NO];

//        NSString *totalPrice = [NSString stringWithFormat:@"%.2f",_totalPrice];
//        [self createPayRequest:_orderIds money:totalPrice];
    }

}

- (IBAction)qubuZD:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    self.listUnpayBtn.selected = !btn.selected;
    
    
    [self getZhangDanType:nil];
}
- (IBAction)weijiao:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    self.listAllBtn.selected = !sender.selected;
    [self getZhangDanType:@"0"];

}
//全部选择按钮
- (IBAction)quanXuan:(UIButton *)sender {
    
    if(self.listUnpayBtn.selected){
        
        selection = [NSMutableArray new];
        sender.selected = !sender.selected;

        NSInteger count;
        count = self.payListArr.count;
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

-(void)countPrice2{
    float total= 0;
    
    _orderIds = [NSMutableString new];
    _selectListArr = [NSMutableArray new];
    for (NSIndexPath *path in selection) {
        
        NSArray *arr  = [self.payListArr objectAtIndex:path.row];
        [_selectListArr addObject:arr];
        
        for (NSDictionary *dic in arr) {
            total =  total + [[dic objectForKey:@"t_money"] floatValue] ;
            [_orderIds appendFormat:@",%@",[dic  objectForKey:@"id"]];
            
        }
        

    }
    
    if ([_orderIds hasPrefix:@","]) {
        [_orderIds deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    _totalPrice = total;
    self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",total];
}
-(void)countPrice{
    
    float total= 0;
    
    _orderIds = [NSMutableString new];
    for (NSIndexPath *path in selection) {
        

        NSDictionary *dic1  = [self.payListArr objectAtIndex:path.row*payNum] ;
        
        NSUInteger payType1Count = path.row*payNum+1;
//        NSUInteger payType2Count = path.row*payNum+2;
        
        NSDictionary *dic2 = nil;
        if (payType1Count>=self.payListArr.count) {
            
        }else
             dic2 = [self.payListArr objectAtIndex:path.row*payNum+1] ;
        
        
        total =  total + [[dic1  objectForKey:@"t_money"] floatValue] +[[dic2  objectForKey:@"t_money"] floatValue];
        
        if (dic2) {
            [_orderIds appendFormat:@",%@,%@",[dic1  objectForKey:@"id"],[dic2  objectForKey:@"id"]];
        }else
            [_orderIds appendFormat:@",%@",[dic1  objectForKey:@"id"]];
        
//        NSDictionary *dic3;
//        if (payType2Count >= self.payListArr.count) {
//            
//        }else
//            dic3= [self.payListArr objectAtIndex:path.row*payNum+2] ;
        
//        total =  total + [[dic1  objectForKey:@"t_money"] floatValue] +[[dic2  objectForKey:@"t_money"] floatValue] +[[dic3  objectForKey:@"t_money"] floatValue];
//        
//        [_orderIds appendFormat:@",%@,%@,%@",[dic1  objectForKey:@"id"],[dic2  objectForKey:@"id"],[dic3  objectForKey:@"id"]];
    }

    if ([_orderIds hasPrefix:@","]) {
        [_orderIds deleteCharactersInRange:NSMakeRange(0, 1)];
    }

    _totalPrice = total;
    self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",total];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [selection addObject:indexPath];
    if (self.listUnpayBtn.selected ) {
        XWJPay1TableViewCell *oneCell = [table cellForRowAtIndexPath: indexPath];

        oneCell.selectImgView.highlighted = YES;
//        = UITableViewCellAccessoryNone;
        [self countPrice2];
    }
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
    
    if (self.listUnpayBtn.selected ) {
        XWJPay1TableViewCell *oneCell = [table cellForRowAtIndexPath: indexPath];
        oneCell.selectImgView.highlighted = NO;
        [self countPrice2];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //r Dispose of any resources that can be recreated.
}

@end
