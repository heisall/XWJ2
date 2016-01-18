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

@interface XWJMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,OrderFinishTableViewCellDelegate,UMSocialUIDelegate,EvaluationViewControllerDelegate,MyOrderDetailViewControllerDelegate,XWJOrderTableViewCellDelegate>

@property NSMutableArray *btn;
@property NSMutableArray *cornerBtn;
@property UITableView *tableView;
@property NSMutableArray *orderArr;
@property NSDictionary *dic;
@property NSDictionary *statusDic;
@property NSInteger index; // 0待付款 1代收货 2已完成
@property NSArray *status;
//@property NSInteger orderType;// 0待付款 1代收货 2已完成
@property(nonatomic,copy)NSString* deleOrderId;
@property(nonatomic,assign)NSInteger deleOrderNum;
@property(nonatomic,retain)NSMutableArray* dataSourceArr;
@end

@implementation XWJMyOrderViewController
@synthesize statusDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArr = [[NSMutableArray alloc] init];
    self.orderArr = [[NSMutableArray alloc] init];
    self.navigationItem.title  = @"我的订单";
    self.status = [NSArray arrayWithObjects:@"11",@"30",@"40", nil];
    statusDic = [NSDictionary dictionaryWithObjectsAndKeys:@"待付款",@"11",@"待收货",@"30",@"待评价",@"40", nil];

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
}
#pragma mark - 订单列表删除订单
- (void)delegateMyOrder:(NSInteger)index{
    NSLog(@"----列表删除订单---%ld",index);
    self.deleOrderNum = index;
    [self createDeleOrderRequest];
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
    NSLog(@"-----删除%ld\n---%@",cellNum,self.orderArr);
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
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dict);
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
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
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
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dict);
            self.orderArr = [dict objectForKey:@"orders"];
            
            self.dic = [dict objectForKey:@"orderCount"];
            
            [self updateCount:self.dic];
            
            if (2 == self.index) {
                self.dataSourceArr = [[NSMutableArray alloc] init];
                for (NSDictionary* temDic in self.orderArr) {
                    OrderFinishModel* model = [[OrderFinishModel alloc] init];
                    //cell.priceLabel.text = [NSString stringWithFormat:@"￥%.1f x %@",[pri floatValue],[[arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
                    model.headImageStr = temDic[@"goods_image"];
                    NSLog(@"======头像地址====%@",model.headImageStr);
                    model.titleStr = temDic[@"goods_name"];
                    model.e_status = [temDic[@"e_status"] integerValue];
                    model.orderId = temDic[@"order_id"];
                    model.seller_id = temDic[@"seller_id"];
                    model.goodsId = temDic[@"goods_id"];
                    model.priceAndTimeStr = [NSString stringWithFormat:@"￥%.1f   收货时间：%@",[temDic[@"price"] floatValue],temDic[@"add_time"]];
                    [self.dataSourceArr addObject:model];
                }
                NSLog(@"我新创建的数据源------%@",self.dataSourceArr);
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
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
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
    
    footer.yunfeiLabel.text = [NSString stringWithFormat:@"运费：￥%.1f",[yunf floatValue]];
    float num =0.0;
    for (NSDictionary *d in detail) {
        
        NSString *n = [NSString stringWithFormat:@"%@",[d objectForKey:@"quantity"]] ;
        NSString *p = [NSString stringWithFormat:@"%@",[d objectForKey:@"price"]] ;
        num = num + n.floatValue*p.floatValue;
    }
    footer.delegateMyOrderDelegate = self;
    footer.cellIndex  = section;
    footer.priceLabel.text = [NSString stringWithFormat:@"￥%.1f",num];
    
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
    //确认收货
        NSString * oid =[NSString stringWithFormat:@"%@",[[self.orderArr objectAtIndex:index] valueForKey:@"order_id"]] ;
        [self confirmOrder:@"40" :oid];
    }else if(self.index==0){
        NSString * oid =[NSString stringWithFormat:@"%@",[[self.orderArr objectAtIndex:index] valueForKey:@"order_id"]] ;
        [self confirmOrder:@"30" :oid];
    }
    
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
    
    NSLog(@"index path %ld",(long)indexPath.row);
    XWJOrderTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *arr =(NSArray * )[[self.orderArr objectAtIndex:indexPath.section] objectForKey:@"detail"];
    
    cell.contentLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    NSString *pri = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] valueForKey:@"price"]];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.1f x %@",[pri floatValue],[[arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
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
#pragma mark - 评论代理实现
- (void)pinglun:(NSInteger)index{
    NSLog(@"评论----%ld",(long)index);
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
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
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
    NSInteger count = 3;
    CGFloat width = self.view.bounds.size.width/count;
    CGFloat height = 40;
    CGFloat btny = 66;
    NSArray * title = [NSArray arrayWithObjects:@"待付款",@"待收货",@"已完成", nil];
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, btny, width, height);
        button.tag = i;
        
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setBackgroundImage:[UIImage imageNamed:@"shuoselect"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"shuonormal"] forState:UIControlStateNormal];
        
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, btny+height, SCREEN_SIZE.width, SCREEN_SIZE.height-btny+height)];
    [self.view addSubview:self.tableView];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.index = 0;
    ((UIButton*)self.btn[self.index]).selected=YES;
    [((UIButton*)self.btn[self.index]) sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(void)typeclick:(UIButton *)butn{
    self.index = butn.tag;
    NSLog(@"当前点中按钮tag---%ld",(long)butn.tag);
    for (UIButton *b in self.btn) {
        b.selected = NO;
    }
    butn.selected = !butn.selected;
    
    [self getOrderList:[self.status objectAtIndex:self.index]];
    
    
}

#pragma mark - 删除订单数据请求
- (void)createDeleOrderRequest{
    NSArray *arr =(NSArray * )[[self.orderArr objectAtIndex:self.deleOrderNum] objectForKey:@"detail"];
    for (NSDictionary* temDic in arr) {
        self.deleOrderId = temDic[@"order_id"];
    }
    
    NSLog(@"请求的参数----%@\n----%@",self.deleOrderId,DELEORDER);
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
                 NSMutableArray* tArr = [[NSMutableArray alloc] init];
                 [tArr addObjectsFromArray:self.orderArr];
                 NSLog(@"-----请求删除---%ld",self.deleOrderNum);
                 [tArr removeObjectAtIndex:self.deleOrderNum];
                 self.orderArr =  [[NSMutableArray alloc] init];
                 [self.orderArr addObjectsFromArray:tArr];
                 [_tableView reloadData];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"失败===%@", error);
         }];
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
