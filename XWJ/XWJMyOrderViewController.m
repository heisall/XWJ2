//
//  XWJMyOrderViewController.m
//  XWJ
//
//  Created by Sun on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJMyOrderViewController.h"
#import "XWJOrderFooter.h"
#import "XWJOrderHeader.h"
#import "XWJOrderTableViewCell.h"
#import "XWJAccount.h"

#import "OrderFinishModel.h"
#import "OrderFinishTableViewCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "EvaluationViewController.h"
#import "UMSocial.h"

#import "MyOrderDetailViewController.h"

#import "ReturnIP.h"
#import "WXApi.h"
#import "CommonUtil.h"
@interface XWJMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,OrderFinishTableViewCellDelegate,UMSocialUIDelegate,EvaluationViewControllerDelegate,MyOrderDetailViewControllerDelegate,XWJOrderTableViewCellDelegate,UIAlertViewDelegate>{
 
    NSInteger deleOrderNum;

}

@property NSMutableArray *btn;
@property NSMutableArray *cornerBtn;
@property UITableView *tableView;
@property NSMutableArray *orderArr;
@property NSDictionary *dic;
@property NSDictionary *statusDic;
@property NSInteger index; // 0待付款 1代收货 2已完成
@property NSArray *status;
@property UILabel *label;
@property NSArray *noDataArr;
//@property NSInteger orderType;// 0待付款 1代收货 2已完成
@property(nonatomic,copy)NSString* deleOrderId;
@property(nonatomic,retain)NSMutableArray* dataSourceArr;



@property(nonatomic,copy)NSString* ipStr;
@property(nonatomic,copy)NSString* prePayIdStr;
@property(nonatomic,copy)NSString* myNoncestr;
@property(nonatomic,copy)NSString* apikeystr;
@property(nonatomic,copy)NSString* appid;
@property(nonatomic,copy)NSString* parterid;
@end

/** 获取prePayId的url, 这是官方给的接口 */
NSString * const getPrePayIdUrl = @"https://api.mch.weixin.qq.com/pay/unifiedorder";

