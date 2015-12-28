//
//  XWJPay3ViewController.h
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJPay3ViewController : XWJBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *payTableView;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@end
