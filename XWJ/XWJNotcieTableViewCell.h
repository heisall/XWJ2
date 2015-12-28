//
//  XWJNotcieTableViewCell.h
//  XWJ
//
//  Created by Sun on 15/12/5.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWJNotcieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@end
