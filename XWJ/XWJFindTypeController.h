//
//  XWJFindTypeController.h
//  XWJ
//
//  Created by Sun on 15/12/18.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJFindTypeController : XWJBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *array;
@end
