//
//  OrderFinishTableViewCell.h
//  XWJ
//
//  Created by lingnet on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderFinishModel;
@protocol OrderFinishTableViewCellDelegate <NSObject>
- (void)pinglun:(NSInteger)index;
@end
@interface OrderFinishTableViewCell : UITableViewCell
@property(nonatomic,assign)NSInteger cellIndex;
@property(nonatomic,weak)id<OrderFinishTableViewCellDelegate>OrderFinishDelegate;
- (void)configueUI:(OrderFinishModel*)model;
@end
