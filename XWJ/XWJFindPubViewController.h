//
//  XWJFindPubViewController.h
//  XWJ
//
//  Created by Sun on 15/12/4.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJFindPubViewController : XWJBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *titleTexField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property(nonatomic)NSMutableArray *dataSource;

@end
