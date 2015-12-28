//
//  XWJGZTableViewCell.h
//  XWJ
//
//  Created by Sun on 15/12/13.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWJGZTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *rateView;

@property (weak, nonatomic) IBOutlet UIButton *pingjiaBtn;
@end
