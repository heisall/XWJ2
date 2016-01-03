//
//  XWJBindHouseOneViewController.m
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBindHouseOneViewController.h"
#import "XWJdef.h"
#import "XWJCity.h"
@interface XWJBindHouseOneViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSArray *array;
@property NSArray *typearray;

@end

@implementation XWJBindHouseOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
      [self.tableView registerNib:[UINib nibWithNibName:@"XWJquxiaocell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
//    [dic valueForKey:@"R_dy"],[dic valueForKey:@"R_id"]]
    XWJCity *cityinstance = [XWJCity instance];
    NSString *city  = [cityinstance.city valueForKey:CityName];
    NSString *dis = [cityinstance.district valueForKey:a_name];
    NSString *build = [cityinstance.buiding valueForKey:b_name];
    NSString *roomNum = [cityinstance.room valueForKey:@"R_id"];
    NSString *dy = [cityinstance.room valueForKey:@"R_dy"];
    
//    NSString *rdy = [cityinstance.rdy ];
    self.array = [NSArray arrayWithObjects:city,dis,[NSString stringWithFormat:@"%@%@单元%@",build,dy,roomNum], nil];
    self.typearray = [NSArray arrayWithObjects:@"城市",@"小区",@"房号", nil];
    self.navigationItem.title = @"绑定房源";
    
}
- (IBAction)next:(UIButton *)sender {
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30.0;
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"物业员工";
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.bounds.size.height/4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
       return self.array.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {

        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        // Configure the cell...
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.typearray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = XWJGRAYCOLOR;
        cell.detailTextLabel.textColor = XWJGREENCOLOR;
        cell.detailTextLabel.text = [self.array objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
            
            
//            cell.imageView.highlightedImage = [UIImage imageNamed:@"agree"];
//            cell.imageView.image = [UIImage imageNamed:@"agree"];
            cell.textLabel.text =  @"我同意";
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame = CGRectMake(150, 0, 200, 40);
//            [btn setTitle:@"许可及服务协议" forState:UIControlStateNormal];
//            [btn setTitleColor:XWJColor(249, 62, 0) forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"agreeline"] forState:UIControlStateNormal];
////            btn.backgroundColor = [UIColor redColor];
//            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//            btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(35, 0, 0, 0)];
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(15, -100, 0, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [cell addSubview:btn];

        }
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if(indexPath.section == 0){
        
        NSArray *controllers = self.navigationController.viewControllers;
        UIViewController *controller = [controllers objectAtIndex:indexPath.row+1];
        [self.navigationController popToViewController:controller animated:YES];
        
    }else{
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];

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
