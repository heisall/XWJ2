//
//  XWJJiesuanViewController.m
//  XWJ
//
//  Created by Sun on 15/12/27.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJJiesuanViewController.h"
#import "LocationPickerVC.h"
#import "XWJJiesuanTableViewCell.h"
#import "XWJAddressController.h"
#import "XWJAccount.h"
#import "ProgressHUD/ProgressHUD.h"

#import "ReturnIP.h"
#import "WXApi.h"
#import "CommonUtil.h"
#import "UITextView+placeholder.h"
@interface XWJJiesuanViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property NSArray *array;
@property NSArray *payarray;
@property NSArray *zhifuIconArr;
@property NSArray *orderArr;
//@property NSDictionary *addressDic;
@property NSInteger payIndex;
@property(nonatomic,copy)NSString* ipStr;
@property(nonatomic,copy)NSString* prePayIdStr;
@property(nonatomic,copy)NSString* myNoncestr;
@property(nonatomic,copy)NSString* apikeystr;
@property(nonatomic,copy)NSString* appid;
@property(nonatomic,copy)NSString* parterid;
@end

@implementation XWJJiesuanViewController
#define TAG 1
- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApi registerApp:@"wx706df433748af20c" withDescription:@"demo 2.0"];
    self.navigationItem.title = @"用户结算";
    // Do any additional setup after loading the view.
    
