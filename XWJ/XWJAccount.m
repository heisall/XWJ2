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
