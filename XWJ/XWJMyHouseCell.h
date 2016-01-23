//
//  XWJMyHouseCell.h
//  XWJ
//
//  Created by JuCheng on 16/1/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWJMyHouseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *DetailLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;

+(instancetype)xwjMyHouseCellInitWithTableView:(UITableView *)tableview;
@end
