//
//  XWJPay2ViewController.m
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJPay2ViewController.h"
#import "XWJdef.h"

@interface XWJPay2ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property CGFloat height;
@property NSInteger type;
@property NSArray *array;
@end

@implementation XWJPay2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"用户结算";
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.height = 120;
    self.type = 3;
    self.array = [NSArray arrayWithObjects:@"青岛市",@"海信花园",@"1号楼1单元101户", nil];
    
    //    view.backgroundColor = XWJGRAYCOLOR;
    
    
    NSArray *arr = [NSArray arrayWithObjects:@"缴费时间", @"费用名称",@"缴费期间",@"实缴金额", nil];
    
    CGFloat width = SCREEN_SIZE.width/5;
    for (int i =0 ; i<4; i++) {
        UILabel *label1 = [[UILabel alloc] init];
        if (i==3) {
            label1.frame = CGRectMake(10+width*(i+1),15, width, 30);
            
        }else
            label1.frame = CGRectMake(20+width*i,15, width, 30);
        label1.text = [arr objectAtIndex:i];
        label1.textColor = XWJGRAYCOLOR;
        label1.font = [UIFont systemFontOfSize:15.0];
        [self.tableHeadView addSubview:label1];
        
    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
    
}
//某一行的物业物业水电费和电梯的费用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell  *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"pay3cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay3cell"];
    }
    CGFloat width = SCREEN_SIZE.width;
    
    CGFloat typeHeight = self.height/self.type;
    CGFloat contentWidth = width - 100;
    cell.textLabel.text = @"2015.12";
    cell.textLabel.textColor = XWJGRAYCOLOR;
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(100, 0, contentWidth, self.height);
    
    UILabel *label1 = [[UILabel alloc] init];
    UILabel *label2 = [[UILabel alloc] init];
    UILabel *label3 = [[UILabel alloc] init];
    
    label1.frame = CGRectMake(0, 5, (contentWidth)/4, 30);
    label2.frame = CGRectMake((contentWidth)/4, 5, (contentWidth)/2, 30);
    label3.frame = CGRectMake(3*(contentWidth)/4, 5, (contentWidth)/4, 30);
    
    label1.text = @"物业费";
    label2.text = @"2015.01-2015.02";
    label3.text  = @"2000.21";
    label1.textColor = XWJGRAYCOLOR;
    label2.textColor = XWJGRAYCOLOR;
    label3.textColor = XWJGRAYCOLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0 , typeHeight, view.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:201.0/255.0 alpha:1.0];
    
    
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    
    [view addSubview:line];
    
    UILabel *label4 = [[UILabel alloc] init];
    UILabel *label5 = [[UILabel alloc] init];
    UILabel *label6 = [[UILabel alloc] init];
    
    label4.frame = CGRectMake(0,10+typeHeight, (contentWidth)/4, 30);
    label5.frame = CGRectMake((contentWidth)/4,10+typeHeight, (contentWidth)/2, 30);
    label6.frame = CGRectMake(3*(contentWidth)/4,10+typeHeight, (contentWidth)/4, 30);
    
    label4.text = @"电梯费";
    label5.text = @"2015.01-2015.02";
    label6.text = @"1000.10";
    
    label4.textColor = XWJGRAYCOLOR;
    label5.textColor = XWJGRAYCOLOR;
    label6.textColor = XWJGRAYCOLOR;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0 , typeHeight*2, view.bounds.size.width, 0.5)];
    line2.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:201.0/255.0 alpha:1.0];
    [view addSubview:label4];
    [view addSubview:label5];
    [view addSubview:label6];
    [view addSubview:line2];
    
    
    UILabel *label7 = [[UILabel alloc] init];
    UILabel *label8 = [[UILabel alloc] init];
    UILabel *label9 = [[UILabel alloc] init];
    
    label7.frame = CGRectMake(0,10+typeHeight*2, (contentWidth)/4, 30);
    label8.frame = CGRectMake((contentWidth)/4,10+typeHeight*2, (contentWidth)/2, 30);
    label9.frame = CGRectMake(3*(contentWidth)/4,10+typeHeight*2, (contentWidth)/4, 30);
    
    label7.text = @"水费";
    label8.text = @"2015.01-2015.02";
    label9.text = @"1000.10";
    
    label7.textColor = XWJGRAYCOLOR;
    label8.textColor = XWJGRAYCOLOR;
    label9.textColor = XWJGRAYCOLOR;
    
    [view addSubview:label7];
    [view addSubview:label8];
    [view addSubview:label9];
    
    view.tag = 100;
    [cell.contentView addSubview:view];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
- (IBAction)jiaofei:(UIButton *)sender {
}

@end
