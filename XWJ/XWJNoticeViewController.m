//
//  XWJNoticeViewController.m
//  XWJ
//
//  Created by Sun on 15/12/5.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJNoticeViewController.h"
#import "XWJNotcieTableViewCell.h"
#import "XWJCity.h"
#import "XWJActivityViewController.h"
#import "XWJAccount.h"
#define cell_height 120.0
@interface XWJNoticeViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XWJNoticeViewController{

     NSInteger _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage  = 0;
    if ([self.type isEqualToString:@"0"]) {
        self.navigationItem.title = @"物业通知";
    }else{
        self.navigationItem.title = @"社区活动";
    }
    self.navigationItem.title = @"详情";
    /*
     ClickCount = 34;
     addTime = "2015-12-10";
     content = "http://mp.weixin.qq.com/s?__biz=MzA3MDYyNzMyNg==&mid=402185314&idx=1&sn=62649235951c5f66fe1bafef7f2066ff&scene=0#wechat_redirect";
     description = "\U6d77\U4fe1\U201c\U4fe1\U6211\U5bb6\U201d\U667a\U6167\U793e\U533aAPP\U662f\U6211\U516c\U53f8\U81ea\U5df1\U7814\U53d1\U7684\U4e00\U4e2aAPP\U7ba1\U7406\U8f6f\U4ef6\U3002";
     id = 5;
     isUrl = 1;
     title = "\U6d77\U4fe1\U201c\U4fe1\U6211\U5bb6\U201d\U667a\U6167\U793e\U533aAPP\U5f00\U59cb\U6d4b\U8bd5\U4e86\U3002";
     types = 0;
     */
        [self loadNewData];
    
//    下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self loadNewData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //进入加载状态后会自动调用这个block
        [self loadNextPageDate];
    }];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

//下载下一页数据
-(void)loadNextPageDate{
    _currentPage ++;
    XWJCity *city =  [XWJCity instance];
    NSString *pageStr  = [NSString stringWithFormat:@"%ld",_currentPage];
    [city getActive:self.type WithPage:(NSString*)pageStr :^(NSArray *arr) {
        CLog(@"room  %@",arr);
        
        if (arr) {
            NSMutableArray *arr2 = [NSMutableArray array];
            
            for (NSDictionary *dic in arr) {
                
                NSMutableDictionary  *dic2 = [NSMutableDictionary dictionary];
                [dic2 setValue:[dic valueForKey:@"title"] forKey:KEY_AD_TITLE];
                [dic2 setValue:[dic valueForKey:@"addTime"] forKey:KEY_AD_TIME];
                [dic2 setValue:[dic valueForKey:@"description"]==[NSNull null]?@"":[dic valueForKey:@"description"] forKey:KEY_AD_CONTENT];
                
                NSString *count = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ClickCount"]==[NSNull null]?@"0":[dic valueForKey:@"ClickCount"]];
                [dic2 setValue: count forKey:KEY_AD_CLICKCOUNT];
                [dic2 setValue:[dic valueForKey:@"content"] forKey:KEY_AD_URL];
                [dic2 setValue:[dic valueForKey:@"id"] forKey:KEY_AD_ID];
                [arr2 addObject:dic2];
            }
//            self.array = arr2;
            [self.array addObjectsFromArray:arr2];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
//            self.tableView.contentSize = CGSizeMake(0, cell_height*self.array.count+120);
            
        }else{
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"暂没有相关内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertview show];
        }
        
    }];
}

//下载最新的数据
-(void)loadNewData{
    _currentPage = 0;
    XWJCity *city =  [XWJCity instance];
    [city getActive:self.type :^(NSArray *arr) {
        CLog(@"room  %@",arr);
        
        if (arr) {
            NSMutableArray *arr2 = [NSMutableArray array];
            
            for (NSDictionary *dic in arr) {
                
                NSMutableDictionary  *dic2 = [NSMutableDictionary dictionary];
                [dic2 setValue:[dic valueForKey:@"title"] forKey:KEY_AD_TITLE];
                [dic2 setValue:[dic valueForKey:@"addTime"] forKey:KEY_AD_TIME];
                [dic2 setValue:[dic valueForKey:@"description"]==[NSNull null]?@"":[dic valueForKey:@"description"] forKey:KEY_AD_CONTENT];
                
                NSString *count = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ClickCount"]==[NSNull null]?@"0":[dic valueForKey:@"ClickCount"]];
                [dic2 setValue: count forKey:KEY_AD_CLICKCOUNT];
                [dic2 setValue:[dic valueForKey:@"content"] forKey:KEY_AD_URL];
                [dic2 setValue:[dic valueForKey:@"id"] forKey:KEY_AD_ID];
                [arr2 addObject:dic2];
            }
           // self.array = arr2;
            self.array = [[NSMutableArray alloc]init];
            [self.array removeAllObjects];
            [self.array addObjectsFromArray:arr2];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.tableView.contentSize = CGSizeMake(0, cell_height*self.array.count+120);
            
        }else{
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"暂没有相关内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertview show];
        }
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
//将详细的信息在tabelview上展示出来
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJNotcieTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"noticecell"];
    if (!cell) {
        cell = [[XWJNotcieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noticecell"];
    }
    // Configure the cell...
    NSDictionary *dic = (NSDictionary *)self.array[indexPath.row];
    cell.titleLabel.text = [dic valueForKey:KEY_AD_TITLE];
    cell.titleLabel.font = [UIFont systemFontOfSize:18];
    cell.titleLabel.textColor = [UIColor colorWithRed:0 green:0.33 blue:0.33 alpha:1.00];
    cell.timeLabel.text = [dic valueForKey:KEY_AD_TIME];
    cell.timeLabel.font = [UIFont systemFontOfSize:13];
    cell.contentLabel.text = [dic valueForKey:KEY_AD_CONTENT];
    cell.contentLabel.font = [UIFont systemFontOfSize:16];
    cell.contentLabel.numberOfLines = 1;
    [cell.clickBtn setTitle:[dic valueForKey:KEY_AD_CLICKCOUNT]==[NSNull null]?@"":[dic valueForKey:KEY_AD_CLICKCOUNT] forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self getDetailAD:indexPath.row];

}

//下载我的消息的列表信息
-(void)getDetailAD:(NSInteger)index{
    NSString *url = GETDETAILAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[[self.array objectAtIndex:index] valueForKey:@"id"]  forKey:@"id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            CLog(@"dic %@",dict);
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
            
            XWJActivityViewController * acti = [storyboard instantiateViewControllerWithIdentifier:@"activityDetail"];
            acti.dic = [dict objectForKey:@"data"];
            acti.type = self.type;
            [self.navigationController showViewController:acti sender:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

@end
