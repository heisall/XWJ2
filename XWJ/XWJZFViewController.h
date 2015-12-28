//
//  XWJZFViewController.h
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"


typedef enum : NSUInteger {
    HOUSENEW,
    HOUSE2,
    HOUSEZU
} HOUSETYPE ;

@interface XWJZFViewController : XWJBaseViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property HOUSETYPE type;
@end
