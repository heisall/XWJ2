//
//  chushouModel.h
//  XWJ
//
//  Created by 聚城科技 on 15/12/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "JSONModel.h"

@interface chushouModel : NSObject
@property(nonatomic)int idd;
@property(nonatomic,copy)NSString *buildingArea;
@property(nonatomic,copy)NSString *buildingInfo;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic)int rent;
@property(nonatomic)int house_Indoor;
@property(nonatomic)int house_Toilet;
@property(nonatomic)int house_living;
@property(nonatomic,copy)NSString *city;

@end
