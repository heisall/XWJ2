
//
//  MyOrderDetailTableViewCell1.m
//  XWJ
//
//  Created by lingnet on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "MyOrderDetailTableViewCell1.h"

#import "Masonry.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

#import "UIImageView+WebCache.h"

#import "MyOrderDetailModel1.h"
@interface MyOrderDetailTableViewCell1()
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UIView* lineView1;
@property (nonatomic, strong) UILabel* goodsManLable;
@property (nonatomic, strong) UILabel* phoneLable;
@property (nonatomic, strong) UILabel* goodsAddLable;
@property (nonatomic, strong) UIButton* evaluationBtn;
@end
@implementation MyOrderDetailTableViewCell1

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
    self.lineView = [[UIView alloc] init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = [self colorWithHexString:@"eeeeee"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_offset(6);
    }];
    
    self.goodsManLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.goodsManLable];
    self.goodsManLable.numberOfLines = 1;
    self.goodsManLable.font = [UIFont systemFontOfSize:14];
    
    [self.goodsManLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(7);
        make.left.mas_equalTo(self.contentView).offset(5);
        make.right.mas_offset(-120);
        make.height.mas_offset(14);
    }];
    
    self.phoneLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.phoneLable];
    self.phoneLable.numberOfLines = 1;
    self.phoneLable.textAlignment = NSTextAlignmentRight;
    self.phoneLable.font = [UIFont systemFontOfSize:14];
    
    [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsManLable);
//        make.left.mas_equalTo(self.goodsManLable.mas_right);
        make.right.mas_offset(-5);
        make.height.mas_offset(14);
    }];
    
    self.lineView1 = [[UIView alloc] init];
    [self.contentView addSubview:self.lineView1];
    self.lineView1.backgroundColor = [self colorWithHexString:@"eeeeee"];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.goodsManLable.mas_bottom).offset(7);
        make.right.mas_equalTo(0);
        make.height.mas_offset(0.5);
    }];
    
    self.goodsAddLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.goodsAddLable];
    self.goodsAddLable.numberOfLines = 1;
    self.goodsAddLable.textAlignment = NSTextAlignmentLeft;
    self.goodsAddLable.textColor = [self colorWithHexString:@"9f9f9f"];
    self.goodsAddLable.font = [UIFont systemFontOfSize:14];
    
    [self.goodsAddLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(7);
        make.left.mas_equalTo(self.goodsManLable);
        make.right.mas_offset(-5);
        make.height.mas_offset(14);
    }];
    
    self.hyb_lastViewInCell = self.goodsAddLable;
    self.hyb_bottomOffsetToCell = 5;
}
- (void)configueUI:(MyOrderDetailModel1 *)model {
    self.goodsManLable.text = model.goodsManStr;
    
    self.phoneLable.text = model.phoneStr;
    
    self.goodsAddLable.text = model.goodAddStr;

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
