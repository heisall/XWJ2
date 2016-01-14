//
//  OrderFinishModel.h
//  XWJ
//
//  Created by lingnet on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderFinishModel : NSObject
@property(nonatomic,copy)NSString* headImageStr;
@property(nonatomic,copy)NSString* titleStr;
@property(nonatomic,copy)NSString* priceAndTimeStr;
@property(nonatomic,assign)NSInteger e_status;
@property(nonatomic,copy)NSString* orderId;
@property(nonatomic,copy)NSString* seller_id;
@property(nonatomic,copy)NSString* goodsId;
@end
