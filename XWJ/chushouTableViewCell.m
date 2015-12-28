//
//  chushouTableViewCell.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "chushouTableViewCell.h"
#import "UIImage+GIF.h"  //加载gif图片的
#import "UIImageView+WebCache.h"  //加载网络图片的
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation chushouTableViewCell{

    UIImageView *_bgImageV;
    UILabel *_infoLabel;
    UILabel *_houseLabel;
    UILabel *_aearLabel;
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
    _aearLabel.frame = CGRectMake(260 ,50, 50 , 20);
    _aearLabel.font = [UIFont systemFontOfSize:14];
    _aearLabel.textColor = [UIColor lightGrayColor];
    _aearLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_aearLabel];
    
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

-(void)setCsModel:(chushouModel *)csModel{
    
    _csModel = csModel;
    //    NSLog(@"+++++%@",zyModel);
    
    //   NSLog(@"====%@",_zyModel.Cover);
    
    [_bgImageV sd_setImageWithURL:[NSURL URLWithString:_csModel.photo]];
//    [_bgImageV setImageWithURL:[NSURL URLWithString:_csModel.photo] placeholderImage:nil];
    
    //   [_iconImage setImageWithURL:[NSURL URLWithString:_sjModel.author.header] placeholderImage:nil];
    _infoLabel.text = _csModel.buildingInfo;
    _houseLabel.text = [NSString stringWithFormat:@"%d室%d厅%d卫",_csModel.house_Indoor,_csModel.house_living,_csModel.house_Toilet];
    if (![_csModel.buildingArea isKindOfClass:[NSNull class]])
    {
        _aearLabel.text = _csModel.buildingArea;
    }
   //
    _zufangLabel.text = _csModel.city;
    _rentLbel.text = [NSString stringWithFormat:@"%d万元",_csModel.rent];
    //    *_infoLabel;
    //    *_houseLabel;
    //    *_aearLabel;
    //    *_zufangLabel
    //    *_rentLbel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
