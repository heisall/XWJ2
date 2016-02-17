//
//  XWJXuanZeViewController.m
//  XWJ
//
//  Created by Sun on 15/12/10.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJXuanZeViewController.h"
#import "XWJTabViewController.h"
#import "XWJLoginViewController.h"
#import "XWJBindHouseTableViewController.h"
#import "XWJAccount.h"
#import "XWJCity.h"
@interface XWJXuanZeViewController ()<XWJBindHouseDelegate>
@property BOOL isBind;
@property BOOL isYouke;
@end

@implementation XWJXuanZeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择方式";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *views = self.navigationController.viewControllers;
    BOOL fromLogin = NO;
    for (UIViewController *con  in views) {
        if ([con isKindOfClass:[XWJLoginViewController class]]) {
            fromLogin = YES;
            break;
        }
    }
    if (!fromLogin) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:239/255.0 alpha:1.0];

}
#pragma bindhouse delegate //登录信息的选择
-(void)didSelectAtIndex:(NSInteger)index Type:(HouseMode)type{
    switch (type) {
        case HouseCity:{
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"小区选择";
            bind.delegate = self;
            bind->mode = HouseCommunity;
            
            [self.navigationController showViewController:bind sender:nil];
        }
            break;
        case HouseCommunity:{
            if (self.isYouke) {
                [XWJAccount instance].isYouke =YES;
                [XWJAccount instance].aid = [XWJCity instance].aid;
                XWJTabViewController *tab = [[XWJTabViewController alloc] init];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = tab;
            }else{
                XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
                bind.title = @"楼座选择";
                bind.delegate = self;
                bind->mode = HouseFlour;
                [self.navigationController showViewController:bind sender:nil];
            }
        }
            break;
        case HouseFlour:{
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"房间选择";
            bind.delegate = self;
            bind->mode = HouseRoomNumber;
            [self.navigationController showViewController:bind sender:nil];
        }
            break;
        case HouseRoomNumber:{
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
                [self.navigationController showViewController:[story instantiateViewControllerWithIdentifier:@"bindhouse1"] sender:nil];
//            }
        }
            break;
        default:
            break;
    }
}
//绑定城市的选择
- (IBAction)bind:(UIButton *)sender {
    XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
    bind.title = @"城市选择";
    bind.delegate = self;
    bind->mode = HouseCity;
    self.isYouke = NO;
    [self.navigationController showViewController:bind sender:nil];
        
}
- (IBAction)xuanze:(UIButton *)sender {

    XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
    bind.title = @"城市选择";
    bind.delegate = self;
    bind->mode = HouseCity;
    self.isYouke = YES;
    [self.navigationController showViewController:bind sender:nil];
    
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
