//
//  XWJJifenController.m
//  XWJ
//
//  Created by Sun on 16/1/21.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJJifenController.h"
#import "XWJJifenCell.h"
#import "XWJSPDetailViewController.h"
#import "XWJAccount.h"
#import "ProgressHUD/ProgressHUD.h"
@interface XWJJifenController()<UITableViewDataSource,UITableViewDelegate>
@property NSArray *array;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *iBtn;
@end
@implementation XWJJifenController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title  = @"积分兑换";
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    
    [self.allBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (self.allBtn.selected) {
            [self getJifenList:@"0"];
        }else{
            [self getJifenList:@"1"];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)quanbuClick:(UIButton *)sender {
    self.allBtn.selected = YES;
    self.iBtn.selected  = NO;
    [self getJifenList:@"0"];
    
}
- (IBAction)icanClick:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.iBtn.selected  = YES;
    [self getJifenList:@"1"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 275;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJJifenCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJJifenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    /*
     "default_image" = "http://admin.hisenseplus.com/ecmall/data/files/store_188/goods_75/small_201601121811157475.jpg";
     "end_time" = "1970-01-01";
     "goods_id" = 167;
     "goods_name" = "\U94b3\U5b50";
     "old_price" = 0;
     price = 200;
     */
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[self.array objectAtIndex:0] valueForKey:@"default_image"]] placeholderImage:[UIImage imageNamed:@"demo"]];
    cell.content.text = [[self.array objectAtIndex:0] valueForKey:@"goods_name"];
    cell.jifenLabel.text = [NSString stringWithFormat:@"所需积分：￥%.2f",[[[self.array objectAtIndex:0] valueForKey:@"price"] floatValue]];
    cell.priceLabel.text = [NSString stringWithFormat:@"市场价：￥%.2f",[[[self.array objectAtIndex:0] valueForKey:@"old_price"] floatValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWJSPDetailViewController *list= [[XWJSPDetailViewController alloc] init];
    //    list.dic = [self.goodsArr objectAtIndex:indexPath.row];
    list.goods_id = [[self.array objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
    list.isFromJifen = YES;
    [self.navigationController showViewController:list sender:self];
}
//积分数据的请求
-(void)getJifenList:(NSString *)type{

    NSString *url = GETJIFEN_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[XWJAccount instance].account forKey:@"account"];
    [dict setValue:type  forKey:@"type"];
    [dict setValue:@"0" forKey:@"pageindex"];
    [dict setValue:@"100"  forKey:@"countperpage"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            self.array = [dic objectForKey:@"data"];
            [self.tableView.mj_header endRefreshing];

            [self.tableView reloadData];
            NSArray *arr  = [dic objectForKey:@"data"];
            for (NSDictionary *d in arr) {
                CLog(@"dic %@",d);
            }
            
            CLog(@"dic %@",dic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);

    }];
}

@end
