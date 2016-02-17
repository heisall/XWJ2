//
//  XWJPay3ViewController.m
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJPay3ViewController.h"
#import "XWJdef.h"
#import "XWJPayWayTableViewCell.h"
@interface XWJPay3ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSArray *array;
@property NSArray *payarray;
@property NSArray *zhifuIconArr;
@property CGFloat height;
@end

#define  TAG 100
@implementation XWJPay3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"确认订单";
    self.tabBarController.tabBar.hidden = YES;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJPayWayView" bundle:nil] forCellReuseIdentifier:@"pay3cell2"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.payTableView.delegate = self;
    self.payTableView.dataSource = self;
    self.payTableView.tag = TAG;
    
    self.array = [NSArray arrayWithObjects:@"青岛市",@"海信花园",@"1号楼1单元101户", nil];
    self.payarray = [NSArray arrayWithObjects:@"微信支付", nil];
    self.zhifuIconArr = [NSArray arrayWithObjects:@"zhifuweixin", nil];
    self.height = 80;

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
    
    if (tableView.tag == TAG) {
        return 40.0;
    }
    return self.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView.tag == TAG) {
        return 1;
    }
    return self.array.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView.tag == TAG) {
        
        UITableViewCell  *cell;
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"pay3cell2"];
        if (!cell) {
            cell = [[XWJPayWayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay3cell2"];
        }
        cell.imageView.image = [UIImage imageNamed:self.zhifuIconArr[indexPath.row]];
        cell.textLabel.text = self.payarray[indexPath.row];
        return cell;
    }
    
    UITableViewCell  *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"pay3cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay3cell"];
    }
    if(indexPath.row){
        
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    CGFloat contentWidth = width - 100;
    cell.textLabel.text = @"2015.12";
    cell.textLabel.textColor = XWJGRAYCOLOR;
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(100, 0, contentWidth, self.height);

    UILabel *label1 = [[UILabel alloc] init];
    UILabel *label2 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, 5, (contentWidth)/2, 30);
    label2.frame = CGRectMake((contentWidth)/2, 5, (contentWidth)/2, 30);
    label1.text = @"物业费";
    label2.text = @"2000.10";
    label1.textColor = XWJGRAYCOLOR;
    label2.textColor = XWJGRAYCOLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0 , self.height/2, view.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:201.0/255.0 alpha:1.0];
    
    
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:line];
    
    UILabel *label3 = [[UILabel alloc] init];
    UILabel *label4 = [[UILabel alloc] init];
    label3.frame = CGRectMake(0,10+self.height/2, (contentWidth)/2, 30);
    label4.frame = CGRectMake((contentWidth)/2,10+self.height/2, (contentWidth)/2, 30);
    label3.text = @"电梯费";
    label4.text = @"1000.10";
    
    label3.textColor = XWJGRAYCOLOR;
    label4.textColor = XWJGRAYCOLOR;
    [view addSubview:label3];
    [view addSubview:label4];
    [cell.contentView addSubview:view];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)surePay:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES ];
}

@end
