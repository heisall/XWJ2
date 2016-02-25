//
//  XWJCity.h
//  XWJ
//
//  Created by Sun on 15/12/13.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#define  CityName @"CityName"
#define  a_id @"a_id"
#define  b_id @"b_id"
#define   R_id @"r_id"
#define  CityNo @"CityNo"
#define  a_name @"a_name"
#define  b_name @"b_name"
#define  JU_RID @"JU_RID"
#define  RDY @"r_dy"
//#define  CityName @"CityName"
//#define  CityName @"CityName"
//#define  CityName @"CityName"
//#define  CityName @"CityName"
//#define  CityName @"CityName"
//#define  CityName @"CityName"

@interface XWJCity : NSObject
@property NSString *name;
@property NSNumber *cid;
@property NSString *aid;
@property NSNumber *bid;
@property NSString *rid;
@property NSString *ju_RID;
@property NSString *rdy;


@property NSNumber *gps;
@property NSString *cno;
@property NSNumber *index;

@property NSDictionary *city;
@property NSDictionary *district;
@property NSDictionary *buiding;
@property NSDictionary *room;
@property NSDictionary *yezhu;

@property NSMutableArray *citys;
@property NSMutableArray *districts;
@property NSMutableArray *buidings;
@property NSMutableArray *rooms;


+ (instancetype) instance ;


/*
 
 CityName = "\U6d4e\U5357\U5e02";
 CityNo = 3701;
 GPS = 1;
 SortIndex = 1;
 id = 5;
 */

-(void)getCity:(void (^)(NSArray *arr))success;


//参数：cityNo 城市的cityNo
//-(void)getDistrct:(NSNumber *)no :(void (^)(NSArray *arr))success;


/*
 GPS = "<null>";
 "JU_AID" = 2;
 SortIndex = 2;
 "a_id" = 2;
 "a_name" = "\U6e56\U5c9b\U4e16\U5bb6";
 id = 2;
 */
-(void)getDistrct:(void (^)(NSArray *arr))success;

/*
 "b_id" = DXS01;
 "b_name" = "\U5730\U4e0b\U5ba401";
 id = 828;
 */
//参数：a_id 小区的a_id
-(void)getBuiding:(void (^)(NSArray *arr))success;


/*
AppID = "<null>";
"JU_RID" = 9788;
"R_dy" = 1;
"R_id" = 101;
"R_lc" = 1;
"U_id" = 3932;
id = 9788;
 */
//参数：a_id 小区a_id b_id楼房的b_id
-(void)getRoom:(void (^)(NSArray *arr))success;



//userid 用户id A_id 小区a_id,B_id楼座b_id R_dy房间r_dr U_id业主u_id JU_RID房间ju_rid, Types类型角色（1，2，3）
-(void)bindRoom:(NSString *)index :(void (^)(NSInteger arr))success;

-(void)selectCity:(NSInteger)index;

-(void)selectDistrict:(NSInteger)index;

-(void)selectBuilding:(NSInteger)index;

-(void)selectRoom:(NSInteger)index;

/*
 ClickCount = 34;
 addTime = "2015-12-10";
 content = "http://mp.weixin.qq.com/s?__biz=MzA3MDYyNzMyNg==&mid=402185314&idx=1&sn=62649235951c5f66fe1bafef7f2066ff&scene=0#wechat_redirect";
 description = "\U6d77\U4fe1\U201c\U4fe1\U6211\U5bb6\U201d\U667a\U6167\U793e\U533aAPP\U662f\U6211\U516c\U53f8\U81ea\U5df1\U7814\U53d1\U7684\U4e00\U4e2aAPP\U7ba1\U7406\U8f6f\U4ef6\U3002";
 id = 5;
 isUrl = 1;
 title = "\U6d77\U4fe1\U201c\U4fe1\U6211\U5bb6\U201d\U667a\U6167\U793e\U533aAPP\U5f00\U59cb\U6d4b\U8bd5\U4e86\U3002";
 types = 0;
 */
-(void)getActive:(NSString *)type :(void (^)(NSArray *arr))success;
-(void)getActive:(NSString *)type WithPage:(NSString*)pageStr :(void (^)(NSArray *arr))success;

/*
 data =     {
 info =         {
 "A_id" = 1;
 "App_uid" = "<null>";
 "B_id" = 1;
 "Ju_uid" = "<null>";
 OutState = 0;
 "R_dy" = 1;
 "R_id" = 101;
 "U_id" = 1;
 "U_name" = "\U8d75\U5b66\U667a";
 id = 1;
 mobilePhone = "13356457845,15689454652,15894662353";
 tel = "<null>";
 };
 roles =         (
 {
 DictKey = "key_usertype";
 DictValue = 1;
 ID = 49;
 Memo = "\U623f\U4ea7\U8bc1\U5728\U6211\U540d\U4e0b";
 },
 };
 errorCode = "";
 result = 1;
 }
 */
//参数：a_id:小区id,b_id：楼号id,r_dy：单元,r_id:房间号
-(void)getInfoValidate:(void (^)(NSDictionary *dic))success;

@end
