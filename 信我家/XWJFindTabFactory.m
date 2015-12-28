//
//  XWJFindTabFactory.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJFindTabFactory.h"
#import "XWJFindViewController.h"
#import "XWJTabBarItem.h"
@implementation XWJFindTabFactory

/**
 *  生产controller产品实例
 *
 *  @return <#return value description#>
 */
-(UIViewController *)createControllerInstance{
//    UIViewController * home = [[XWJFindViewController alloc] init];
    
    UIStoryboard * findS = [UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
    UIViewController *find = [findS instantiateInitialViewController];
    return find;
}

/**
 *  生产底部Tab产品实例
 *
 *  @return <#return value description#>
 */
-(UITabBarItem *)createTab{
    
    UITabBarItem * tabItem = [[XWJTabBarItem alloc] init];
    tabItem.title = @"发现";
    
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
