//
//  XWJGroupBuyTableViewCell.h
//  XWJ
//
//  Created by Sun on 16/1/2.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWJGroupBuyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *price1Label;
@property (weak, nonatomic) IBOutlet UILabel *price2Label;

@property (weak, nonatomic) IBOutlet UIView *qiangView;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *qiangBtn;

@end
