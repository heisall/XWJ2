//
//  XWJBMViewController.m
//  XWJ
//
//  Created by Sun on 15/12/14.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBMViewController.h"
#import "XWJAccount.h"
#import "ProgressHUD/ProgressHUD.h"
#import "XWJActivityViewController.h"
@interface XWJBMViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *telPhone;

@end

@implementation XWJBMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //  Do any additional setup after loading the view.
    self.navigationItem.title = @"报名";
    
    self.phone.text = [NSString stringWithFormat:@"电话 %@",[XWJAccount instance].account];
    _telPhone.text = [XWJAccount instance].account;
    
}
- (IBAction)baoming:(id)sender {
    
    
    
    [self.phone resignFirstResponder];
    
    if (!self.telPhone.text.length>0||!self.name.text.length>0) {
        [ProgressHUD showError:@"请输入手机号和姓名"];
        return;
    }
    NSString *url = GETENROLL_URL;
    XWJAccount *account = [XWJAccount instance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_houdongId  forKey:@"id"];
    [dict setValue:account.account  forKey:@"account"];
    [dict setValue:self.telPhone.text forKey:@"phone"];
    [dict setValue:self.name.text  forKey:@"name"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            NSString *errCode = [dic objectForKey:@"errorCode"];
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertview show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"baoming" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            NSLog(@"dic %@",dic);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    
    

    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
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
