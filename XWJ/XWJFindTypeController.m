//
//  XWJFindTypeController.m
//  XWJ
//
//  Created by Sun on 15/12/18.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJFindTypeController.h"
#import "XWJFindViewController.h"
@implementation XWJFindTypeController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择类别";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        // Configure the cell...
        cell.textLabel.text = [self.array[indexPath.row] objectForKey:@"memo"];
        cell.textLabel.textColor =[UIColor colorWithRed:68.0/255.0 green:70.0/255.0 blue:71.0/255.0 alpha:1.0];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.navigationController.viewControllers;
    XWJFindViewController *view  = [array objectAtIndex:array.count - 2] ;
    view.select = indexPath.row;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
