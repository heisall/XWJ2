
//
//  OrderFinishTableViewCell.m
//  XWJ
//
//  Created by lingnet on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "OrderFinishTableViewCell.h"
#import "OrderFinishModel.h"
#import "Masonry.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "UIImageView+WebCache.h"
@interface OrderFinishTableViewCell()
@property (nonatomic, strong) UIView* whiteBgView;
@property (nonatomic, strong) UIImageView* headImagView;
@property (nonatomic, strong) UILabel* titleLable;
@property (nonatomic, strong) UILabel* priceAndTimeLable;
@property (nonatomic, strong) UIButton* evaluationBtn;
@end

@implementation OrderFinishTableViewCell

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
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    
    self.whiteBgView = [[UIView alloc] init];
    [self.contentView addSubview:self.whiteBgView];
    self.whiteBgView.backgroundColor = [UIColor whiteColor];
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_offset(80);
    }];
    
    self.headImagView = [[UIImageView alloc] init];
    self.headImagView.contentMode = UIViewContentModeScaleAspectFit;
    [self.whiteBgView addSubview:self.headImagView];
    [self.headImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whiteBgView).offset(5);
        make.top.mas_equalTo(self.whiteBgView).offset(5);
        make.height.mas_offset(70);
        make.width.mas_offset(70);
    }];
    
    self.titleLable = [[UILabel alloc] init];
    [self.whiteBgView addSubview:self.titleLable];
    self.titleLable.numberOfLines = 1;
    self.titleLable.font = [UIFont systemFontOfSize:14];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteBgView).offset(7);
        make.left.mas_equalTo(self.headImagView.mas_right).offset(3);
        make.right.mas_equalTo(self.whiteBgView).offset(-10);
        make.height.mas_offset(14);
    }];
    
    self.priceAndTimeLable = [[UILabel alloc] init];
    [self.whiteBgView addSubview:self.priceAndTimeLable];
    self.priceAndTimeLable.numberOfLines = 1;
    self.priceAndTimeLable.font = [UIFont systemFontOfSize:12];
    self.priceAndTimeLable.alpha = 0.4;
    
    [self.priceAndTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteBgView).offset(26);
        make.left.mas_equalTo(self.headImagView.mas_right).offset(3);
        make.right.mas_equalTo(self.whiteBgView).offset(-10);
        make.height.mas_offset(12);
    }];
    
    self.evaluationBtn = [[UIButton alloc] init];
    [self.evaluationBtn addTarget:self action:@selector(evaluationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteBgView addSubview:self.evaluationBtn];
    self.evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.evaluationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteBgView.mas_bottom).offset(-30);
        make.right.mas_equalTo(self.whiteBgView).offset(-20);
        make.width.offset(40);
        make.height.offset(20);
    }];
    
    self.hyb_lastViewInCell = self.whiteBgView;
    self.hyb_bottomOffsetToCell = 0;
    
}
- (void)evaluationBtnClick{
    [self.OrderFinishDelegate pinglun:self.cellIndex];
}
- (void)configueUI:(OrderFinishModel *)model{
    [self.headImagView sd_setImageWithURL:[NSURL URLWithString:model.headImageStr] placeholderImage:[UIImage imageNamed:@""]];

    self.titleLable.text = model.titleStr;
    
    self.priceAndTimeLable.text = model.priceAndTimeStr;
    
    if (model.e_status) {
        self.evaluationBtn.userInteractionEnabled = NO;
        self.evaluationBtn.backgroundColor = [UIColor whiteColor];
        [self.evaluationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.evaluationBtn setTitle:@"已评价" forState:UIControlStateNormal];
    }else{
        self.evaluationBtn.userInteractionEnabled = YES;
        self.evaluationBtn.backgroundColor = [UIColor greenColor];
        [self.evaluationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.evaluationBtn setTitle:@"待评价" forState:UIControlStateNormal];
    }
}
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color {
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
