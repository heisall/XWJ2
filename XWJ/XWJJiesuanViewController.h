//
//  XWJJiesuanViewController.h
//  XWJ
//
//  Created by Sun on 15/12/27.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJJiesuanViewController : XWJBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *buyerLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *diquLabel;

@property (weak, nonatomic) IBOutlet UITableView *payTableView;
@property (weak, nonatomic) IBOutlet UITableView *shangpinTableView;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UITextView *liuyanTextView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property NSArray *arr;
@property NSString *price;
@property NSDictionary *selectDic;
@end
