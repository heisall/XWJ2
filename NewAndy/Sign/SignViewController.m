//
//  SignViewController.m
//  XWJ
//
//  Created by 徐仁强 on 16/1/19.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SignViewController.h"

#import "SDCycleScrollView.h"

#import "ShouYe0Model.h"

#import "ShouYe0TableViewCell.h"

#import "UIImageView+WebCache.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

#import "AFNetworking.h"

#import "XWJUrl.h"

#import "WaiLianViewController.h"

#import "XWJAccount.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface SignViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ShouYe0TableViewCellDelegate>{
    UITableView* _tableView;
}
//section0的广告数据源
@property(nonatomic,retain)NSMutableArray* picturesArr;
@property(nonatomic,retain)NSMutableArray* urlArr;
@property(nonatomic,copy)NSString* btnTitleStr;

@end
@interface SignViewController ()

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title  = @"签到";
    self.btnTitleStr = @"立即签到";
    if ([self isBlankString:self.headImageStr]) {
        self.headImageStr = @"";
    }
    self.urlArr = [[NSMutableArray alloc] init];
    self.picturesArr = [[NSMutableArray alloc] init];
    
    [self createTableView];
    [self createRequest];
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - ShouYe0TableViewCellDelegate广告代理
- (void)didselectADPic:(NSInteger)index{
    NSLog(@"---点击了第%ld张---",(long)index);
    WaiLianViewController* vc = [[WaiLianViewController alloc] init];
    vc.urlString = self.urlArr[index];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 初始化tableView
- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, self.view.frame.size.width, self.view.frame.size.height-69) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIImageView *tableBg = [[UIImageView alloc] initWithImage:nil];
    tableBg.backgroundColor = [UIColor whiteColor];
    [_tableView setBackgroundView:tableBg];
    //分割线类型
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    //_tableView.backgroundColor = [UIColor colorWithRed:190 green:30 blue:96 alpha:1];
    [self.view addSubview:_tableView];
}
#pragma mark - tableView行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.picturesArr.count;
    }
    return 1;
}
#pragma mark - tableView组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma mark - tableVie点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark - 自定义tableView
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"CellIdentifier";
        ShouYe0TableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell0) {
            cell0 = [[ShouYe0TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell0.ShouYe0Delegate = self;
        ShouYe0Model *model = nil;
        model = [self.picturesArr objectAtIndex:indexPath.row];
        cell0.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell0 configCellWithModel:model];
        
        return cell0;
    }
    
    [self makeCell1View:cell];
    
    return cell;
}
- (void)makeCell1View:(UITableViewCell*)cell{
    UIImageView* headIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2 - 35, 15, 70, 70)];
//    headIV.backgroundColor = [UIColor redColor];
    headIV.layer.cornerRadius = 35;
    headIV.layer.masksToBounds = YES;
    [headIV sd_setImageWithURL:[NSURL URLWithString:self.headImageStr] placeholderImage:[UIImage imageNamed:@"devAdv_default"]];
//     [headIV sd_setImageWithURL:[NSURL URLWithString:[XWJAccount instance].headPhoto] placeholderImage:[UIImage imageNamed:@"devAdv_default"]];
    [cell addSubview:headIV];
    
    UILabel* nameLable  = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(headIV.frame) + 10, WIDTH - 20, 12)];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = [UIFont systemFontOfSize:12];
    nameLable.text = self.nickName;
    [cell addSubview:nameLable];
    
    UIButton* signBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2 - 130, CGRectGetMaxY(nameLable.frame) + 50, 260, 50)];
    [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [signBtn setTitle:self.btnTitleStr forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signBtn setBackgroundColor:[self colorWithHexString:@"00aaa6"]];
    signBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cell addSubview:signBtn];
}
#pragma mark - 签到
- (void)signBtnClick{
    NSLog(@"签到");
    [self createSignRequest];
}
#pragma mark - tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ShouYe0Model *model = nil;
        if (indexPath.row < self.picturesArr.count) {
            model = [self.picturesArr objectAtIndex:indexPath.row];
        }
        return [ShouYe0TableViewCell hyb_heightForIndexPath:indexPath config:^(UITableViewCell *sourceCell) {
            ShouYe0TableViewCell *cell = (ShouYe0TableViewCell *)sourceCell;
            // 配置数据
            [cell configCellWithModel:model];
        }];
    }
    return 200;
}
#pragma mark - 广告数据请求
- (void)createRequest{
    NSLog(@"请求的参数----%@\n----%@\n",self.a_idStr,SIGNADD);
    NSString* requestAddress = SIGNADD;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:requestAddress parameters:@{
                                              @"a_id":[NSString stringWithFormat:@"%@",self.a_idStr],
                                              }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"response %@",responseObject);
              if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                  NSLog(@"没有返回信息");
              }else{
                  NSLog(@"---%@",responseObject);
                  NSMutableArray* temArr = responseObject[@"ad"];
                  ShouYe0Model* model = [[ShouYe0Model alloc] init];
                  model.picArr = [[NSMutableArray alloc] init];
                  for (NSDictionary* dic in temArr) {
                      [model.picArr addObject:dic[@"Photo"]];
                      [self.urlArr addObject:dic[@"url"]];
                  }
                  [self.picturesArr addObject:model];
                  
                  [_tableView reloadData];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"失败===%@", error);
          }];
}
#pragma mark - 签到数据请求
- (void)createSignRequest{
    NSLog(@"请求的参数----%@\n----%@\n",self.account,SIGNSUCC);
    NSString* requestAddress = SIGNSUCC;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:requestAddress parameters:@{
                                              @"account":self.account,
                                              }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"------%@",responseObject);
              
              if ([[responseObject objectForKey:@"result"] intValue]) {
                  NSLog(@"签到成功");
                  self.btnTitleStr = @"已签到";
                  [_tableView reloadData];
              }else{
                  NSLog(@"------%@",responseObject[@"errorCode"]);
                  [self HelpfulHints:responseObject[@"errorCode"] addView:self.view];
                  self.btnTitleStr = @"已签到";
                  [_tableView reloadData];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"失败===%@", error);
          }];
}
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
- (UIColor *) colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
- (void)HelpfulHints:(NSString*)text addView:(UIView*)addView{
    UILabel  * Alertlabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-80, WIDTH/2-40, 160, 80)];
    //    Alertlabel.backgroundColor = [UIColor orangeColor];
    Alertlabel.backgroundColor = [UIColor blackColor];
    Alertlabel.textColor = [UIColor whiteColor];
    Alertlabel.font = [UIFont boldSystemFontOfSize:14];
    Alertlabel.text = text;
    [addView addSubview:Alertlabel];
    Alertlabel.textAlignment = NSTextAlignmentCenter;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationDelegate:self];
    Alertlabel.alpha =0.0;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
