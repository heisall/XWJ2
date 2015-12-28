//
//  XWJdef.h
//  XWJ
//
//  Created by Sun on 15/12/2.
//  Copyright © 2015年 Paul. All rights reserved.
//

#ifndef XWJdef_h
#define XWJdef_h
#import "XWJHeader.h"
#define iphone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size):NO)

#define iphone5Plus  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size)|| (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size))||CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size):NO)


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS8    IOS_VERSION >= 8.0 ? YES : NO
#define XWJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif /* XWJdef_h */
