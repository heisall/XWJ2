//
//  XWJMyFindViewCell.m
//  XWJ
//
//  Created by czh on 15/12/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMyFindViewCell.h"

@implementation XWJMyFindViewCell

+(instancetype)XWJmyFindViewCellWithTabaleView:(UITableView *)tableView{
    static NSString *cellid = @"findcell";
    XWJMyFindViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XWJMyFindViewCell" owner:nil options:nil] lastObject];
    }
       
    
    
    
    return cell;


}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
