//
//  XWJButlerViewController.h
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"
#import "LCBannerView.h"
#import "XWJBindHouseTableViewController.h"
#import "XWJMyHouseController.h"
@interface XWJButlerViewController : XWJBaseViewController<XWJBindHouseDelegate,LCBannerViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UILabel *room;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property NSMutableArray *notices;
@property NSMutableArray *shows ;
@property NSDictionary *roomDic;
@property NSArray *vConlers;
@property NSArray *titles;

@end
