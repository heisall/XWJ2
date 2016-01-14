

//
//  MyOrderDetailTableViewCell.m
//  XWJ
//
//  Created by lingnet on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "MyOrderDetailTableViewCell.h"

#import "Masonry.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

#import "UIImageView+WebCache.h"

#import "MyOrderDetailModel.h"
@interface MyOrderDetailTableViewCell()
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UILabel* payStatusLable;
@property (nonatomic, strong) UILabel* sendTimeLable;
@property (nonatomic, strong) UILabel* orderNumLable;
@property (nonatomic, strong) UILabel* payTypeLable;
@property (nonatomic, strong) UIImageView* payTypeImageView;
@property (nonatomic, strong) UILabel* payTypeYLable;
@property (nonatomic, strong) UIButton* evaluationBtn;
@end

@implementation MyOrderDetailTableViewCell

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
    self.payStatusLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.payStatusLable];
    self.payStatusLable.numberOfLines = 1;
    self.payStatusLable.font = [UIFont systemFontOfSize:14];
    self.payStatusLable.textColor = [self colorWithHexString:@"ad0512"];
    
    [self.payStatusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_offset(14);
    }];
    
    self.orderNumLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.orderNumLable];
    self.orderNumLable.numberOfLines = 1;
    self.orderNumLable.textColor = [self colorWithHexString:@"9f9f9f"];
    self.orderNumLable.font = [UIFont systemFontOfSize:12];
    
    [self.orderNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.payStatusLable.mas_bottom).offset(7);
        make.left.mas_equalTo(self.payStatusLable);
        make.right.mas_equalTo(self.payStatusLable);
        make.height.mas_offset(12);
    }];
    
    self.sendTimeLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.sendTimeLable];
    self.sendTimeLable.numberOfLines = 1;
    self.sendTimeLable.textColor = [self colorWithHexString:@"9f9f9f"];
    self.sendTimeLable.font = [UIFont systemFontOfSize:12];
    
    [self.sendTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderNumLable.mas_bottom).offset(7);
        make.left.mas_equalTo(self.payStatusLable);
        make.right.mas_equalTo(self.payStatusLable);
        make.height.mas_offset(12);
    }];
    
    self.lineView = [[UIView alloc] init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.sendTimeLable.mas_bottom).offset(7);
        make.right.mas_equalTo(0);
        make.height.mas_offset(0.5);
    }];
    
    self.payTypeLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.payTypeLable];
    self.payTypeLable.numberOfLines = 1;
    self.payTypeLable.text = @"支付方式";
    self.payTypeLable.textColor = [self colorWithHexString:@"14bfaf"];
    self.payTypeLable.font = [UIFont systemFontOfSize:14];
    
    [self.payTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(7);
        make.left.mas_equalTo(self.payStatusLable);
        make.width.mas_offset(100);
        make.height.mas_offset(14);
    }];
    
    self.payTypeImageView = [[UIImageView alloc] init];
    self.payTypeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.payTypeImageView];
    [self.payTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payTypeLable.mas_right).offset(7);
        make.top.mas_equalTo(self.payTypeLable);
        make.height.mas_offset(15);
        make.width.mas_offset(15);
    }];
    
    self.payTypeYLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.payTypeYLable];
    self.payTypeYLable.numberOfLines = 1;
    self.payTypeYLable.textColor = [self colorWithHexString:@"9f9f9f"];
    self.payTypeYLable.font = [UIFont systemFontOfSize:14];
    
    [self.payTypeYLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.payTypeLable);
        make.left.mas_equalTo(self.payTypeImageView.mas_right).offset(7);
        make.right.mas_equalTo(-5);
        make.height.mas_offset(14);
    }];
    
    self.hyb_lastViewInCell = self.payTypeYLable;
    self.hyb_bottomOffsetToCell = 5;
}
- (void)configueUI:(MyOrderDetailModel *)model{
    self.payStatusLable.text = model.payStatusStr;
    
    self.orderNumLable.text = model.orderNumStr;
    
    self.sendTimeLable.text = model.sendTimeStr;
    
    [self.payTypeImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    self.payTypeImageView.backgroundColor = [UIColor redColor];
    
    self.payTypeYLable.text = model.payTypeStr;
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
