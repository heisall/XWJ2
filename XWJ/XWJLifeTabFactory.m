//
//  XWJLifeTabFactory.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJLifeTabFactory.h"
#import "XWJLifeViewController.h"
#import "XWJTabBarItem.h"
#import "XWJSHuoViewController.h"
@implementation XWJLifeTabFactory

/**
 *  生产controller产品实例
 *
 *  @return <#return value description#>
 */
-(UIViewController *)createControllerInstance{
    
//        UIViewController * life = [[XWJLifeViewController alloc] init];
//    UIStoryboard * lifeS = [UIStoryboard storyboardWithName:@"LifeStoryboard" bundle:nil];
//    UIViewController *life = [lifeS instantiateInitialViewController];

//    UIStoryboard * lifeS = [UIStoryboard storyboardWithName:@"XWJShangchengStoryboard" bundle:nil];
//    UIViewController *life = [lifeS instantiateInitialViewController];
    XWJSHuoViewController *life = [[XWJSHuoViewController alloc] init];
    return life;
}

/**
 *  生产底部Tab产品实例
 *
 *  @return <#return value description#>
 */
-(UITabBarItem *)createTab{
    
    UITabBarItem * tabItem = [[XWJTabBarItem alloc] init];
    tabItem.title = @"生活";
    

     if (IOS8) {
     tabItem.image = [[UIImage imageNamed:@"tarbarimg3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     tabItem.selectedImage = [[UIImage imageNamed:@"tarbarimg3high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     }else{
     [tabItem setFinishedSelectedImage:[UIImage imageNamed:@"tarbarimg3"] withFinishedUnselectedImage:[UIImage imageNamed:@"tarbarimg3high"]];
     }

    return tabItem;
}
@end
