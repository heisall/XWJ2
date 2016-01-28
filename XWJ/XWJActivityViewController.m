//
//  XWJActivityViewController.m
//  XWJ
//
//  Created by Sun on 15/12/5.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJActivityViewController.h"
#import "XWJNoticeViewController.h"
#import "XWJUrl.h"
#import "XWJAccount.h"
#import "XWJBMViewController.h"
@implementation XWJActivityViewController

//#define KEY_TITLE @"title"
//#define KEY_TIME  @"time"
//#define KEY_CONTENT @"content"
//#define KEY_CLICKCOUNT @"count"
//#define KEY_URL @"url"
//#define KEY_ID  @"id"

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:@"baoming"];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yibaoming) name:@"baoming" object:nil];
//    NSLog(@"dic,%@",self.dic);
    NSString *sr = [NSString stringWithFormat:@"%ld",(long)self.dic];
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:sr];
    if ([str isEqualToString:@"yibaoming"]) {
        [self yibaoming];
    }
    if ((NSNull *)[self.dic valueForKey:KEY_AD_TITLE]!=[NSNull null]) {
        
        self.actTitle.text = [self.dic valueForKey:KEY_AD_TITLE];
    }else{
        self.actTitle.text = @"";

    }
    self.btn.layer.cornerRadius = 5;
    
    if ((NSNull *)[self.dic valueForKey:KEY_AD_TIME]!=[NSNull null]) {
        
        self.time.text = [self.dic valueForKey:KEY_AD_TIME];
    }else{
        self.time.text = @"";

    }
    if ((NSNull*)[self.dic valueForKey:KEY_AD_CLICKCOUNT]!=[NSNull null]) {
        
        NSString *count = [NSString stringWithFormat:@"%@",[self.dic objectForKey:KEY_AD_CLICKCOUNT]];
        [self.clickBtn setTitle:count forState:UIControlStateNormal];
    }else{
        self.clickBtn.hidden = YES;
    }
    
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    if (![self.type isEqualToString:@"1"]) {
        self.btn.hidden = YES;
        
        self.webView.frame = CGRectMake(0, 130, SCREEN_SIZE.width, SCREEN_SIZE.height-130);
    }else{
        self.webView.frame = CGRectMake(0, 180, SCREEN_SIZE.width, SCREEN_SIZE.height-180);
    }
    self.webView.scalesPageToFit = TRUE;
    NSString *url = [self.dic valueForKey:KEY_AD_URL];
    if (url&&(NSNull *)url != [NSNull null]) {

        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
    [self setBaoMingEnable];
//    [self getDetailAD];
}

-(void)setBaoMingEnable{
    NSString *isEnrollEnd = [NSString stringWithFormat:@"%@",[self.dic  objectForKey:@"IsEnrollEnd"]];
    NSString *isAllowEnroll = [NSString stringWithFormat:@"%@",[self.dic  objectForKey:@"IsAllowEnroll"]];
    NSString *canEnroll = [NSString stringWithFormat:@"%@",[self.dic  objectForKey:@"canEnroll"]];
    
    
    if ([isEnrollEnd isEqualToString:@"0"]&&[isAllowEnroll isEqualToString:@"1"]&&[canEnroll isEqualToString:@"1"]) {
        self.btn.enabled = YES;
//        self.btn.hidden = YES;
    }else{
//        self.btn.hidden = YES;
        self.btn.enabled = NO;

        if ([isEnrollEnd isEqualToString:@"1"]) {
            [self.btn setTitle:@"报名截止" forState:UIControlStateDisabled];
        }else if([isAllowEnroll isEqualToString:@"0"]){
            [self.btn setTitle:@"暂未开始报名" forState:UIControlStateDisabled];

        }else if([canEnroll isEqualToString:@"0"]){
            [self.btn setTitle:@"我已报名" forState:UIControlStateDisabled];

        }
    }
}



-(void)yibaoming{
    self.btn.enabled = NO;
    NSString *sr = [NSString stringWithFormat:@"%ld",(long)self.dic];
    [[NSUserDefaults standardUserDefaults] setObject:@"yibaoming" forKey:sr];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
}
//参数：id:通知/活动id ，account:用户账号，phone：手机号码， name:姓名
- (IBAction)enroll:(UIButton *)sender {
    
    
    UIStoryboard *st =[UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
    XWJBMViewController *bm = [st instantiateViewControllerWithIdentifier:@"baoming"];
    bm.houdongId = [self.dic valueForKey:KEY_AD_ID];
    [self.navigationController showViewController:bm sender:nil];
    
//    NSString *url = GETENROLL_URL;
//    XWJAccount *account = [XWJAccount instance];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:[self.dic valueForKey:KEY_AD_ID]  forKey:@"id"];
//    [dict setValue:account.account  forKey:@"account"];
//    [dict setValue:account.phone forKey:@"phone"];
//    [dict setValue:account.name  forKey:@"name"];
//    
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%s success ",__FUNCTION__);
//        
//        if(responseObject){
//            NSDictionary *dic = (NSDictionary *)responseObject;
//        
//            NSString *errCode = [dic objectForKey:@"errorCode"];
//            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertview show];
//        
// 
//            NSLog(@"dic %@",dic);
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%s fail %@",__FUNCTION__,error);
//
//    }];
    
    NSLog(@"baoming");
}

@end
