//
//  chuzuTableViewCell.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "chuzuTableViewCell.h"
#import "UIImage+GIF.h"  //加载gif图片的
#import "UIImageView+WebCache.h"  //加载网络图片的
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation chuzuTableViewCell{

    UIImageView *_bgImageV;
    UILabel *_infoLabel;
    UILabel *_houseLabel;
    UILabel *_aearLabel;
    UILabel *_zhuangxiuLabel;
    UILabel *_zufangLabel;
    UILabel *_rentLbel;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    _bgImageV = [[UIImageView alloc]init];
    _bgImageV.frame =CGRectMake(10, 10,150,120);

    [self.contentView addSubview:_bgImageV];
    
    _infoLabel = [[UILabel alloc]init];
    _infoLabel.frame = CGRectMake(170 ,10,200, 40);
    _infoLabel.font = [UIFont systemFontOfSize:17];
    _infoLabel.textColor = [UIColor colorWithRed:0 green:0.66 blue:0.65 alpha:1.00];
    _infoLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_infoLabel];
    
    _houseLabel = [[UILabel alloc]init];
    _houseLabel.frame = CGRectMake(170 ,50, 80, 20);
    _houseLabel.font = [UIFont systemFontOfSize:14];
    _houseLabel.textColor = [UIColor lightGrayColor];
    _houseLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_houseLabel];
    
    _aearLabel = [[UILabel alloc]init];
    _aearLabel.frame = CGRectMake(220 ,50, 100 , 20);
    _aearLabel.font = [UIFont systemFontOfSize:14];
    _aearLabel.textColor = [UIColor lightGrayColor];
    _aearLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_aearLabel];
    
    _zhuangxiuLabel = [[UILabel alloc]init];
    _zhuangxiuLabel.frame = CGRectMake(170 ,70, 60 , 20);
    _zhuangxiuLabel.font = [UIFont systemFontOfSize:14];
    _zhuangxiuLabel.textColor = [UIColor lightGrayColor];
    _zhuangxiuLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_zhuangxiuLabel];
    
    _zufangLabel = [[UILabel alloc]init];
    _zufangLabel.frame = CGRectMake(170 ,90, 60 , 20);
    _zufangLabel.font = [UIFont systemFontOfSize:14];
    _zufangLabel.textColor = [UIColor lightGrayColor];
    _zufangLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_zufangLabel];
    
    _rentLbel = [[UILabel alloc]init];
    _rentLbel.frame = CGRectMake(self.bounds.size.width - 100 ,90, 90 , 20);
    _rentLbel.font = [UIFont systemFontOfSize:14];
    _rentLbel.textColor = [UIColor colorWithRed:0.75 green:0.05 blue:0.01 alpha:1];
    _rentLbel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rentLbel];
}

-(void)setCzModel:(chuzuModel *)czModel{
    
    _czModel = czModel;
    //    NSLog(@"+++++%@",zyModel);
    
    //   NSLog(@"====%@",_zyModel.Cover);
    
    [_bgImageV sd_setImageWithURL:[NSURL URLWithString:_czModel.photo]];
    
    _infoLabel.text = _czModel.buildingInfo;
//    
    _houseLabel.text = [NSString stringWithFormat:@"%d室%d厅",_czModel.house_Indoor,_czModel.house_living];
    
//    if (![_czModel.buildingArea isKindOfClass:[NSNull class]])
//    {
//     }   
    _aearLabel.text = [NSString stringWithFormat:@"%d平方米",_czModel.buildingArea ];
    
    _zhuangxiuLabel.text = @"精装修";
    
    _zufangLabel.text = @"整租";
    
//
    _rentLbel.text = [NSString stringWithFormat:@"%d元/月",_czModel.rent];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
