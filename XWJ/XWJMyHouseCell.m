//
//  XWJMyHouseCell.m
//  XWJ
//
//  Created by JuCheng on 16/1/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJMyHouseCell.h"

@implementation XWJMyHouseCell
+(instancetype)xwjMyHouseCellInitWithTableView:(UITableView *)tableview{
    static NSString *cellid = @"cell101";
    XWJMyHouseCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[XWJMyHouseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XWJMyHouseCell" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
