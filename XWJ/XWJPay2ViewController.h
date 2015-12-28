//
//  XWJPay2ViewController.h
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJPay2ViewController : XWJBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *listUnpayBtn;
@property (weak, nonatomic) IBOutlet UIButton *listAllBtn;
@property (weak, nonatomic) IBOutlet UIView *tableHeadView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@end
