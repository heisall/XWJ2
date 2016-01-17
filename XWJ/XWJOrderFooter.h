//
//  XWJOrderFooter.h
//  XWJ
//
//  Created by Sun on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XWJOrderTableViewCellDelegate <NSObject>
- (void)delegateMyOrder:(NSInteger)index;
@end
@interface XWJOrderFooter : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property(nonatomic,assign)NSInteger cellIndex;
@property(nonatomic,weak)id<XWJOrderTableViewCellDelegate>delegateMyOrderDelegate;
@end
