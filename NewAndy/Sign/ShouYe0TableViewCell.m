

//
//  ShouYe0TableViewCell.m
//  E展汇
//
//  Created by lingnet on 16/1/7.
//  Copyright © 2016年 徐仁强. All rights reserved.
//

#import "ShouYe0TableViewCell.h"

#import "SDCycleScrollView.h"

#import "ShouYe0Model.h"

#import "Masonry.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "UIImageView+WebCache.h"

@interface ShouYe0TableViewCell()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation ShouYe0TableViewCell

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style
                      reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    
    return self;
}
- (void)makeUI{
    //网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/2) imageURLStringsGroup:nil]; // 模拟网络延时情景
    [self.contentView addSubview:self.cycleScrollView];
    // 必须加上这句
    self.hyb_lastViewInCell = self.cycleScrollView;
    self.hyb_bottomOffsetToCell = 0;
}
- (void)configCellWithModel:(ShouYe0Model *)model {
    NSLog(@"穿过来的数组-----%@",model.picArr);
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.currentPageDotColor = [UIColor blackColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView.pageDotColor = [UIColor whiteColor];
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"devAdv_default"];
    self.cycleScrollView.autoScrollTimeInterval = 4.0;
    NSArray *array = model.picArr;
    self.cycleScrollView.imageURLStringsGroup = array;
}
#pragma mark - 轮滚点击代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", index);
    [self.ShouYe0Delegate didselectADPic:index];
}
@end
