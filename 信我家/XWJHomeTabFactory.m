//
//  HomeTabFactory.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJHomeTabFactory.h"
#import "XWJHomeViewController.h"
#import "XWJTabBarItem.h"
@implementation XWJHomeTabFactory


/**
 *  生产controller产品实例
 *
 *  @return <#return value description#>
 */
-(UIViewController *)createControllerInstance{
//    UIViewController * home = [[XWJHomeViewController alloc] init];
    
    UIStoryboard * homeS = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
    UIViewController *home = [homeS instantiateInitialViewController];
    return home;
}

/**
 *  生产底部Tab产品实例
 *
 *  @return <#return value description#>
 */
-(UITabBarItem *)createTab{
    
    UITabBarItem * tabItem = [[XWJTabBarItem alloc] init];
    tabItem.title = @"首页";
    
/*
    if (IOS8) {
        tabItem.image = [[UIImage imageNamed:@"tab_device_unselect.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabItem.selectedImage = [[UIImage imageNamed:@"tab_device_select.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        [tabItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_device_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_device_unselect.png"]];
    }
 */
 return tabItem;
}

@end
