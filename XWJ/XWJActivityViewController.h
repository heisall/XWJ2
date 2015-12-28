//
//  XWJActivityViewController.h
//  XWJ
//
//  Created by Sun on 15/12/5.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJActivityViewController : XWJBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *actTitle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property   UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property NSString *type;
@property NSDictionary *dic;
@end
