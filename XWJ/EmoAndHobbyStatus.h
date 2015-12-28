//
//  EmoAndHobbyStatus.h
//  XWJ
//
//  Created by 王兴华 on 15/12/22.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmoAndHobbyStatus : NSObject
+(void)getEmotionDataSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure ;
+(void)getHobbyDataSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;
+(void)getOtherDataSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
