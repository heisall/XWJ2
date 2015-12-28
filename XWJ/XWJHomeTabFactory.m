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
#import "XWJdef.h"
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
    

    if (IOS8) {
        tabItem.image = [[UIImage imageNamed:@"tabbarimg1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabItem.selectedImage = [[UIImage imageNamed:@"tabbarimg1high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        [tabItem setFinishedSelectedImage:[UIImage imageNamed:@"tarbarimg1"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbarimg1high"]];
    }
 
 return tabItem;
}

@end
