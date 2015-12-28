//
//  ITabFactory.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  tab工厂接口，生产包括controller和底部tabitem的两类产品
 */
@protocol ITabFactory <NSObject>


/**
 *  生产controller产品实例
 *
 *  @return <#return value description#>
 */
-(UIViewController *)createControllerInstance;

/**
 *  生产底部Tab产品实例
 *
 *  @return <#return value description#>
 */
-(UITabBarItem *)createTab;

@end
