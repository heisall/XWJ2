//
//  XWJTabViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJTabViewController.h"
#import "XWJHomeTabFactory.h"
#import "XWJButlerTabFactory.h"
#import "XWJFindTabFactory.h"
#import "XWJMindTabFactory.h"
#import "XWJLifeTabFactory.h"
#import "XWJHomeViewController.h"
#import "XWJButlerViewController.h"
#import "XWJLifeViewController.h"
#import "XWJFindViewController.h"
#import "XWJMineViewController.h"

@implementation XWJTabViewController

-(void)viewDidLoad{
    
    [self initSubTab];
    self.delegate = self;
    
}

-(void)initSubTab{
    
    self.tabArray = [NSMutableArray arrayWithCapacity:4];
    
    //首页
    XWJHomeTabFactory * homeTab = [[XWJHomeTabFactory alloc] init];
    UIViewController *homeViewController   = [homeTab createControllerInstance];
    UINavigationController      *homeNav            = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    homeNav.tabBarItem = [homeTab createTab];
    
    //管家
    XWJButlerTabFactory *butlerTab = [[XWJButlerTabFactory alloc]init];
    UIViewController *butler = [butlerTab createControllerInstance];
    UINavigationController *butlerNav = [[UINavigationController alloc] initWithRootViewController:butler];
    butlerNav.tabBarItem = [butlerTab createTab];
    
    //生活
    XWJLifeTabFactory *lifeTab = [[XWJLifeTabFactory alloc]init];
    UIViewController *lifeView = [lifeTab createControllerInstance];
    UINavigationController *lifeNav = [[UINavigationController alloc] initWithRootViewController:lifeView];
    lifeNav.tabBarItem = [lifeTab createTab];

    //发现
    XWJFindTabFactory *findTab = [[XWJFindTabFactory alloc]init];
    UIViewController *find = [findTab createControllerInstance];
    UINavigationController *findNav = [[UINavigationController alloc] initWithRootViewController:find];
    findNav.tabBarItem = [findTab createTab];
    
    //我的
    XWJMindTabFactory *mineTab = [[XWJMindTabFactory alloc]init];
    UIViewController *mine = [mineTab createControllerInstance];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mine];
    mineNav.tabBarItem = [mineTab createTab];
    
    [self.tabArray addObject:homeNav];
    [self.tabArray addObject:butlerNav];
    [self.tabArray addObject:lifeNav];
    [self.tabArray addObject:findNav];
    [self.tabArray addObject:mineNav];
    self.viewControllers = self.tabArray;
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
    self.tabBar.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
}
@end
