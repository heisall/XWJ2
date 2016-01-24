//
//  XWJAddressController.m
//  XWJ
//
//  Created by Sun on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJAddressController.h"
#import "XWJAccount.h"
#import "XWJAddresCell.h"
#import "ProgressHUD.h"
@interface XWJAddressController()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSMutableArray *array;
//@property UITableView *tableView;
@end
@implementation XWJAddressController
@synthesize  tableview;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址";
    tableview.delegate = self;
    tableview.dataSource = self;
//    [self getAddress];
}
- (IBAction)add:(id)sender {
}

-(void)edit{
    [tableview setEditing:!tableview.editing animated:YES];
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self getAddress];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 30);
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    //    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    if (tableView.tag == TAG) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, SCREEN_SIZE.width, 20)];
//        label.textColor = XWJGREENCOLOR;
//        label.text  = @"支付方式";
//        [view addSubview:label];
//        return view;
//    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (tableView.tag == TAG) {
//        return 40.0;
//    }
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (tableView.tag == TAG) {
//        return self.payarray.count;
//    }
//    return self.arr.count;
    return self.array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.con) {
        self.con.selectDic = [self.array objectAtIndex:indexPath.row] ;
    }
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        NSString *aid = [[self.array objectAtIndex:indexPath.row] objectForKey:@"addr_id"];
        [self delAddress:aid];
        NSMutableArray *arr = self.array;
        [arr removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
        [table deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath]                         withRowAnimation:UITableViewRowAnimationFade];

    }
}

-(void)delAddress:(NSString * )addId{
    NSString *url = DELADDRESS_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:addId  forKey:@"addr_id"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *num = [dic objectForKey:@"result"];
            if ([num intValue]== 1) {
                //                NSMutableArray * arr ;
                
//                [ProgressHUD showSuccess:<#(NSString *)#>];
//                self.array = [dic objectForKey:@"data"];
//                [tableview reloadData];
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    /*
     "addr_id" = 12;
     address = "\U9752\U5c9b\U5c71\U4e1c";
     consignee = sjs;
     "is_default" = 1;
     "phone_tel" = 13100000020;
     "region_id" = 1;
     "region_name" = "\U9752\U5c9b\U5e02";
     */
    XWJAddresCell  *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"addcell"];
    if (!cell) {
        cell = [[XWJAddresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addcell"];
    }
    // Configure the cell...
//    NSString *url = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"goods_image"];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url]];
//    cell.title.text = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
//    cell.price.text = [NSString stringWithFormat:@"%.1f",[[[self.arr objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
//    cell.numLabel.text = [NSString stringWithFormat:@"x%@",[[self.arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
    cell.label1.text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"consignee"];
    cell.label2.text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"phone_tel"];
    cell.label3.text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"region_name"];
    cell.label4.text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"address"];
    
    if([[NSString stringWithFormat:@"%@",[[self.array objectAtIndex:indexPath.row] objectForKey:@"is_default"]]isEqualToString:@"1" ])
        cell.label5.text = @"[默认]";
    else
        cell.label5.text = @"";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
             "addr_id" = 20;
             address = sdfasd;
             consignee = alp;
             "is_default" = 1;
             "phone_tel" = 13500000020;
             "region_id" = 1;
             "region_name" = "\U9752\U5c9b\U5e02";
             */
            if ([num intValue]== 1) {
//                NSMutableArray * arr ;
                
                self.array = [NSMutableArray arrayWithArray:[dic objectForKey:@"data"]];
                [tableview reloadData];

            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    
}
@end
