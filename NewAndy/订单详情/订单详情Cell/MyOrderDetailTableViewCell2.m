//
//  MyOrderDetailTableViewCell2.m
//  XWJ
//
//  Created by lingnet on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "MyOrderDetailTableViewCell2.h"

#import "Masonry.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

#import "UIImageView+WebCache.h"

#import "MyOrderDetailModel2.h"
@interface MyOrderDetailTableViewCell2()

@property (nonatomic, strong) UILabel* goodsTitleLable;
@property (nonatomic, strong) UILabel* goodsNumLable;
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UIImageView* goodsHeadImageView;

@end
@implementation MyOrderDetailTableViewCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
- (void)makeUI{
    self.goodsHeadImageView = [[UIImageView alloc] init];
    self.goodsHeadImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.goodsHeadImageView];
    [self.goodsHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
        make.height.mas_offset(40);
        make.width.mas_offset(40);
    }];
    
    self.goodsTitleLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.goodsTitleLable];
    self.goodsTitleLable.numberOfLines = 2;
    self.goodsTitleLable.font = [UIFont systemFontOfSize:12];
    
    [self.goodsTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(self.goodsHeadImageView.mas_right).offset(7);
        make.right.mas_equalTo(-5);
    }];
    
    self.goodsNumLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.goodsNumLable];
    self.goodsNumLable.numberOfLines = 1;
    self.goodsNumLable.font = [UIFont systemFontOfSize:12];
    self.goodsNumLable.textColor = [self colorWithHexString:@"9f9f9f"];
    [self.goodsNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsTitleLable.mas_bottom).offset(7);
        make.right.mas_equalTo(-5);
        make.height.mas_offset(12);
    }];
    
    self.lineView = [[UIView alloc] init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = [self colorWithHexString:@"9f9f9f"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_offset(0.5);
    }];
    
    self.hyb_lastViewInCell = self.goodsNumLable;
    self.hyb_bottomOffsetToCell = 10;
    
}
- (void)configueUI:(MyOrderDetailModel2 *)model{
    self.goodsTitleLable.text = model.goodsDesStr;
    NSLog(@"***********商品名字*****%@",model.goodsDesStr);
    [self.goodsHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsHeadImageStr] placeholderImage:[UIImage imageNamed:@""]];
    self.goodsHeadImageView.backgroundColor = [UIColor redColor];
    
    self.goodsNumLable.text = model.goodNumStr;
    
}
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
- (UIColor *) colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
