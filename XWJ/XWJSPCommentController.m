//
//  XWJSPCommentController.m
//  XWJ
//
//  Created by Sun on 16/1/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJSPCommentController.h"
#import "XWJSPDetailTableViewCell.h"
@interface XWJSPCommentController()<UITableViewDataSource,UITableViewDelegate>
@property UITableView *tableView;
@end
@implementation XWJSPCommentController
@synthesize tableView;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"商品评论";
    tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.comments.count>5)
        return 5;
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)taView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index path %ld",(long)indexPath.row);
    XWJSPDetailTableViewCell *cell;
    
    cell = [taView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJSPDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    /*
     anonymous = 0;
     "buyer_name" = 18561927376;
     comment = "     \U554a\U554a\U554a\n";
     evaluation = 5;
     "evaluation_time" = "2016-01-14";
     "goods_id" = 71;
     "rec_id" = 67;
     */
    //    cell.label1.text = [self.tabledata ];
    NSArray *arr = self.comments;
    
    if(arr&&arr.count>0){
        cell.label1.text =     [[arr objectAtIndex:indexPath.row] objectForKey:@"buyer_name"];
        cell.label2.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"comment"];
        cell.timeLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"evaluation_time"];
        
        NSString *url;
        if ([[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"]!=[NSNull null]) {
            url = [[arr objectAtIndex:indexPath.row] objectForKey:@"default_image"];
        }
        
        //        if (url) {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headDefaultImg"]];
        //        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
