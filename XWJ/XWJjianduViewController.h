//
//  XWJjianduViewController.h
//  XWJ
//
//  Created by Sun on 15/12/2.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWJBaseViewController.h"
#import "LCBannerView.h"
@interface XWJjianduViewController : XWJBaseViewController<LCBannerViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *tableCell;


@end