//    self.scrollView.contentSize = CGSizeMake(0, 1000);
//    self.array = [NSArray arrayWithObjects:@"青岛市",@"海信花园",@"1号楼1单元101户", nil];
    self.payarray = [NSArray arrayWithObjects:@"货到付款",@"微信支付", nil];
   
    if(self.isFromJiFen){
        self.payarray = [NSArray arrayWithObjects:@"积分兑换", nil];
        self.payTabelCon.constant = 70.0;
    }
    self.zhifuIconArr = [NSArray arrayWithObjects:@"",@"zhifuweixin", nil];
    
    [self.shangpinTableView registerNib:[UINib nibWithNibName:@"XWJJiesuanCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    [self.payTableView registerNib:[UINib nibWithNibName:@"XWJPayWayView" bundle:nil] forCellReuseIdentifier:@"paycell"];

    float money =  [self.price floatValue]+8.0;
    
    if (self.isFromJiFen) {
        self.totalLabel.text = [NSString stringWithFormat:@"%@积分",self.price];
    }else
        self.totalLabel.text = self.price;

    self.ipStr = [ReturnIP deviceIPAdress];

    self.payTableView.dataSource  = self;
    self.payTableView.delegate = self;
    NSIndexPath *path=[NSIndexPath indexPathForItem:1 inSection:0];
    [self.payTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    //    self.payTableView.contentSize = CGSizeMake(0, 30+3*60);
    self.shangpinTableView.dataSource  = self;
    self.shangpinTableView.delegate = self;
    self.shangpinTableView.frame = CGRectMake(0, self.shangpinTableView.frame.origin.y, self.shangpinTableView.frame.size.width, self.arr.count*90);
    self.tableConstraint.constant = self.arr.count*90;
    
//    self.scrollView.contentSize = CGSizeMake(0, self.shangpinTableView.frame.origin.y+self.tableConstraint.constant);
    self.scrollView.contentSize = CGSizeMake(0, 1500);
    
    self.payIndex = 1;
    self.liuyanTextView.placeholder = @"请在这里进行留言";
    self.liuyanTextView.delegate = self;
    [self getAddress];

    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popView) name:@"paySuccess" object:nil];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:@"paySuccess"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == TAG) {
        
        return 30.0;
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == TAG) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, SCREEN_SIZE.width, 20)];
        label.textColor = XWJGREENCOLOR;
        label.text  = @"支付方式";
        [view addSubview:label];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == TAG) {
        return 40.0;
    }
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == TAG) {
        return self.payarray.count;
    }
    return self.arr.count;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.payIndex = indexPath.row;
    CLog(@"pay index %ld",self.payIndex);
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView.tag == TAG) {
        
        UITableViewCell  *cell;
        
        cell = [self.payTableView dequeueReusableCellWithIdentifier:@"paycell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paycell"];
        }
        cell.imageView.image = [UIImage imageNamed:self.zhifuIconArr[indexPath.row]];
        cell.textLabel.text = self.payarray[indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    /*
     "goods_id" = 14;
     "goods_image" = "http://www.hisenseplus.com/ecmall/data/files/store_7/goods_87/small_201512221541271733.jpg";
     "goods_name" = "\U949f\U7231\U9c9c\U82b1\U901f\U9012 33\U6735\U73ab\U7470\U82b1\U675f \U9c9c\U82b1\U5feb\U9012\U5317\U4eac\U5168\U56fd\U82b1\U5e97\U9001\U82b1 33\U6735\U9999\U69df\U73ab\U7470\U82b1\U675f1";
     price = 2592;
     quantity = 1;
     "rec_id" = 21;
     "spec_id" = 14;
     "store_id" = 7;
     "store_name" = "\U521a\U54e5\U9c9c\U82b1";
     */
    XWJJiesuanTableViewCell  *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJJiesuanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    NSString *url = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"goods_image"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url]];
    cell.title.text = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    cell.price.text = [NSString stringWithFormat:@"%.2f",[[[self.arr objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
    cell.numLabel.text = [NSString stringWithFormat:@"x%@",[[self.arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

    if (self.selectDic) {
        self.buyerLabel.text = [self.selectDic objectForKey:@"consignee"];
        self.addressLabel.text = [self.selectDic objectForKey:@"address"];
        self.phoneLabel.text = [self.selectDic objectForKey:@"phone_tel"];
        self.diquLabel.text = [self.selectDic objectForKey:@"region_name"];
    }
//    NSString *adds=[[NSUserDefaults standardUserDefaults] valueForKey:@"buyeraddress"];
//    NSString *name= [[NSUserDefaults standardUserDefaults] valueForKey:@"buyername"];
//    NSString *phone= [[NSUserDefaults standardUserDefaults] valueForKey:@"buyerphone"];
//    self.buyerLabel.text = [NSString stringWithFormat: @"%@ %@",name,phone];
//    self.addressLabel.text = adds;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (IBAction)toAddress:(id)sender {
//        LocationPickerVC *locationPickerVC = [[LocationPickerVC alloc] initWithNibName:@"LocationPickerVC" bundle:nil];
//    [self.navigationController showViewController:locationPickerVC sender:nil];
//    locationPickerVC.con = self;
//    [self.navigationController pushViewController:locationPickerVC animated:YES];
    
    XWJAddressController *addr = [self.storyboard instantiateViewControllerWithIdentifier:@"address"];
    addr.con =self;
    [self.navigationController pushViewController:addr animated:YES];
    

}

-(void)getAddress{
    
    NSString *url = GETADDRESSLIST_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *num = [dic objectForKey:@"result"];
            /*
             {
             "addr_id" = 20;
             address = sdfasd;
             consignee = alp;
             "is_default" = 1;
             "phone_tel" = 13500000020;
             "region_id" = 1;
             "region_name" = "\U9752\U5c9b\U5e02";
             */
            if ([num intValue]== 1) {
                self.array = [dic objectForKey:@"data"];
                for (NSDictionary *dic in self.array) {
                    
                    if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"is_default"]] isEqualToString:@"1"]) {
                        self.selectDic = dic;
                        self.buyerLabel.text = [dic objectForKey:@"consignee"];
                        self.addressLabel.text = [dic objectForKey:@"address"];
                        self.phoneLabel.text = [dic objectForKey:@"phone_tel"];
                        self.diquLabel.text = [dic objectForKey:@"region_name"];
                        break;
                    }
                }
            }
            
            if (!self.selectDic&&self.array.count>0) {
                self.selectDic = [self.array objectAtIndex:0];
                self.buyerLabel.text = [self.selectDic objectForKey:@"consignee"];
                self.addressLabel.text = [self.selectDic objectForKey:@"address"];
                self.phoneLabel.text = [self.selectDic objectForKey:@"phone_tel"];
                self.diquLabel.text = [self.selectDic objectForKey:@"region_name"];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    
}

-(void)duihuan{
    
    /*
     字段名	说明	类型及范围
     goodsId	订单的order_id	String
     quantity	第几页	String,从0开始
     postcript	每页条数	String
     addrId	地址id	String
     shippingId	付款方式id	String
     shippingFee	运费	String
     备注：
     */
    NSString *url = JIFENDUIHUAN_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    NSMutableArray * ridArr = [NSMutableArray array];
    
    
    [dict setValue:[XWJAccount instance].account forKey:@"account"];
    [dict setValue:[NSString stringWithFormat:@"%@",[[self.arr objectAtIndex:0] valueForKey:@"goods_id"]] forKey:@"goodsId"];
    [dict setValue:[NSString stringWithFormat:@"%@",[self.selectDic objectForKey:@"addr_id"]]forKey:@"addrId"];
    [dict setValue:@"1" forKey:@"quantity"];
    NSString *liuyan = [self.liuyanTextView.text isEqualToString:@"请留言"]?@"":self.liuyanTextView.text;
    [dict setValue:liuyan forKey:@"postscript"];
    [dict setValue:@"0" forKey:@"shippingId"];
    [dict setValue:@"0" forKey:@"shippingFee"];
    
    //    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *num = [dic objectForKey:@"result"];
            
            if ([num intValue]== 1) {
                if (self.isPay) {
                    if (self.payIndex ==1) {
                        
                        [self createPayRequest:[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]]];
                    }else{
                        [ProgressHUD showSuccess:errCode];
                        [self confirmOrder:@"30":[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]]];
                    }
                }else if(self.isFromJiFen){
                    [self confirmOrder:@"30":[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]]];

                }else{
                    [ProgressHUD showSuccess:errCode];
                    
                }
            }else
                [ProgressHUD showError:errCode];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

- (IBAction)p:(id)sender {
 

    
    if (self.isFromJiFen||self.isPay) {
        [self duihuan];
    }else{
    
    /*
     storeId	用户登录账号	String
     recIds	商铺id	String
     postscript	留言内容	String
     addrId	地址id	String
     shippingId	配送方式id	String
     shippingFee	运费	String
     */
    NSString *url = SAVEORDER_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
     "goods_id" = 71;
     "goods_image" = "http://admin.hisenseplus.com/ecmall/data/files/store_77/goods_37/small_201512291700375318.png";
     "goods_name" = "\U3010\U5b98\U65b9\U5305\U90ae\U3011\U65b0\U98de\U592953\U5ea6500\U6beb\U5347\U8305\U53f0+\U4e94\U661f53\U5ea6500\U6beb\U5347\U8d35\U5dde\U8305\U53f0\U9171\U9999";
     price = 4384;
     quantity = 2;
     "rec_id" = 131;
     "spec_id" = 71;
     "store_id" = 77;
     "store_name" = "\U4fe1\U6211\U5bb6\U5b98\U65b9\U56e2\U8d2d\U5e97";
     */
    
    if (!self.selectDic) {
        [ProgressHUD showError:@"请输入地址"];
        return;
    }
    
        
        
        
    NSMutableArray * ridArr = [NSMutableArray array];
    for (NSDictionary *d in self.arr) {
        [ridArr addObject:[NSString stringWithFormat:@"%@",[d objectForKey:@"rec_id"]]];
    }
    
    NSString *recids = [ridArr componentsJoinedByString:@","];
    [dict setValue:[[self.arr objectAtIndex:0] valueForKey:@"store_id"] forKey:@"storeId"];
    [dict setValue:recids forKey:@"recIds"];
    [dict setValue:[self.selectDic objectForKey:@"addr_id"] forKey:@"addrId"];
    
    NSString *liuyan = [self.liuyanTextView.text isEqualToString:@"请留言"]?@"":self.liuyanTextView.text;
    [dict setValue:liuyan forKey:@"postscript"];
    [dict setValue:@"0" forKey:@"shippingId"];
    [dict setValue:@"0" forKey:@"shippingFee"];
    
//    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    
        
        CLog(@"dict %@",dict);
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            CLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *num = [dic objectForKey:@"result"];

            CLog(@"jesun %d",self.payIndex);
            if ([num intValue]== 1) {
                
                if (self.payIndex ==1) {
                    
                    [self createPayRequest:[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]]];
                }else{
                    [ProgressHUD showSuccess:errCode];
                    [self confirmOrder:@"30":[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]]];
                }
//                [self getOrderList:@"30"];
            }else
                [ProgressHUD showError:errCode];
            
        }
        
        /*
         
         *如果订单提交成功  后台给你返回订单id那就把订单id传给下面我写的方法
         
         *把你的订单id传给createPayRequest的参数即可
         
         */
        
