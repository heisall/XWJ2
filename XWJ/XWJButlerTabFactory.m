//
//  XWJButlerTabFactory.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJButlerTabFactory.h"
#import "XWJButlerViewController.h"
#import "XWJTabBarItem.h"

@implementation XWJButlerTabFactory

/**
 *  生产controller产品实例
 *
 *  @return <#return value description#>
 */
-(UIViewController *)createControllerInstance{
//    UIViewController * butler = [[XWJButlerViewController alloc] init];
    
//        UIViewController * butler = [[XWJButlerViewController alloc] init];
    UIStoryboard * s = [UIStoryboard storyboardWithName:@"XWJGJStoryboard" bundle:nil];
    UIViewController * butler = [s instantiateInitialViewController];
    return butler;
}

/**
 *  生产底部Tab产品实例
 *
 *  @return <#return value description#>
 */
-(UITabBarItem *)createTab{
    
    UITabBarItem * tabItem = [[XWJTabBarItem alloc] init];
    tabItem.title = @"管家";
    

     if (IOS8) {
     tabItem.image = [[UIImage imageNamed:@"tarbarimg2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     tabItem.selectedImage = [[UIImage imageNamed:@"tarbarimg2high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     }else{
     [tabItem setFinishedSelectedImage:[UIImage imageNamed:@"tarbarimg2"] withFinishedUnselectedImage:[UIImage imageNamed:@"tarbarimg2high"]];
     }

    return tabItem;
}
@end
