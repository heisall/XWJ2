//
//  XWJIDCodeViewController.m
//  信我家
//
//  Created by Sun on 15/11/27.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJIDCodeViewController.h"
#import <SMS_SDK/SMSSDK.h>
@interface XWJIDCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtFieldIDCode;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPhoneNumber;

@end

@implementation XWJIDCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setStatusBar];
    
    self.navigationItem.title = @"注册";

//    [self setNavigationBar];
    self.txtFieldIDCode.delegate = self;
    self.txtFieldPhoneNumber.delegate = self;
    
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
             NSLog(@"block 获取验证码成功");
             
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
//    UIStoryboard *storyboard = [UIStoryboard  storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
//    UIViewController *resetPassword = [storyboard instantiateViewControllerWithIdentifier:@"resetpwd"]          ;
//    [self.navigationController pushViewController:resetPassword animated:YES];

    [SMSSDK  commitVerificationCode:self.txtFieldIDCode.text
     //传获取到的区号
                        phoneNumber:self.txtFieldPhoneNumber.text
                               zone:@"86"
                             result:^(NSError *error)
     {
         NSString *message ;
         if (!error)
         {
             NSLog(@"验证成功");
             message = @"验证成功";
             
             NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
             [defaults setValue:self.txtFieldPhoneNumber.text forKey:@"username"];
             [defaults synchronize];
             
             UIStoryboard *storyboard = [UIStoryboard  storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
             UIViewController *resetPassword = [storyboard instantiateViewControllerWithIdentifier:@"resetpwd"];
//             UIViewController *resetPassword = [[UIViewController alloc] initWithNibName:@"XWJResetPasswordViewController" bundle:nil];
             [self.navigationController pushViewController:resetPassword animated:YES];
         }
         else
         {
             NSLog(@"验证失败");
             message = @"验证失败";
             UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertview show];
         }
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