//        [self createPayRequest:oid];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    }
}


-(void)confirmOrder:(NSString *)status :(NSString *)orderId{
    
    NSString *url = GETORDERCONFIRM_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:orderId forKey:@"orderId"];
    [dict setValue:status forKey:@"status"];
    
    //    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_id"];
    
    //    [dict setValue:@"1" forKey:@"a_id"];
    //    [dict setValue:[XWJAccount instance].uid forKey:@"userid"];
    /*
     pageindex	第几页	String,从0开始
     countperpage	每页条数	String
     cateId	商户分类	String
     */
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            CLog(@"dic %@",dict);
            NSString *res = [ NSString stringWithFormat:@"%@",[dict objectForKey:@"result"]];
            //            self.orderArr = [dict objectForKey:@"orders"];
            if ([res isEqualToString:@"1"]) {
                
                [ProgressHUD showSuccess:@"您的订单提交完成，如查询订单详情，请进入我的订单进行查看 "];
                [self.navigationController popViewControllerAnimated:NO ];
//                if ([status isEqualToString:@"30"]) {
//                    
//                    [self getOrderList:@"11"];
//                }else if([status isEqualToString:@"40"]){
//                    [self getOrderList:@"30"];
//                }
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getOrderList:(NSString *)status{
    NSString *url = GETORDER_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[XWJAccount instance].account forKey:@"account"];
    [dict setValue:@"0" forKey:@"pageindex"];
    [dict setValue:@"100" forKey:@"countperpage"];
    [dict setValue:status forKey:@"status"];
    
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
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            CLog(@"dic %@",dict);
            self.orderArr = [dict objectForKey:@"orders"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
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
                  [[NSUserDefaults standardUserDefaults] setValue:orderid forKey:@"orderid"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
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
