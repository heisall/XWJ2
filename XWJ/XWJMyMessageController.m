//
//  XWJMyMessageController.m
//  XWJ
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMyMessageController.h"

@interface XWJMyMessageController()<UITableViewDataSource,UITableViewDelegate>

@property UITableView *tableView;
@property NSArray *titles;
@property NSArray *subTitles;
@property NSArray *msgArr;
@end


@implementation XWJMyMessageController

static NSString *kcellIdentifier = @"mymsgcell";

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"我的消息";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _titles =[NSArray arrayWithObjects:@"湖岛世家",@"湖岛世家", nil];
    _subTitles =[NSArray arrayWithObjects:@"1号楼1单元101",@"2号楼1单元201", nil];
    _msgArr = [NSArray arrayWithObjects:@"mymsg1",@"mymsg2",@"mymsg3", nil];
//    [_tableView registerNib:[UINib nibWithNibName:@"XWJMyhouseTableCell" bundle:nil] forCellReuseIdentifier:kcellIdentifier];
    [self.view addSubview:_tableView];
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
    cell = [tableView dequeueReusableCellWithIdentifier:kcellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kcellIdentifier];
    }
    cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
    cell.textLabel.textColor = XWJColor(27, 28, 29);
    cell.detailTextLabel.text = [_subTitles objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor = XWJColor(200, 200, 200);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    cell.imageView.image = [UIImage imageNamed:[_msgArr objectAtIndex:indexPath.row]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.bounds.size.width-120, 20, 120, 30)];
    label.textColor = XWJColor(200, 200, 200);
    label.text = @"2015-12-11";
    [cell.contentView addSubview:label];
    return cell;
}
@end
