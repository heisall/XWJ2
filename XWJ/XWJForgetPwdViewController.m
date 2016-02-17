//
//  XWJForgetPwdViewController.m
//  XWJ
//
//  Created by Sun on 15/12/7.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJForgetPwdViewController.h"
#import "XWJForgetPwd2ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"
#import "XWJUrl.h"
#import "XWJAccount.h"
@interface XWJForgetPwdViewController (){
    int timeTick;

    int code;
}
@property NSTimer *timer;

@end

@implementation XWJForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.getpassWord isEqualToString:@"1"]) {
        self.navigationItem.title = @"修改密码";
    }else{
    
        self.navigationItem.title = @"找回密码";
    }
    code = -1;
    timeTick = 61;

    
    /**
     *  注册所有的
     */
    UIControl *controlView = [[UIControl alloc] initWithFrame:self.view.frame];
    [controlView addTarget:self action:@selector(resiginTF) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:controlView atIndex:0];
    controlView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}
//重新发送验证码
-(void)timeFireMethod
{
    timeTick--;
    if(timeTick==0){
        [_timer invalidate];
        self.numlabel.hidden = YES;
        _codeBtn.enabled = YES;
        timeTick = 61;
        [_codeBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        
    }else
    {
        NSString *str = [NSString stringWithFormat:@"%d秒后重新发送",timeTick];
        if (_numlabel.hidden) {
            _numlabel.hidden = NO;
        }
        _numlabel.text = str;
        _codeBtn.titleLabel.text = @"重新发送";
//        [_btnGetcode setTitle:str forState:UIControlStateNormal];
    }
}

-(void)resiginTF
{
    CLog(@"resign");
    [self.textPhone resignFirstResponder];
    [self.txtIdcode resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getIDCode:(id)sender {
    
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:NO];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    _codeBtn.enabled = NO;
    _codeBtn.titleLabel.text = [NSString stringWithFormat:@"60秒后重新发送"];
    [_codeBtn setTitle:@"" forState:UIControlStateNormal];

    code = arc4random()%8999 + 1000;
    
    NSString *uid = @"2735";
    NSString *phone = self.textPhone.text;
    NSString *content = [NSString stringWithFormat:MESSAGE_CONTENT,code];
    NSString *urlStr = [NSString stringWithFormat:IDCODE_URL,uid,phone,content];
    //    NSString *urlStr = [NSString stringWithFormat:@"http://dx.qxtsms.cn/sms.aspx"];
    //    NSString *contnt = [NSString stringWithFormat:@"【信我家】验证码是：%d",code];
    //    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    //    [dic setValue:@"send" forKey:@"action"];
    //    [dic setValue:uid forKey:@"userid" ];
    //    [dic setValue:@"hisenseplus" forKey:@"account" ];
    //    [dic setValue:@"hisenseplus" forKey:@"password" ];
    //    [dic setValue:phone forKey:@"mobile" ];
    //    [dic setValue:contnt forKey:@"content" ];
    //    [dic setValue:@"" forKey:@"sendTime" ];
    //    [dic setValue:@"1" forKey:@"checkcontent" ];
    
    //    NSDictionary *dic = @{action=send&userid=%@&account=hisenseplus&password=hisenseplus&mobile=%@&content=【信我家】验证码是：%d&sendTime=&checkcontent=1",uid,phone,code};
    //    NSURL *url = [NSURL URLWithString:urlStr];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    CLog(@"url %@",urlStr);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    
    [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"success");


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"failure");
    }];
}
- (IBAction)submit:(id)sender {
    
    
    if (code == [self.txtIdcode.text intValue]) {
        
//        UIStoryboard *storyboard = [UIStoryboard  storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
        XWJForgetPwd2ViewController *forget = [self.storyboard instantiateViewControllerWithIdentifier:@"forget2"];

        forget.user = self.textPhone.text;
        [self.navigationController pushViewController:forget animated:YES];
        
    }else{
        NSString *message = @"验证失败";
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
    }
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
