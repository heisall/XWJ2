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
@interface XWJPay1ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSArray *array;

@end

@implementation XWJPay1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"物业账单";
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.dataSource = self;
    
    self.array = [NSArray arrayWithObjects:@"青岛市",@"海信花园",@"1号楼1单元101户",@"", nil];
    [self getZhangDan];
}

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
        
//        XWJAccount *account = [XWJAccount instance];
//        //    [dict setValue:account.uid forKey:@"userid"];
//        [dict setValue:@"1" forKey:@"userid"];
//        
//        if (self.type==1) {
//            
//            [dict setValue:@"维修" forKey:@"type"];
//        }else
//            [dict setValue:@"投诉" forKey:@"type"];
    
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
//        [dict setValue:@"1" forKey:@"a_id"];
        [dict setValue:@"1" forKey:@"b_id"];
        [dict setValue:@"1" forKey:@"r_dy"];
        [dict setValue:@"101" forKey:@"r_id"];
    
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%s success ",__FUNCTION__);
            
            if(responseObject){
                NSDictionary *dic = (NSDictionary *)responseObject;
                
                //            NSMutableArray * array = [NSMutableArray array];
                //            XWJCity *city  = [[XWJCity alloc] init];
                
                //            NSArray *arr  = [dic objectForKey:@"data"];
                //            [self.houseArr removeAllObjects];
                //            [self.houseArr addObjectsFromArray:arr];
                //            [self.tableView reloadData];
                NSLog(@"dic %@",dic);
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%s fail %@",__FUNCTION__,error);
            
        }];
    
    
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30.0;
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"物业员工";
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) {
        return self.array.count;
//    }
//    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    XWJPay1TableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"pay1cell"];
    if (!cell) {
        cell = [[XWJPay1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay1cell"];
    }
    // Configure the cell...
//    cell.headImageView.image = [UIImage imageNamed:@"xinfangbackImg"];
    
    
    cell.imageView.image = [UIImage imageNamed:@"wuyezhangdan1"];
    cell.imageView.highlightedImage = [UIImage imageNamed:@"wuyezhangdan2"];
    cell.label1.text = @"2015.12";
    cell.label2.text = @"物业费";
    cell.label3.text = @"2000.10";
    cell.label4.text = @"水电费";
    cell.label5.text = @"1999.10";
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (IBAction)qubuZD:(id)sender {
}
- (IBAction)weijiao:(UIButton *)sender {
}
- (IBAction)quanXuan:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
        
//        NSArray *controllers = self.navigationController.viewControllers;
//        UIViewController *controller = [controllers objectAtIndex:indexPath.row+1];
//        [self.navigationController popToViewController:controller animated:YES];
        
    }
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    //        [self.navigationController showViewController:[storyboard instantiateViewControllerWithIdentifier:@"suggestStory"] sender:nil];
    
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