@implementation XWJMyOrderViewController
@synthesize statusDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ipStr = [ReturnIP deviceIPAdress];
    
    self.dataSourceArr = [[NSMutableArray alloc] init];
    self.orderArr = [[NSMutableArray alloc] init];
    self.navigationItem.title  = @"我的订单";
    self.status = [NSArray arrayWithObjects:@"11",@"30",@"40", nil];
    statusDic = [NSDictionary dictionaryWithObjectsAndKeys:@"待付款",@"11",@"待收货",@"30",@"待评价",@"40", nil];
    
    self.noDataArr = [NSArray  arrayWithObjects:@"暂无待付款订单",@"暂无待收货订单",@"暂无已完成订单",nil];
    //默认当前选中按钮是第0个
    [self addView];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJOrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJOrderCellHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJOrderCellFooter" bundle:nil] forHeaderFooterViewReuseIdentifier:@"footer"];
    
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [self getOrderList:[self.status objectAtIndex:self.index]];
    }];    // Do any additional setup after loading the view.
    
    [WXApi registerApp:@"wx706df433748af20c" withDescription:@"demo 2.0"];
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
    
}
- (void)paySuccess:(NSNotification *)text{
    
//    [((UIButton*)self.btn[1]) sendActionsForControlEvents:UIControlEventTouchUpInside];
    CLog(@"%@",text.userInfo[@"paySuccess"]);
    CLog(@"－－－－－接收到通知------");
    NSMutableArray* tArr = [[NSMutableArray alloc] init];

    int zhifuCount = ((UIButton *)self.cornerBtn[0]).titleLabel.text.intValue;
    int shouhuoCount = 0;
    if (![((UIButton *)self.cornerBtn[1]).titleLabel.text isEqualToString:@""]) {
        shouhuoCount = ((UIButton *)self.cornerBtn[1]).titleLabel.text.intValue;
    }
    zhifuCount--;
    shouhuoCount++;

        [self.cornerBtn[0] setTitle:[NSString stringWithFormat:@"%d",zhifuCount] forState:UIControlStateNormal];
    if (zhifuCount==0) {
        ((UIButton *)self.cornerBtn[0]).hidden = YES;
    }

    [self.cornerBtn[1] setTitle:[NSString stringWithFormat:@"%d",shouhuoCount] forState:UIControlStateNormal];
    ((UIButton *)self.cornerBtn[1]).hidden = NO;
    
    [tArr addObjectsFromArray:self.orderArr];
    for (int i = 0; i < tArr.count; i++) {
        NSString * oid = [NSString stringWithFormat:@"%@",[[self.orderArr objectAtIndex:i] valueForKey:@"order_id"]] ;
        CLog(@"----%@",oid);
        if ([text.userInfo[@"paySuccess"] isEqualToString:oid]) {
            [tArr removeObjectAtIndex:i];
            self.orderArr =  [[NSMutableArray alloc] init];
            [self.orderArr addObjectsFromArray:tArr];
            [_tableView reloadData];
        }
    }
}
#pragma mark - 订单列表删除订单
- (void)delegateMyOrder:(NSInteger)index{
    CLog(@"----列表删除订单---%ld",index);
    
    deleOrderNum = index;
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertview show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        if (1 == buttonIndex) {
            //确认收货
            NSString * oid =[NSString stringWithFormat:@"%@",[[self.orderArr objectAtIndex:(alertView.tag-100)] valueForKey:@"order_id"]] ;
            [self confirmOrder:@"40" :oid];
        }
    }else{
        if(buttonIndex==0){
            [self createDeleOrderRequest];
        }
    }
    
}
#pragma mark - 评论代理实现
- (void)sendBackCellNum:(NSInteger)cellNum{
    OrderFinishModel* model = self.dataSourceArr[cellNum];
    model.e_status = 1;
    [_tableView reloadData];
}
#pragma mark - 确认收货代理实现
- (void)makeSureOrder:(NSInteger)cellNum{
    /*
     *这个地方我处理了一下   因为之前的self.orderArr在请求数据完成的时候  赋值的方式被强制修改成了不可变数组
     *我在这个地方把self.orderArr改成可变数组进行数据的删除  然后刷新列表
     */
    CLog(@"-----删除%ld\n---%@",cellNum,self.orderArr);
    NSMutableArray* tArr = [[NSMutableArray alloc] init];
    [tArr addObjectsFromArray:self.orderArr];
    [tArr removeObjectAtIndex:cellNum];
    self.orderArr =  [[NSMutableArray alloc] init];
    [self.orderArr addObjectsFromArray:tArr];
    [_tableView reloadData];
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
                
                if ([status isEqualToString:@"30"]) {
                    
                    [self getOrderList:@"11"];
                }else if([status isEqualToString:@"40"]){
                    [self getOrderList:@"30"];
                }
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
            
            self.dic = [dict objectForKey:@"orderCount"];
            
            [self updateCount:self.dic];
            
            if (2 == self.index) {
                self.dataSourceArr = [[NSMutableArray alloc] init];
                for (NSDictionary* temDic in self.orderArr) {
                    OrderFinishModel* model = [[OrderFinishModel alloc] init];
                    //cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f x %@",[pri floatValue],[[arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
                    model.headImageStr = temDic[@"goods_image"];
                    CLog(@"======头像地址====%@",model.headImageStr);
                    model.titleStr = temDic[@"goods_name"];
                    model.e_status = [temDic[@"e_status"] integerValue];
                    model.orderId = temDic[@"order_id"];
                    model.seller_id = temDic[@"seller_id"];
                    model.goodsId = temDic[@"goods_id"];
                    model.priceAndTimeStr = [NSString stringWithFormat:@"￥%.2f   收货时间：%@",[temDic[@"price"] floatValue],temDic[@"add_time"]];
                    [self.dataSourceArr addObject:model];
                }
                CLog(@"我新创建的数据源------%@",self.dataSourceArr);
            }
            
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            
            NSInteger cellNum = 0 ;
            for (NSDictionary *d in self.orderArr) {
                NSArray *arr =(NSArray * )[d objectForKey:@"detail"];
                cellNum = cellNum+arr.count;
            }
            
            [self.tableView.mj_header endRefreshing];
            self.tableView.contentSize =CGSizeMake(0,self.orderArr.count*(40+60)+cellNum*95+100);
            
            if (self.index == 0) {
                if (self.orderArr.count>0) {
                    self.label.hidden =YES;
                }else{
                    self.label.hidden = NO;
                    self.label.text = self.noDataArr[self.index];
                }
                
            }else if(self.index == 1){
                if (self.orderArr.count>0) {
                    self.label.hidden =YES;
                }else{
                    self.label.hidden = NO;
                    self.label.text = self.noDataArr[self.index];
                }
            }else {
                if (self.dataSourceArr.count>0) {
                    self.label.hidden =YES;
                }else{
                    self.label.hidden = NO;
                    self.label.text = self.noDataArr[self.index];
                }
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)updateCount:(NSDictionary *)dict{
    //    [self.cornerBtn[0] setTitle:[NSString stringWithFormat:@"%@",[dict objectForKey:@"all_pay_num"]] forState:UIControlStateNormal];
    
    
    [self.cornerBtn[0] setTitle:[NSString stringWithFormat:@"%@",[dict objectForKey:@"no_pay_num"]] forState:UIControlStateNormal];
    [self.cornerBtn[1] setTitle:[NSString stringWithFormat:@"%@",[dict objectForKey:@"no_receive_num"]] forState:UIControlStateNormal];
    [self.cornerBtn[2] setTitle:[NSString stringWithFormat:@"%@",[dict objectForKey:@"no_evaluation_num"]] forState:UIControlStateNormal];
    
    //    [self.cornerBtn[0] setHidden:[[NSString stringWithFormat:@"%@",[dict objectForKey:@"all_pay_num"]] isEqualToString:@"0"]];
    [self.cornerBtn[0] setHidden:[[NSString stringWithFormat:@"%@",[dict objectForKey:@"no_pay_num"]] isEqualToString:@"0"]];
    [self.cornerBtn[1] setHidden:[[NSString stringWithFormat:@"%@",[dict objectForKey:@"no_receive_num"]] isEqualToString:@"0"]];
    [self.cornerBtn[2] setHidden:[[NSString stringWithFormat:@"%@",[dict objectForKey:@"no_evaluation_num"]] isEqualToString:@"0"]];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (2 == self.index) {
        return 1;
    }
    return self.orderArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (2 == self.index) {
        OrderFinishModel *model = nil;
        if (indexPath.row < self.dataSourceArr.count) {
            model = [self.dataSourceArr objectAtIndex:indexPath.row];
        }
        return [OrderFinishTableViewCell hyb_heightForIndexPath:indexPath config:^(UITableViewCell *sourceCell) {
            OrderFinishTableViewCell *cell = (OrderFinishTableViewCell *)sourceCell;
            // 配置数据
            [cell configueUI:model];
        }];
    }
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (2 == self.index) {
        return 0;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (2 == self.index) {
        return 0;
    }
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)table viewForHeaderInSection:(NSInteger)section{
    XWJOrderHeader *header;
    header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    header.contentLabel.text  = [[self.orderArr objectAtIndex:section] objectForKey:@"seller_name"];
    header.statusLabel.text  = [statusDic objectForKey:[NSString stringWithFormat:@"%@",[[self.orderArr objectAtIndex:section] objectForKey:@"status"]]];
    
    [header.imgVIew sd_setImageWithURL:[NSURL URLWithString:[[self.orderArr objectAtIndex:section] objectForKey:@"store_logo"]!=[NSNull null]?[[self.orderArr objectAtIndex:section] objectForKey:@"store_logo"]:@""] placeholderImage:[UIImage imageNamed:@"demo"]];
    header.imgVIew.layer.cornerRadius = header.imgVIew.bounds.size.width/2;
    //    header.imgVIew.layer.masksToBounds = YES;
    //    [header.imgVIew sd_setImageWithURL:[NSURL URLWithString:[[self.orderArr objectAtIndex:section] objectForKey:@"store_logo"]!=[NSNull null]?[[self.orderArr objectAtIndex:section] objectForKey:@"store_logo"]:@""] placeholderImage:[UIImage imageNamed:@"demo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        header.imgVIew.layer.cornerRadius = header.imgVIew.bounds.size.width/2;
    //        header.imgVIew.image = image;
    //    }];
    
    if (2 == self.index) {
        return nil;
    }
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    XWJOrderFooter *footer;
    footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    
    NSArray * detail = (NSArray *)[[self.orderArr objectAtIndex:section] objectForKey:@"detail"];
    footer.numLabel.text = [NSString stringWithFormat:@"共计%ld件商品",detail.count];
    NSString *yunf =[NSString stringWithFormat:@"%@",[[self.orderArr objectAtIndex:section] objectForKey:@"shipping_fee"]];
    
    footer.yunfeiLabel.text = [NSString stringWithFormat:@"运费：￥%.2f",[yunf floatValue]];
    float num =0.0;
    for (NSDictionary *d in detail) {
        
        NSString *n = [NSString stringWithFormat:@"%@",[d objectForKey:@"quantity"]] ;
        NSString *p = [NSString stringWithFormat:@"%@",[d objectForKey:@"price"]] ;
        num = num + n.floatValue*p.floatValue;
    }
    footer.delegateMyOrderDelegate = self;
    footer.cellIndex  = section;
    footer.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",num];
    
    footer.delBtn.layer.masksToBounds = YES;
    footer.delBtn.layer.cornerRadius = 6.0;
    footer.delBtn.layer.borderWidth = 1.0;
    footer.delBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    if (2 == self.index) {
        return nil;
    }else if(1 == self.index){
        footer.delBtn.hidden = YES;
        [footer.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        footer.payBtn.tag = section;
        [footer.payBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if(0== self.index){
        footer.delBtn.hidden = NO;
        footer.delBtn.tag = section;
        [footer.delBtn addTarget:self action:@selector(delClick:) forControlEvents:UIControlEventTouchUpInside
         ];
        [footer.payBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        [footer.payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        footer.payBtn.tag = section;
    }
    
    return footer;
}

-(void)delClick:(UIButton *)btn{
    NSInteger index = btn.tag;
    [self delegateMyOrder:index];
}

-(void)payClick:(UIButton *)btn{
    
    NSInteger index = btn.tag;
    if(self.index==1){
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您确定进行确认收货吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 100+index;
        CLog(@"-----%ld",alert.tag);
        [alert show];
        
    }else if(self.index==0){
        NSString * oid =[NSString stringWithFormat:@"%@",[[self.orderArr objectAtIndex:index] valueForKey:@"order_id"]] ;
        
        
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",index] forKey:@"payorderindex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        [self confirmOrder:@"30" :oid];
        [self createPayRequest:oid];
    }
    
}
-(void)get30Pay{
    //    [[NSUserDefaults standardUserDefaults] setValue:orderid forKey:@"orderid"];
    //        NSString *orderid  =[[NSUserDefaults standardUserDefaults] valueForKey:@"orderid"];
    //        [self confirmOrder:@"30" :orderid];
    [self getOrderList:@"11"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (2 == self.index) {
        return self.dataSourceArr.count;
    }
    if ([[self.orderArr objectAtIndex:section] objectForKey:@"detail"]!=[NSNull null]) {
        
        return ((NSArray *)[[self.orderArr objectAtIndex:section] objectForKey:@"detail"]).count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLog(@"index path %ld",(long)indexPath.row);
    XWJOrderTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *arr =(NSArray * )[[self.orderArr objectAtIndex:indexPath.section] objectForKey:@"detail"];
    
    cell.contentLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    NSString *pri = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] valueForKey:@"price"]];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f x %@",[pri floatValue],[[arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_image"]!=[NSNull null]?[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_image"]:@""] placeholderImage:[UIImage imageNamed:@"demo"]];
    
    //        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"]] ];
    //    }
    if (2 == self.index) {
        OrderFinishTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID2"];
        if (!cell) {
            cell = [[OrderFinishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        cell.OrderFinishDelegate = self;
        cell.cellIndex = indexPath.row;
        OrderFinishModel* model = self.dataSourceArr[indexPath.row];
        [cell configueUI:model];
        return cell;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:@"refreshorder"];
}
#pragma mark - 评论代理实现
- (void)pinglun:(NSInteger)index{
    CLog(@"评论----%ld",(long)index);
    OrderFinishModel* model = self.dataSourceArr[index];
    EvaluationViewController* vc = [[EvaluationViewController alloc] init];
    vc.headImageStr = model.headImageStr;
    vc.titleStr = model.titleStr;
    vc.priceAndTimeStr = model.priceAndTimeStr;
    vc.orderId = model.orderId;
    vc.storeId = model.seller_id;
    vc.goodsId = model.goodsId;
    vc.evaluationDelegate = self;
    vc.commentNumSuccess = index;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (2 == self.index) {
        //        UIImageView* temIV = [[UIImageView alloc] init];
        //
        //        OrderFinishModel* model = self.dataSourceArr[indexPath.row];
        //        [temIV sd_setImageWithURL:[NSURL URLWithString:model.headImageStr] placeholderImage:[UIImage imageNamed:@"devAdv_default"]];
        //        [UMSocialSnsService presentSnsIconSheetView:self
        //                                             appKey:@"56938a23e0f55aac1d001cb6"
        //                                          shareText:model.titleStr
        //                                         shareImage:temIV.image
        //                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
        //                                           delegate:self];
        
    }else{
        NSArray *arr =(NSArray * )[[self.orderArr objectAtIndex:indexPath.section] objectForKey:@"detail"];
        MyOrderDetailViewController* vc = [[MyOrderDetailViewController alloc] init];
        if (0 == self.index) {
            vc.isDaishouhuo = @"0";
            vc.status = @"11";
        }else{
            vc.isDaishouhuo = @"1";
            vc.status = @"30";
        }
        vc.makeSureDelegate = self;
        vc.makeUsreNum = indexPath.section;
        vc.orderId = [[arr objectAtIndex:indexPath.row] objectForKey:@"order_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        CLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
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
    self.btn = [NSMutableArray array];
    self.cornerBtn = [NSMutableArray array];
    NSArray * title = [NSArray arrayWithObjects:@"待付款",@"待收货",@"已完成", nil];
    
    NSInteger count = title.count;
    CGFloat width = self.view.bounds.size.width/count;
    CGFloat height = 40;
    CGFloat btny = 66;
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, btny, width, height);
        button.tag = i;
        
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setBackgroundImage:[UIImage imageNamed:@"shuoselect"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"shuonormal"] forState:UIControlStateSelected];
        
        [button setTitleColor:XWJColor(77, 78, 79) forState:UIControlStateNormal];
        [button setTitleColor:XWJGREENCOLOR forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(typeclick:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *corner = [UIButton buttonWithType:UIButtonTypeCustom];
        corner.frame = CGRectMake(width-17, 3, 15, 15);
        corner.enabled = NO;
        [corner setTitle:@"3" forState:UIControlStateNormal];
        corner.backgroundColor = XWJGREENCOLOR;
        corner.titleLabel.font = [UIFont systemFontOfSize:10];
        corner.hidden = YES;
        corner.layer.cornerRadius = 7.5;
        [button addSubview:corner];
        [self.btn addObject:button];
        [self.cornerBtn addObject:corner];
        
        [self.view addSubview:button];
        
    }
    self.index = 0;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0,50, SCREEN_SIZE.width, 40)];
    self.label.textAlignment  = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, btny+height, SCREEN_SIZE.width, SCREEN_SIZE.height-btny+height)];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.label];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    ((UIButton*)self.btn[self.index]).selected=YES;
    [((UIButton*)self.btn[self.index]) sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(void)typeclick:(UIButton *)butn{
    self.index = butn.tag;
    CLog(@"当前点中按钮tag---%ld",(long)butn.tag);
    for (UIButton *b in self.btn) {
        b.selected = NO;
    }
    butn.selected = !butn.selected;
    [self getOrderList:[self.status objectAtIndex:self.index]];
    
    
}

#pragma mark - 删除订单数据请求
- (void)createDeleOrderRequest{
    NSArray *arr =(NSArray * )[[self.orderArr objectAtIndex:deleOrderNum] objectForKey:@"detail"];
    if (arr.count==0) {
        self.deleOrderId = [[self.orderArr objectAtIndex:deleOrderNum] objectForKey:@"order_id"];
    }else
    for (NSDictionary* temDic in arr) {
        self.deleOrderId = temDic[@"order_id"];
    }
    
    if (!self.deleOrderId) {
        return;
    }
    
    CLog(@"请求的参数----%@\n----%@",self.deleOrderId,DELEORDER);
    NSString* requestAddress = DELEORDER;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:requestAddress parameters:@{
                                             @"orderId":self.deleOrderId,
                                             }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([[responseObject objectForKey:@"result"] intValue]) {
                 /*
                  *这个地方我处理了一下   因为之前的self.orderArr在请求数据完成的时候  赋值的方式被强制修改成了不可变数组
                  *我在这个地方把self.orderArr改成可变数组进行数据的删除  然后刷新列表
                  */
//                 NSMutableArray* tArr = [[NSMutableArray alloc] init];
//                 [tArr addObjectsFromArray:self.orderArr];
//                 CLog(@"-----请求删除---%ld",self.deleOrderNum);
//                 [tArr removeObjectAtIndex:self.deleOrderNum];
//                 self.orderArr =  [[NSMutableArray alloc] init];
//                 [self.orderArr addObjectsFromArray:tArr];
//                 [_tableView reloadData];
                 
                 [self getOrderList:[self.status objectAtIndex:self.index]];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             CLog(@"失败===%@", error);
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
