//
//  XWJMindTabFactory.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMindTabFactory.h"
#import "XWJMineViewController.h"
#import "XWJTabBarItem.h"
@implementation XWJMindTabFactory
/**
 *  生产controller产品实例
 *
 *  @return <#return value description#>
 */
-(UIViewController *)createControllerInstance{
    
    UIStoryboard * mineStory = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
//    UIViewController * home = [[XWJMineViewController alloc] init];
    UIViewController *mine = [mineStory instantiateInitialViewController];
    return mine;
}

/**
 *  生产底部Tab产品实例
 *
 *  @return <#return value description#>
 */
-(UITabBarItem *)createTab{
    
    UITabBarItem * tabItem = [[XWJTabBarItem alloc] init];
    tabItem.title = @"我的";
        
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
