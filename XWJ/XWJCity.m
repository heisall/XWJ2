//
//  XWJCity.m
//  XWJ
//
//  Created by Sun on 15/12/13.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJCity.h"
#import "AFNetworking.h"
#import "XWJdef.h"
#import "XWJAccount.h"
#import "ProgressHUD.h"
@implementation XWJCity


//@synthesize city;
+ (instancetype) instance {
    static XWJCity *_CTLClient;
    if ( _CTLClient==nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            _CTLClient=[[XWJCity alloc] init ];
        });
    }
    
    return _CTLClient;
}


-(void)selectCity:(NSInteger)index{
    _cno = [[_citys objectAtIndex:index] valueForKey:CityNo];
    _city = [_citys objectAtIndex:index];
    
}

-(void)selectDistrict:(NSInteger)index{
    _aid = [[_districts objectAtIndex:index] valueForKey:a_id];
    _district = [_districts objectAtIndex:index];

}

-(void)selectBuilding:(NSInteger)index{
    _bid = [[_buidings objectAtIndex:index] valueForKey:b_id];
    _buiding = [_buidings objectAtIndex:index];
}


-(void)selectRoom:(NSInteger)index{
    _rid = [[_rooms objectAtIndex:index] valueForKey:@"R_id"];
    _rdy = [[_rooms objectAtIndex:index] valueForKey:@"R_dy"];
    _ju_RID  = [[_rooms objectAtIndex:index] valueForKey:@"JU_RID"];
    _room = [_rooms objectAtIndex:index];

}

//userid 用户id A_id 小区a_id,B_id楼座b_id R_dy房间r_dr U_id业主u_id JU_RID房间ju_rid, Types类型角色（1，2，3）
-(void)bindRoom:(NSString *)index :(void (^)(NSInteger arr))success{
    NSString *url = LOCKROOM_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    XWJAccount *account = [XWJAccount instance];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:account.uid forKey:@"userid"];
    [dict setValue:_aid  forKey:@"A_id"];
    [dict setValue:_bid  forKey:@"B_id"];
    [dict setValue:_rdy  forKey:@"R_dy"];
    [dict setValue:_ju_RID  forKey:@"JU_RID"];
    [dict setValue:[_yezhu valueForKey:@"U_id"] forKey:@"U_id"];
    [dict setValue:index forKey:@"Types"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
//            NSArray *arr  = [dic objectForKey:@"data"];
//            for (NSDictionary *d in arr) {
//                NSLog(@"dic %@",d);
//            }
            
            NSNumber * result = [dic valueForKey:@"result"];
            NSString *errCode ;
            if ([result intValue]== 1) {
                
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bind"];
//                [[NSUserDefaults standardUserDefaults] setValue:_aid forKey:@"a_id"];
                [XWJAccount instance].aid = _aid;
//                [[NSUserDefaults standardUserDefaults] setValue:[XWJAccount instance].account forKey:@"username"];
//                [[NSUserDefaults standardUserDefaults] setValue:[_district objectForKey:a_name] forKey:@"xiaoqu"];

                XWJCity *cityinstance = [XWJCity instance];
 
                NSString *area = [_district objectForKey:a_name];
                NSString *build = [cityinstance.buiding valueForKey:b_name];
                NSString *roomNum = [cityinstance.room valueForKey:@"R_id"];
                NSString *dy = [cityinstance.room valueForKey:@"R_dy"];
                NSString *huname = [NSString stringWithFormat:@"%@%@%@单元%@",area,build,dy,roomNum];
                [[NSUserDefaults standardUserDefaults] setValue:huname forKey:@"huname"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                errCode = @"绑定成功";
                success(1);
            }else{
                errCode = [dic objectForKey:@"errorCode"];
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertview show];
                NSLog(@"dic %@",dic);
            }
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail ",__FUNCTION__);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}


//参数：a_id:小区id,b_id：楼号id,r_dy：单元,r_id:房间号
-(void)getInfoValidate:(void (^)(NSDictionary *diction ))success{
    NSString *url = YEZHU_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_aid  forKey:a_id];
    [dict setValue:_bid  forKey:b_id];
    [dict setValue:_rdy  forKey:RDY];
    [dict setValue:_rid  forKey:R_id];

//    [dict setValue:@"1"  forKey:a_id];
//    [dict setValue:@"1"  forKey:b_id];
//    [dict setValue:@"1"  forKey:RDY];
//    [dict setValue:@"101"  forKey:R_id];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSDictionary *data  = [dic objectForKey:@"data"];
                NSLog(@"dic %@",data);
            success(data);
//
//            if ([data objectForKey:@"info"]==[NSNull null]) {
//                [ProgressHUD showError:@"没有业主信息" ];
//                success(nil) ;
//            }
//            
//            _yezhu = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"info"]];
//            NSLog(@"dic %@",dic);
//            success(_yezhu);
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail ",__FUNCTION__);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}


-(void)getCity:(void (^)(NSArray *arr))success{
    
    NSString *url = GETCITY_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    //    [dict setValue:pwd forKey:@"password"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSArray *arr  = [dic objectForKey:@"data"];
            for (NSDictionary *d in arr) {
                NSLog(@"dic %@",d);
            }
            
            _citys = [NSMutableArray array];
            [_citys addObjectsFromArray:arr];

            success(arr);
            NSLog(@"dic %@",dic);
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail ",__FUNCTION__);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}


-(void)getDistrct:(void (^)(NSArray *arr))success{
    NSString *url = GETDISTRICT_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_cno  forKey:@"cityNo"];
    
//    NSLog(@"getDistrct %@",_cno);
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSArray *arr  = [dic objectForKey:@"data"];
            for (NSDictionary *d in arr) {
                NSLog(@"district %@",d);
            }
            
            _districts = [NSMutableArray array];
            [_districts addObjectsFromArray:arr];

            success(arr);
            NSLog(@"dic %@",dic);
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail ",__FUNCTION__);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}

-(void)getBuiding:(void (^)(NSArray *arr))success{
    NSString *url = GETBUIDING_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_aid  forKey:@"a_id"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSArray *arr  = [dic objectForKey:@"data"];
            for (NSDictionary *d in arr) {
                NSLog(@"dic %@",d);
            }
            
            _buidings = [NSMutableArray array];
            [_buidings addObjectsFromArray:arr];
            success(arr);
            NSLog(@"dic %@",dic);
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail ",__FUNCTION__);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}

-(void)getActive:(NSString *)type :(void (^)(NSArray *arr))success{
    NSString *url = GETACTIVE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:_aid  forKey:@"a_id"];
        [dict setValue:@"1"  forKey:@"a_id"];
    [dict setValue:type  forKey:@"types"];
    [dict setValue:@"0" forKey:@"pageindex"];
    [dict setValue:@"20"  forKey:@"countperpage"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSArray *arr  = [dic objectForKey:@"data"];
            for (NSDictionary *d in arr) {
                NSLog(@"dic %@",d);
            }

            success(arr);
            NSLog(@"dic %@",dic);
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}

-(void)getRoom:(void (^)(NSArray *arr))success{
    NSString *url = GETROOM_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_aid  forKey:@"a_id"];
    [dict setValue:_bid  forKey:@"b_id"];

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSArray *arr  = [dic objectForKey:@"data"];
            for (NSDictionary *d in arr) {
                NSLog(@"dic %@",d);
            }
            _rooms = [NSMutableArray array];
            [_rooms addObjectsFromArray:arr];
            success(arr);
            NSLog(@"dic %@",dic);
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}



@end
