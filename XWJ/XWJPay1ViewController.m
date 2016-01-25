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
@property NSMutableArray *payListArr;
@property NSMutableArray *roomDic;

@end

@implementation XWJPay1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self headAD];
//    [self getZhangDan];
    
    [self getGuanjiaAD ];
    self.payListArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"物业账单";
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.dataSource = self;
    self.listUnpayBtn.selected = YES;
  //  listUnpayBtn.selected = YES;

    self.array = [NSArray arrayWithObjects:@"青岛市",@"海信花园",@"1号楼1单元101户",@"", nil];
    
}
-(void)headAD{
    NSString *url = GETGUANJIAAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
     a_id	小区a_id	String
     userid	用户id	String
     */
    
    //    [dict setValue:[XWJCity instance].aid  forKey:@"a_id"];
    //    [dict setValue:@"1"  forKey:@"a_id"];
    //    NSString *userid = [XWJAccount in];
    //    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_id"];
    
    //    [dict setValue:@"1" forKey:@"a_id"];
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    
    [dict setValue:[NSString stringWithFormat:@"%@",[XWJAccount instance].uid] forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic哈哈哈 %@",dic);
            
            self.roomDic = [dic objectForKey:@"room"];
            
//            if([XWJAccount instance].isYouke){
//                self.room.text  = @"";
//            }else{
//               self.room.text = [NSString stringWithFormat:@"%@%@号楼%@单元%@",[self.roomDic objectForKey:@"A_name"]==[NSNull null]?@"":[self.roomDic objectForKey:@"A_name"],[self.roomDic objectForKey:@"b_id"]==[NSNull null]?@"":[self.roomDic objectForKey:@"b_id"],[self.roomDic objectForKey:@"r_dy"]==[NSNull null]?@"":[self.roomDic objectForKey:@"r_dy"],[self.roomDic objectForKey:@"r_id"]==[NSNull null]?@"":[self.roomDic objectForKey:@"r_id"]];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getGuanjiaAD{
    NSString *url = GETGUANJIAAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
     a_id	小区a_id	String
     userid	用户id	String
     */
    
    //    [dict setValue:[XWJCity instance].aid  forKey:@"a_id"];
    //    [dict setValue:@"1"  forKey:@"a_id"];
    //    NSString *userid = [XWJAccount in];
    //    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_id"];
    
    //    [dict setValue:@"1" forKey:@"a_id"];
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    
    [dict setValue:[NSString stringWithFormat:@"%@",[XWJAccount instance].uid] forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            
            
            self.roomDic = [dic objectForKey:@"room"];
            
            if([XWJAccount instance].isYouke){

            }else{
//                NSString *str = [NSString stringWithFormat:@"%@%@号楼%@单元%@",[self.roomDic objectForKey:@"A_name"]==[NSNull null]?@"":[self.roomDic objectForKey:@"A_name"],[self.roomDic objectForKey:@"b_id"]==[NSNull null]?@"":[self.roomDic objectForKey:@"b_id"],[self.roomDic objectForKey:@"r_dy"]==[NSNull null]?@"":[self.roomDic objectForKey:@"r_dy"],[self.roomDic objectForKey:@"r_id"]==[NSNull null]?@"":[self.roomDic objectForKey:@"r_id"]];
                
                [self getZhangDan];
            }
            
    
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
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
    
            NSString * bid =[self.roomDic valueForKey:@"b_id"]==[NSNull null]?@"":[self.roomDic valueForKey:@"b_id"];
    NSString *rdy=
    [self.roomDic valueForKey:@"r_dy"]==[NSNull null]?@"":[self.roomDic valueForKey:@"r_dy"];
    NSString *rid= [self.roomDic valueForKey:@"r_id"]==[NSNull null]?@"":[self.roomDic valueForKey:@"r_id"];
        [dict setValue:bid forKey:@"b_id"];
        [dict setValue:rdy forKey:@"r_dy"];
        [dict setValue:rid forKey:@"r_id"];
    
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%s success ",__FUNCTION__);
            
            if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"+++==dic%@",dic);
            self.payListArr = [dic objectForKey:@"data"];
            [self.tableView reloadData];
                NSLog(@"dic ++++%@",self.payListArr);
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
    return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) {
        return self.payListArr.count/3;
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
//    cell.label1.text = [self.payListArr[indexPath.row] objectForKey:@"t_date"];
//    cell.label1.text = @"2012.5";
//    cell.label2.text = @"物业费";
//    cell.label3.text = @"2000.10";
//    cell.label4.text = @"水电费";
//    cell.label5.text = @"1999.10";
//    cell.label6.text = @"1999.10";
//    cell.label7.text = @"1999.10";

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
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
    //r Dispose of any resources that can be recreated.
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
