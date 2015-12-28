//
//  XWJResetPasswordViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJResetPasswordViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "XWJUrl.h"
#import "XWJAccount.h"
#import "XWJUtil.h"
#import "ProgressHUD.h"
@interface XWJResetPasswordViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPwd;

@end

@implementation XWJResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)done:(id)sender {
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    [defaults setValue:self.txtFieldPwd.text forKey:@"password"];
//    [defaults synchronize];
    
    [self.txtFieldPwd resignFirstResponder];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self regist:self.user Pass:self.txtFieldPwd.text];
    
}

-(int)regist:(NSString *) user Pass:(NSString *)pwd{
    __block int ret = 0;

    NSString *url = REGISTER_URL;
    NSLog(@"%p url %@",__FUNCTION__,url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%@",user] forKey:@"account"];
    [dict setValue:[NSString stringWithFormat:@"%@",pwd] forKey:@"password"];
    [dict setValue:[XWJUtil deviceString] forKey:@"type"];
    [dict setValue:[XWJUtil deviceIPAdress] forKey:@"ip"];

//        [dict setValue:@"15092244444" forKey:@"account"];
//        [dict setValue:@"111111" forKey:@"password"];
//        [dict setValue:@"iPhone" forKey:@"type"];
//        [dict setValue:@"192.168.0.1" forKey:@"ip"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"res success ");
        
        if(responseObject){
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"zhu ce res %@",dic);
        
        NSNumber * result = [dic valueForKey:@"result"];
        
            if ([result intValue]== 1) {
                
                NSString *sid = [[[dic valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"id"];
                NSLog(@"sid %@",sid);
                [XWJAccount instance].uid = sid;
                [XWJAccount instance].account = [[[dic valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"Account"];
                [XWJAccount instance].password = pwd;
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
                
//                [ProgressHUD showSuccess:@"注册成功"];
                
                
            }else{
                NSString *errCode = [dic objectForKey:@"errorCode"];
                [ProgressHUD showError:errCode];
//            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alertview.delegate = self;
//                alertview.tag = 100;
//            [alertview show];
            }
        }
//        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
//        
//        if ([jsonObject isKindOfClass:[NSDictionary class]]){
//            
//            NSDictionary *dictionary = (NSDictionary *)responseObject;
//            
//            NSLog(@"Dersialized JSON Dictionary = %@", dictionary);
////            
//        }else if ([jsonObject isKindOfClass:[NSArray class]]){
//            
//            NSArray *nsArray = (NSArray *)jsonObject;
//            
//            NSLog(@"Dersialized JSON Array = %@", nsArray);
//            
//        } else {
//            
//            NSLog(@"An error happened while deserializing the JSON data.");
//            
//        }
        ret = 1;
//        [self.navigationController popToRootViewControllerAnimated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"res fail ");
        ret = 0;
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

    return ret;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView.tag == 100) {
        return;
    }
//    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"xuanzefangshi"];
    
//    [self.navigationController showViewController:view sender:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"设置密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
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
