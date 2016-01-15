//
//  MyOrderDetailViewController.h
//  XWJ
//
//  Created by lingnet on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWJBaseViewController.h"

@protocol MyOrderDetailViewControllerDelegate <NSObject>

- (void)makeSureOrder:(NSInteger)cellNum;

- (void)deleOrder:(NSInteger)cellNum;

@end
@interface MyOrderDetailViewController : XWJBaseViewController
@property(nonatomic,copy)NSString* isDaishouhuo;
@property(nonatomic,copy)NSString* orderId;
@property(nonatomic,copy)NSString* status;

@property(nonatomic,assign)NSInteger makeUsreNum;
@property(nonatomic,weak)id<MyOrderDetailViewControllerDelegate>makeSureDelegate;
@end
