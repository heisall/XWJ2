//
//  XWJResetPasswordViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJResetPasswordViewController.h"

@interface XWJResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPwd;

@end

@implementation XWJResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)done:(id)sender {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setValue:self.txtFieldPwd.text forKey:@"password"];
    [defaults synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"设置密码";
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
