//
//  XWJGroupViewController.m
//  XWJ
//
//  Created by Sun on 16/1/3.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJGroupViewController.h"
#import "XWJSPDetailViewController.h"
#import "XWJGroupBuyTableViewCell.h"
@interface XWJGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property UITableView *tableView;
@property NSMutableArray *groupBuy;
@end

@implementation XWJGroupViewController
@synthesize tableView,groupBuy;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"团购";
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"XWJTuangouCell" bundle:nil] forCellReuseIdentifier:@"cell2"];

    [self.view addSubview:tableView];
    [self getGroup:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);

            
            groupBuy = [dic objectForKey:@"data"];
            [tableView reloadData];
            tableView.contentSize =CGSizeMake(0,100+self.groupBuy.count*110);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
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
    
    NSLog(@"index path %ld",(long)indexPath.row);
    

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
        cell.price1Label.text = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.price2Label.text = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"old_price"]];
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
