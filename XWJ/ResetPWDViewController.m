//
//  ResetPWDViewController.m
//  信我家
//
//  Created by Sun on 15/11/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "ResetPWDViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface ResetPWDViewController (){
    int timeTick;

}
@property (weak, nonatomic) IBOutlet UITextField *txtFieldIDCode;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPhoneNumber;

@end

@implementation ResetPWDViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /**
     *  注册所有的
     */
    UIControl *controlView = [[UIControl alloc] initWithFrame:self.view.frame];
    [controlView addTarget:self action:@selector(resiginTF) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:controlView atIndex:0];
    controlView.backgroundColor = [UIColor clearColor];
    timeTick = 61;

    [self setStatusBar];
    [self setNavigationBar];
    self.txtFieldIDCode.delegate = self;
    self.txtFieldPhoneNumber.delegate = self;

}

-(void)resiginTF
{
    CLog(@"resign");
    [self.txtFieldIDCode resignFirstResponder];
    [self.txtFieldPhoneNumber resignFirstResponder];
}

-(void)setStatusBar{
    //set status bar hidden
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        //iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

-(void)setNavigationBar{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"找回密码";
    UIColor * color = [UIColor whiteColor];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //set button item color style
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.style = UIBarButtonSystemItemCancel;
    //set navigation bar background color
    self.navigationController.navigationBar.barTintColor  = [UIColor colorWithRed:20.0/255.0 green:157.0/255.0 blue:150.0/255.0 alpha:1.0];
}
//短信验证码的发送
- (IBAction)getIDCode:(id)sender {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
     //这个参数可以选择是通过发送验证码还是语言来获取验证码
                            phoneNumber:self.txtFieldPhoneNumber.text
                                   zone:@"86"
                       customIdentifier:nil //自定义短信模板标识
                                 result:^(NSError *error)
    {
        
        if (!error)
        {
            CLog(@"block 获取验证码成功");
            
        }
        else
        {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
}
- (IBAction)verifyIDcode:(id)sender {
    [SMSSDK  commitVerificationCode:self.txtFieldIDCode.text
     //传获取到的区号
                        phoneNumber:self.txtFieldPhoneNumber.text
                               zone:@"86"
                             result:^(NSError *error)
     {
         NSString *message ;
         if (!error)
         {
            message = @"验证成功";
             CLog(@"验证成功");
             
         }
         else
         {
             message = @"验证失败";
             CLog(@"验证失败");
         }
         UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alertview show];
     }];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;//隐藏为YES，显示为NO
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)backNavItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
