//
//  XWJMyInfoViewController.h
//  XWJ
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJMyInfoViewController : XWJBaseViewController<UITableViewDelegate,UITableViewDataSource>{
    CGFloat tableViewCellHeight;
}
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property(nonatomic)UITableView  *tableView;
@property (nonatomic)NSArray *tableData;
@property (nonatomic)NSMutableArray *tableDetailData;
@property (nonatomic,strong) void(^sendNickName)(NSString *);
@property (nonatomic,strong) void(^sendImageStr)(NSString *);



@end
