//
//  MyOrderDetailTableViewCell.h
//  XWJ
//
//  Created by lingnet on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderDetailModel;
@interface MyOrderDetailTableViewCell : UITableViewCell
- (void)configueUI:(MyOrderDetailModel *)model;
@end
