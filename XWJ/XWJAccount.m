//
//  XWJAccount.m
//  XWJ
//
//  Created by Sun on 15/12/7.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJAccount.h"
#import "XWJdef.h"
@implementation XWJAccount


+ (instancetype) instance {
    static XWJAccount *_CTLClient;
    if ( _CTLClient==nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            _CTLClient=[[XWJAccount alloc] init ];
        });
    }
    
    return _CTLClient;
}

-(void)login:(NSString *)username :(NSString *)pwd{
    if (username.length>0&&pwd.length>0) {
        
        //        NSString *url = @"http://www.hisenseplus.com:8100/appPhone/rest/user/userLogin";
        NSString *url = LOGIN_URL;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:username forKey:@"account"];
        [dict setValue:pwd forKey:@"password"];
        
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            NSNumber * result = [dic valueForKey:@"result"];
            
            /*
             Account = 15092245487;
             AccountCount = 0;
             DictValue = "<null>";
             LastLoginIP = "<null>";
             LastLoginTime = "<null>";
             NAME = "<null>";
             NickName = "<null>";
             PhoneType = iPhone;
             Photo = "<null>";
             "R_id" = 24215;
             RegisterIP = "168.0.0.1";
             RegisterTime = "2015-12-07";
             TEL = "<null>";
             Types = 1;
             "U_id" = 1;
             gxqm = "<null>";
             id = 13;
             sex = "<null>";
             */
            if ([result intValue]== 1) {
                
                NSString *uname = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
                NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
                //            [XWJAccount instance].uid = ;
                if (![username isEqualToString:uname]) {
                    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"password"];
                    //                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bind"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else if(![pwd isEqualToString:pass]){
                    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"password"];
                }
                
                NSDictionary *userDic = [[dic objectForKey:@"data"] objectForKey:@"user"];
                NSString *sid = [userDic valueForKey:@"id"];
                NSLog(@"sid %@",sid);
                [XWJAccount instance].uid = sid;
                [XWJAccount instance].account = [userDic valueForKey:@"Account"];
                [XWJAccount instance].password = pass;
                [XWJAccount instance].NickName =[userDic valueForKey:@"NickName"];
                [XWJAccount instance].name = [userDic valueForKey:@"NAME"];
                [XWJAccount instance].Sex = [userDic valueForKey:@"sex"];
                [XWJAccount instance].phone = [userDic valueForKey:@"TEL"];
                /*
                 "A_id" = 4;
                 "A_name" = "\U9ea6\U5c9b\U91d1\U5cb8";
                 isDefault = 1;
                 */
                [XWJAccount instance].array = [[dic objectForKey:@"data"] valueForKey:@"area"];
                if ([XWJAccount instance].array&&[XWJAccount instance].array.count>0) {
                    for (NSDictionary *di in [XWJAccount instance].array ) {
                        if ([[di valueForKey:@"isDefault" ] integerValue]== 1) {
                            [XWJAccount instance].aid = [NSString stringWithFormat:@"%@",[di valueForKey:@"A_id"]];
                        }
                    }
                }
                
            }else{
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"log fail ");
     
        }];
    }else{
 
    }
    

}

- (void)loginSuccess:(void (^)(NSData *))success
             failure:(void (^)(NSError *error))failure{
    
    //        NSString *url = @"http://www.hisenseplus.com:8100/appPhone/rest/user/userLogin";
    NSString *url = LOGIN_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.account forKey:@"account"];
    [dict setValue:self.password forKey:@"password"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"log success ");
        success((NSData *)responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
-(void)logout{
    self.uid= nil;
    self.account= nil;
    self.password= nil;
    self.NickName = nil;
    self.phone = nil;
    self.name = nil;
    self.Sex = nil;
    self.jifen = nil;
    self.money = nil;
    self.ganqing = nil;
    self.intrest = nil;
    self.qianming = nil;
    self.aid = nil;
}

@end
