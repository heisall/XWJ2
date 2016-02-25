//
//  XWJNoticeViewController.h
//  XWJ
//
//  Created by Sun on 15/12/5.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"
#define KEY_AD_TITLE @"Title"
#define KEY_AD_TIME  @"AddTime"
#define KEY_AD_CONTENT @"Description"
#define KEY_AD_CLICKCOUNT @"ClickCount"
#define KEY_AD_URL @"Content"
#define KEY_AD_ID  @"id"

@interface XWJNoticeViewController : XWJBaseViewController
@property(nonatomic)NSMutableArray *array;
@property NSString *type;
@end
