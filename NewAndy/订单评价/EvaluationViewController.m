

//
//  EvaluationViewController.m
//  XWJ
//
//  Created by lingnet on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "EvaluationViewController.h"

#import "Masonry.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

#import "UIImageView+WebCache.h"

#import "UITextView+placeholder.h"

#import "TQStarRatingView.h"

#import "AFNetworking.h"

#import "XWJUrl.h"
#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
@interface EvaluationViewController ()<UITableViewDataSource,UITableViewDelegate,StarRatingViewDelegate>{
    UITableView* _tableView;
}
@property (nonatomic, strong) UIImageView* headImagView;
@property (nonatomic, strong) UILabel* titleLable;
@property (nonatomic, strong) UILabel* priceAndTimeLable;
@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title  = @"评价";
    self.star = @"5";
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (float)isIOS7{
    
    float height;
    if (IOS7) {
        height=64.0;
    }else{
        height=44.0;
    }
    
    return height;
}
#pragma - mark 滑动评分代理
-(void)starRatingView:(TQStarRatingView *)view score:(float)score{
    NSLog(@"开始滑动");
    self.star = [NSString stringWithFormat:@"%d",(int)score];
}
#pragma mark - 初始化tableView
- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self isIOS7], self.view.frame.size.width, self.view.frame.size.height-[self isIOS7]) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIImageView *tableBg = [[UIImageView alloc] initWithImage:nil];
    tableBg.backgroundColor = [self colorWithHexString:@"f6f6f6"];
    [_tableView setBackgroundView:tableBg];
    //分割线类型
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    //_tableView.backgroundColor = [UIColor colorWithRed:190 green:30 blue:96 alpha:1];
    [self.view addSubview:_tableView];
}
#pragma mark - tableView行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
#pragma mark - tableVie点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark - 自定义tableView
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self makeCellView:cell];
    return cell;
}
- (void)makeCellView:(UITableViewCell*)cell{
    self.headImagView = [[UIImageView alloc] init];
    self.headImagView.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:self.headImagView];
    [self.headImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell).offset(5);
        make.top.mas_equalTo(cell).offset(5);
        make.height.mas_offset(70);
        make.width.mas_offset(70);
    }];
    
    self.titleLable = [[UILabel alloc] init];
    [cell addSubview:self.titleLable];
    self.titleLable.numberOfLines = 1;
    self.titleLable.font = [UIFont systemFontOfSize:14];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell).offset(7);
        make.left.mas_equalTo(self.headImagView.mas_right).offset(3);
        make.right.mas_equalTo(cell).offset(-10);
        make.height.mas_offset(14);
    }];
    
    self.priceAndTimeLable = [[UILabel alloc] init];
    [cell addSubview:self.priceAndTimeLable];
    self.priceAndTimeLable.numberOfLines = 1;
    self.priceAndTimeLable.font = [UIFont systemFontOfSize:12];
    self.priceAndTimeLable.alpha = 0.4;
    
    [self.priceAndTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell).offset(26);
        make.left.mas_equalTo(self.headImagView.mas_right).offset(3);
        make.right.mas_equalTo(cell).offset(-10);
        make.height.mas_offset(12);
    }];
    
    [self.headImagView sd_setImageWithURL:[NSURL URLWithString:self.headImageStr] placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLable.text = self.titleStr;
    
    self.priceAndTimeLable.text = self.priceAndTimeStr;
    
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(40, 90, [UIScreen mainScreen].bounds.size.width - 80, 30) numberOfStar:5];
    starRatingView.delegate = self;
    [cell addSubview:starRatingView];
    //    [starRatingView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(self.headImagView.mas_bottom).offset(26);
    ////        make.left.mas_equalTo(self.headImagView.mas_right).offset(([UIScreen mainScreen].bounds.size.width - 80)/2);
    ////        make.height.mas_offset(15);
    //    }];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 40, [UIScreen mainScreen].bounds.size.width - 24, 390/2)];
    textView.font = [UIFont systemFontOfSize:14]; //注意先设置字体,再设置placeholder
    textView.placeholder = @"喜欢此商品吗？说点您的感受吧";
    textView.tag = 100;
    textView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:textView];
    
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(starRatingView.mas_bottom).offset(26);
        make.left.mas_equalTo(12);
        make.height.mas_offset(390/2);
        make.right.mas_equalTo(-12);
    }];
    
    UIButton* sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, _tableView.frame.size.height - 50, [UIScreen mainScreen].bounds.size.width - 24, 40)];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTintColor:[UIColor whiteColor]];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    sendBtn.backgroundColor = [self colorWithHexString:@"00adac"];//[UIColor greenColor];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [cell addSubview:sendBtn];
}
- (void)sendBtnClick{
    NSLog(@"提交");
    [self createRequest];
}
#pragma mark - tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _tableView.frame.size.height;
}
#pragma mark - tableView组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - 创建头标题
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
#pragma mark - 头标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - 数据请求
- (void)createRequest{
    UITextView* tv = (UITextView*)[_tableView viewWithTag:100];
    self.comment = tv.text;
    NSLog(@"----评论请求参数---%@\n-----%@\n-----%@\n-----%@\n-----%@\n----%@\n",self.orderId,self.storeId,self.goodsId,self.star,self.comment,PINGJIAORDER);
    NSString* requestAddress = PINGJIAORDER;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:requestAddress parameters:@{
                                             @"orderId":self.orderId,
                                             @"storeId":self.storeId,
                                             @"goodsId":self.goodsId,
                                             @"star":self.star,
                                             @"comment":self.comment
                                             }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([[responseObject objectForKey:@"result"] intValue]) {
                 NSLog(@"评论请求成功---%@",responseObject);
                 
                 [self.evaluationDelegate sendBackCellNum:self.commentNumSuccess];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"失败===%@", error);
         }];
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
