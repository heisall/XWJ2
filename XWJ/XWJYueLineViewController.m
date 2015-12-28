//
//  XWJYueLineViewController.m
//  XWJ
//
//  Created by Sun on 15/12/27.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJYueLineViewController.h"
#import "XWJAccount.h"
#import "ProgressHUD.h"
@interface XWJYueLineViewController ()

@end

@implementation XWJYueLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"在线预约";
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)y:(id)sender {
    [self yuyue];
}

-(void)yuyue{
    NSString *url = GETGOODORDER_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    [dict setValue:[NSString stringWithFormat:@"%@",self.stordid] forKey:@"storeId"];

    [dict setValue:[NSString stringWithFormat:@"%@",self.goodid] forKey:@"goodsId"];
    [dict setValue:[NSString stringWithFormat:@"%@",self.lianxirenTextF.text] forKey:@"contactPreson"];
    [dict setValue:[NSString stringWithFormat:@"%@",self.phoneTextF.text] forKey:@"phone"];//0加入购物车 1修改
    
    /*
     {"account":"177777777777","storeId":"4","goodsId":"4","counts":"1","unitPrice":"24","flg":"1"}
     */
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];
            
            if ([nu integerValue]== 1) {
                
                [ProgressHUD showSuccess:@"预约成功"];
                [self sendSMS];
            }else{
                [ProgressHUD showError:@"预约失败"];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}
-(void)sendSMS{
    NSString *uid = @"2735";
    NSString *phone = self.phoneTextF.text;
    NSString *content = [NSString stringWithFormat:YUYUEMESSAGE_CONTENT,self.goodname,self.lianxirenTextF.text,self.phoneTextF.text];
    NSString *urlStr = [NSString stringWithFormat:IDCODE_URL,uid,phone,content];
    
    NSLog(@"url %@",urlStr);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    
    [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure");
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
