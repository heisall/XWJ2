//
//  XWJTabBarItem.m
//  信我家
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJTabBarItem.h"

@implementation XWJTabBarItem

-(instancetype)init{
    self = [super init];
    UIColor *tabarTitleNormalColor = [UIColor colorWithRed:144.0/255.0 green:145.0/255.0 blue:146/255.0 alpha:1.0];
    ;

    UIColor *tabarTitleHighlightColor = [UIColor colorWithRed:20.0/255.0 green:157.0/255.0 blue:150/255.0 alpha:1.0];
    ;
    [self setTitleTextAttributes:[NSDictionary
                                  dictionaryWithObjectsAndKeys: tabarTitleNormalColor,
                                  NSForegroundColorAttributeName,[UIFont systemFontOfSize:14.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabarTitleHighlightColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];//高亮状态。
    return self;
}


@end
