//
//  XWJLoginViewController.m
//  信我家
//
//  Created by Paul on 18/11/15.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJLoginViewController.h"
#import "XWJBindHouseTableViewController.h"
#import "XWJBingHouseViewController.h"
#import "XWJTabViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "XWJHeader.h"
#import "XWJAccount.h"
#import "XWJCity.h"
#import "ProgressHUD/ProgressHUD.h"
//注册推送
#import "XRQJpush.h"
@interface XWJLoginViewController ()<XWJBindHouseDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *tFieldPassWord;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnResetPwd;
@end

@implementation XWJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    if (username&&pwd) {
        
    }
    
    /**
     *  注册所有的
     */
    UIControl *controlView = [[UIControl alloc] initWithFrame:self.view.frame];
    [controlView addTarget:self action:@selector(resiginTextFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:controlView atIndex:0];
    controlView.backgroundColor = [UIColor clearColor];
    
    
    _tFieldUserName.delegate = self;
    _tFieldPassWord.delegate = self;
    
    [_tFieldUserName setValue:[UIColor colorWithRed:88.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [_tFieldPassWord setValue:[UIColor colorWithRed:88.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        //iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

-(void)resiginTextFields
{
    
    CLog(@"resigne  tf");
    [self.tFieldUserName resignFirstResponder];
    [self.tFieldPassWord resignFirstResponder];
    
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    

    if (username) {
        
//        self.tFieldUserName.text = username;
    }else{
        
//        self.tFieldUserName.text = @"15092245487";
    }
    if (pwd) {
        
//        self.tFieldPassWord.text = pwd;
    }else
//        self.tFieldPassWord.text = @"123456";
    self.navigationController.navigationBar.hidden = YES;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)login:(NSString *)username :(NSString *)pwd{
    if (username.length>0&&pwd.length>0) {
        NSString *url = LOGIN_URL;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:username forKey:@"account"];
        [dict setValue:pwd forKey:@"password"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            NSNumber * result = [dic valueForKey:@"result"];
            
            /*
             Account = 15092245487;
             AccountCount = 0;
             DictValue = "<null>";
             LastLoginIP = "<null>";
             LastLoginTime = "<null>";
             NAME = "<null>";
             NickName = "<null>";
             PhoneType = iPhone;
             Photo = "<null>";
             "R_id" = 24215;
             RegisterIP = "168.0.0.1";
             RegisterTime = "2015-12-07";
             TEL = "<null>";
             Types = 1;
             "U_id" = 1;
             gxqm = "<null>";
             id = 13;
             sex = "<null>";
             */
            if ([result intValue]== 1) {

                [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"password"];
                
                NSDictionary *userDic = [[dic objectForKey:@"data"] objectForKey:@"user"];
                NSString *sid = [userDic valueForKey:@"id"];
                CLog(@"sid %@",sid);
                [XWJAccount instance].uid = sid;
                [XWJAccount instance].account = [userDic valueForKey:@"Account"];
                [XWJAccount instance].password = pwd;
                [XWJAccount instance].NickName =[userDic valueForKey:@"NickName"];
                [XWJAccount instance].name = [userDic valueForKey:@"NAME"];
                [XWJAccount instance].Sex = [userDic valueForKey:@"sex"];
                [XWJAccount instance].phone = [userDic valueForKey:@"TEL"];
                [XWJAccount instance].jifen = [userDic valueForKey:@"jifen"];
                [XWJAccount instance].headPhoto = [NSString stringWithFormat:@"%@",[userDic valueForKey:@"Photo"]];
                [XWJAccount instance].array = [[dic objectForKey:@"data"] valueForKey:@"area"];
                if ([XWJAccount instance].array&&[XWJAccount instance].array.count>0) {
                    [XWJAccount instance].isYouke = NO;
                    for (NSDictionary *di in [XWJAccount instance].array ) {
                        if ([[di valueForKey:@"isDefault" ] integerValue]== 1) {
                            [XWJAccount instance].aid = [NSString stringWithFormat:@"%@",[di valueForKey:@"A_id"]];
                        }
                    }
                }
                
        //设置别名
                [XRQJpush setBieming:[XWJAccount instance].uid];
                CLog(@"******别名*****%@",[XWJAccount instance].uid);
                BOOL isBind = [XWJAccount instance].aid?TRUE:FALSE;
                if (!isBind) {
                    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"xuanzefangshi"];
                    
                    [self.navigationController showViewController:view sender:nil];
                }else{
                   
                    XWJTabViewController *tab = [[XWJTabViewController alloc] init];
                    self.view.window.rootViewController = tab;
                }
            }else{
                NSString *errCode = [dic objectForKey:@"errorCode"];
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CLog(@"log fail ");
            
            [ProgressHUD showError:@"服务端返回异常"];
        }];
    }else{
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入用户名和密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertview.delegate = self;
        [alertview show];

    }
}
- (IBAction)login:(id)sender {
    NSString *username = self.tFieldUserName.text;
    NSString *pwd = self.tFieldPassWord.text;
    [[XWJAccount instance] logout];
    [self login:username :pwd];
}

#pragma bindhouse delegate
-(void)didSelectAtIndex:(NSInteger)index Type:(HouseMode)type{
    XWJCity *city = [XWJCity instance];
    switch (type) {
        case HouseCity:{
            
            [city selectCity:index];
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"小区选择";

            bind.delegate = self;
            bind->mode = HouseCommunity;
            
            [self.navigationController showViewController:bind sender:nil];
        
        }
            break;
        case HouseCommunity:{
            
            [city selectDistrict:index];
            
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"楼座选择";

            bind.delegate = self;
            bind->mode = HouseFlour;
            [self.navigationController showViewController:bind sender:nil];
        }
            break;
        case HouseFlour:{
            
            [city selectBuilding:index];
            
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"房间选择";

            bind.delegate = self;
            bind->mode = HouseRoomNumber;
            [self.navigationController showViewController:bind sender:nil];
        }
            break;
        case HouseRoomNumber:{
            
            [city selectRoom:index];
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
            [self.navigationController showViewController:[story instantiateViewControllerWithIdentifier:@"bindhouse1"] sender:nil];
            
        }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
