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
@interface XWJJiesuanViewController ()<UITableViewDataSource,UITableViewDelegate>
@property NSArray *array;
@property NSArray *payarray;
@property NSArray *zhifuIconArr;
//@property NSDictionary *addressDic;
@end

@implementation XWJJiesuanViewController
#define TAG 1
- (void)viewDidLoad {
    [super viewDidLoad];
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

    self.payTableView.dataSource  = self;
    self.payTableView.delegate = self;
    NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
    [self.payTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    //    self.payTableView.contentSize = CGSizeMake(0, 30+3*60);
    self.shangpinTableView.dataSource  = self;
    self.shangpinTableView.delegate = self;
    self.shangpinTableView.frame = CGRectMake(0, self.shangpinTableView.frame.origin.y, self.shangpinTableView.frame.size.width, self.arr.count*90);
    self.tableConstraint.constant = self.arr.count*90;
    
//    self.scrollView.contentSize = CGSizeMake(0, self.shangpinTableView.frame.origin.y+self.tableConstraint.constant);
    self.scrollView.contentSize = CGSizeMake(0, 1500);

    [self getAddress];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
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
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
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
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
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
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *num = [dic objectForKey:@"result"];
            
            if ([num intValue]== 1) {
                [ProgressHUD showSuccess:errCode];
            }else
                [ProgressHUD showError:errCode];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

- (IBAction)p:(id)sender {
 
    if (self.isFromJiFen) {
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
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *num = [dic objectForKey:@"result"];

            if ([num intValue]== 1) {
                [ProgressHUD showSuccess:errCode];
                
            }else
                [ProgressHUD showError:errCode];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    }
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
