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
@interface XWJJiesuanViewController ()<UITableViewDataSource,UITableViewDelegate>
@property NSArray *array;
@property NSArray *payarray;
@property NSArray *zhifuIconArr;
@end

@implementation XWJJiesuanViewController
#define TAG 1
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户结算";
    // Do any additional setup after loading the view.
    
    self.scrollView.contentSize = CGSizeMake(0, 1000);
//    self.array = [NSArray arrayWithObjects:@"青岛市",@"海信花园",@"1号楼1单元101户", nil];
    self.payarray = [NSArray arrayWithObjects:@"货到付款",@"微信支付", nil];
    self.zhifuIconArr = [NSArray arrayWithObjects:@"",@"zhifuweixin", nil];
    
    [self.shangpinTableView registerNib:[UINib nibWithNibName:@"XWJJiesuanCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    [self.payTableView registerNib:[UINib nibWithNibName:@"XWJPayWayView" bundle:nil] forCellReuseIdentifier:@"paycell"];

    float money =  [self.price floatValue]+8.0;
    self.totalLabel.text = [NSString stringWithFormat:@"￥ %.1f",[self.price floatValue]];
    self.payTableView.dataSource  = self;
    self.payTableView.delegate = self;
    NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
    [self.payTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    //    self.payTableView.contentSize = CGSizeMake(0, 30+3*60);
    self.shangpinTableView.dataSource  = self;
    self.shangpinTableView.delegate = self;
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
    cell.price.text = [NSString stringWithFormat:@"%.1f",[[[self.arr objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
    cell.numLabel.text = [NSString stringWithFormat:@"x%@",[[self.arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
        LocationPickerVC *locationPickerVC = [[LocationPickerVC alloc] initWithNibName:@"LocationPickerVC" bundle:nil];
//    [self.navigationController showViewController:locationPickerVC sender:nil];
    locationPickerVC.con = self;
    [self.navigationController pushViewController:locationPickerVC animated:YES];
}
- (IBAction)p:(id)sender {
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
