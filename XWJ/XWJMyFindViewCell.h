//
//  XWJMyFindViewCell.h
//  XWJ
//
//  Created by 王兴华 on 15/12/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWJMyFindViewCell : UITableViewCell
+(instancetype)XWJmyFindViewCellWithTabaleView:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UIView *View1;
@property (strong, nonatomic) IBOutlet UIView *View2;

@end
