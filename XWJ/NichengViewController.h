//
//  NichengViewController.h
//  XWJ
//
//  Created by 聚城科技 on 15/12/21.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface NichengViewController : XWJBaseViewController
//block传值
//1.发送方声明回调的block引用
@property (nonatomic, copy)void (^returnStrBlock)(NSString*);
@end
