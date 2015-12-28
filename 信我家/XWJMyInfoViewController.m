//
//  XWJMyInfoViewController.m
//  XWJ
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMyInfoViewController.h"
#import "XWJHeader.h"

#define  HEIGHT 85.0
#define  NORMALHGIGHT 44.0
@interface XWJMyInfoViewController ()
@end

@implementation XWJMyInfoViewController
CGRect tableViewCGRect;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.myView.bounds.size.height) style:UITableViewStylePlain];

    self.tableData = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"情感状况",@"兴趣爱好",@"个性签名" ,nil];
    self.tableDetailData = [NSArray arrayWithObjects:@"Angela",@"女",@"已婚",@"烹饪",@"开花",nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = FALSE;
    self.tableView.bounces = FALSE;
    self.navigationItem.title = @"个人信息";
    [self.myView addSubview:self.tableView];
//    tableViewCGRect = self.tableView.frame ;
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}

- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableViewCellHeight = HEIGHT;
    }else{
        tableViewCellHeight = NORMALHGIGHT;
    }
//    NSLog(@"seciton %ld row %ld",(long)indexPath.section,(long)indexPath.row);
    return tableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger index = 0;
    
    switch (indexPath.section) {
        case 0:
            tableViewCellHeight = HEIGHT;
            break;
        case 1:
        {
            tableViewCellHeight = NORMALHGIGHT;
            index = indexPath.row+1;
        }
            break;
        case 2:
        {
            tableViewCellHeight = NORMALHGIGHT;
            index = 5;
        }
            break;
        default:
            break;
    }

    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.tableData[index];
    cell.textLabel.textColor = XWJGRAYCOLOR;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,1)];
    headerview.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mor_icon_default"];
        cell.imageView.frame = CGRectMake(300, 0, 50, 50);
    }else{
        cell.detailTextLabel.text = self.tableDetailData[(indexPath.section-1)*4 + indexPath.row];
    }
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewCellHeight, self.view.bounds.size.width,1)];
    footerview.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    [cell addSubview:headerview];
    [cell addSubview:footerview];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
