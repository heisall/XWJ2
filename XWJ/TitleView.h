//
//  TitleView.h
//  LoveFood
//
//  Created by qianfeng on 15/11/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView


@property (nonatomic,strong) NSArray * titles;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic,copy) void(^buttonSelectAtIndex)(NSInteger index);

@end
