//
//  XWJCarViewController.h
//  XWJ
//
//  Created by Sun on 15/12/27.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJCarViewController : XWJBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
