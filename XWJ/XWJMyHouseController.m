//
//  XWJMyHouseController.m
//  XWJ
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMyHouseController.h"
#import "XWJdef.h"
@interface XWJMyHouseController()<UITableViewDataSource,UITableViewDelegate>{
}

@property UITableView *tableView;
@property NSArray *titles;
@property NSArray *subTitles;
@end
@implementation XWJMyHouseController

static NSString *kcellIdentifier = @"cell";

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"我的房产";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _titles =[NSArray arrayWithObjects:@"湖岛世家",@"湖岛世家", nil];
    _subTitles =[NSArray arrayWithObjects:@"1号楼1单元101",@"2号楼1单元201", nil];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 50)];
    view.backgroundColor = XWJColor(235, 235, 234);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"bindfy"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:@"继续绑定房源" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 200, image.size.height);
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btn addTarget:self action:@selector(bind) forControlEvents:UIControlEventTouchUpInside];
    btn.center = view.center;
    [view addSubview:btn];
    _tableView.tableHeaderView = view;
    
    [_tableView registerNib:[UINib nibWithNibName:@"XWJMyhouseTableCell" bundle:nil] forCellReuseIdentifier:kcellIdentifier];
    [self.view addSubview:_tableView];
}

-(void)bind{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [_tableView dequeueReusableCellWithIdentifier:kcellIdentifier forIndexPath:indexPath];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    UILabel *subtitle = (UILabel *)[cell viewWithTag:2];
    
    title.text = [_titles objectAtIndex:indexPath.row];
    subtitle.text = [_subTitles objectAtIndex:indexPath.row];

    return cell;
}



@end
