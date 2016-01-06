//
//  XWJOrderTableViewCell.h
//  XWJ
//
//  Created by Sun on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWJOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
