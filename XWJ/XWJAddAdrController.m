//
//  XWJAddAdrController.m
//  XWJ
//
//  Created by Sun on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJAddAdrController.h"
#import "XWJAccount.h"
#import "XWJUtil.h"
#import "ProgressHUD/ProgressHUD.h"
@implementation XWJAddAdrController
#define  PADTOP 66
#define  heigth   50
-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"添加地址";
    self.phoneTf.text  =[XWJAccount instance].account;
    self.defBtn.selected = YES;
}
- (IBAction)btn:(UIButton *)sender {
    sender.selected = !sender.selected;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//-(void)addAddress{
//    
//}

- (IBAction)done:(id)sender {
    
    NSString *url = GETADDRESS_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"" forKey:@"rentHouse"];
    
    //    NSDate *date = [NSDate date];
    //    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //    formater.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    //    formater.timeZone = [NSTimeZone systemTimeZone];
    //    NSString *time = [formater stringFromDate:date];
    /*
{"account":"177777777777","consignee":"刘能","address":"2单元301","phone":"13333333333","isDefault":"1"}
     */
    
    if (!self.phoneTf.text.length>0) {
        [ProgressHUD showError:@"手机号码必填！"];
        return;
    }else if (self.phoneTf.text.length!=11){
        [ProgressHUD showError:@"手机号码位数不正确！"];
        return;
    }
    if (!self.nameTf.text.length>0) {
        [ProgressHUD showError:@"联系人姓名必填！"];
        return;
    }
    
    if (!self.addressTf.text.length>0) {
        [ProgressHUD showError:@"详细地址必填！"];
        return;
    }

    [dict setValue:[XWJAccount instance].account forKey:@"account"];
    [dict setValue:self.nameTf.text forKey:@"consignee"];
    [dict setValue:self.addressTf.text forKey:@"address"];
    [dict setValue:self.phoneTf.text forKey:@"phone"];

    [dict setValue:[NSString stringWithFormat:@"%d",self.defBtn.selected] forKey:@"isDefault"];
    
    NSString * str = [XWJUtil dataTOjsonString:dict];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:str forKey:@"address"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];

            if ([nu integerValue]== 1) {
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
            }else{
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
            }
            [self.navigationController popViewControllerAnimated:YES];
            CLog(@"dic %@",dic);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

@end
