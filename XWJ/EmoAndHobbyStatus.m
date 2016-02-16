//
//  EmoAndHobbyStatus.m
//  XWJ
//
//  Created by jc on 15/12/22.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "EmoAndHobbyStatus.h"
#import "AFNetworking.h"

@implementation EmoAndHobbyStatus
+(void)getEmotionDataSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *qingganUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/user/findEmotions";
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求参数
    NSMutableDictionary *parameters =[[NSMutableDictionary alloc] init];
    
    [manager POST:qingganUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析服务器返回的数据responseObject
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            success(dict);
        }
        CLog(@"dict==%@",responseObject);
        CLog(@"dict==%@",dict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"请求失败");
        if (failure) {
            failure(error);
        }
    }];
    


}
+(void)getHobbyDataSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *qingganUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/user/findHobbies";
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求参数
    NSMutableDictionary *parameters =[[NSMutableDictionary alloc] init];
    
    [manager POST:qingganUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析服务器返回的数据responseObject
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        CLog(@"dict== wori zen me zhe me duo :::%@",responseObject);
        CLog(@"dict==%@",dict);
        if (success) {
            success(dict);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"请求失败");
        if (failure) {
            failure(error);
        }
    }];
}

+(void)getOtherDataSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{



}


@end

