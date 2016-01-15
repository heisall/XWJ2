//
//  EvaluationViewController.h
//  XWJ
//
//  Created by lingnet on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWJBaseViewController.h"

@protocol EvaluationViewControllerDelegate <NSObject>

- (void)sendBackCellNum:(NSInteger)cellNum;

@end
@interface EvaluationViewController : XWJBaseViewController
@property(nonatomic,copy)NSString* headImageStr;
@property(nonatomic,copy)NSString* titleStr;
@property(nonatomic,copy)NSString* priceAndTimeStr;

@property(nonatomic,copy)NSString* orderId;
@property(nonatomic,copy)NSString* storeId;
@property(nonatomic,copy)NSString* goodsId;
@property(nonatomic,copy)NSString* star;
@property(nonatomic,copy)NSString* comment;
@property(nonatomic,assign)NSInteger commentNumSuccess;
@property(nonatomic,weak)id<EvaluationViewControllerDelegate>evaluationDelegate;
@end
