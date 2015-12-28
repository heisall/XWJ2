//
//  WuyeTableViewCell.h
//  XWJ
//
//  Created by Sun on 15/12/2.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WuyeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UIButton *dialBtn;

@end
