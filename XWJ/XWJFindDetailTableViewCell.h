//
//  XWJFindDetailTableViewCell.h
//  XWJ
//
//  Created by Sun on 15/12/5.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWJFindDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *commenterLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
