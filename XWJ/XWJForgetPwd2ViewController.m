//
//  XWJForgetPwd2ViewController.m
//  XWJ
//
//  Created by Sun on 15/12/7.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJForgetPwd2ViewController.h"
#import "AFNetworking.h"
#import "XWJTabViewController.h"
#import "XWJUrl.h"
#import "ProgressHUD.h"
@interface XWJForgetPwd2ViewController ()

@end

@implementation XWJForgetPwd2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"找回密码";

}

- (IBAction)showPwd:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
//    if (btn.selected) {
        self.txtPwd.secureTextEntry = btn.selected;
//    }

}

- (IBAction)done:(id)sender {
    
    if (!self.txtPwd.text.length>0) {
        [ProgressHUD showError:@"请输入密码！"];
        return;
    }
    NSString *url = RESETPWD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.user forKey:@"account"];
    [dict setValue:self.txtPwd.text forKey:@"password"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"reset success ");
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"dic %@",dic);
        NSNumber * result = [dic valueForKey:@"result"];
        
        if ([result intValue]== 1) {
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setValue:self.txtPwd.text forKey:@"password"];
            [defaults synchronize];
            XWJTabViewController *tab = [[XWJTabViewController alloc] init];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = tab;
        }else{
            [ProgressHUD showError:[dic objectForKey:@"errorCode"]];
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"reset fail ");
        //        dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *message = @"重置失败";
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        

    }];
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
