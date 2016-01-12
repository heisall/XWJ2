//
//  XRQJpush.h
//  XWJ
//
//  Created by lingnet on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XRQJpush : NSObject

// 在应用启动的时候调用
+ (void)setupWithOptions:(NSDictionary *)launchOptions;

// 在appdelegate注册设备处调用
+ (void)registerDeviceToken:(NSData *)deviceToken;

// ios7以后，才有completion，否则传nil
+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;

// 显示本地通知在最前面
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification;

//设置别名
+ (void)setBieming:(NSString*)biemingStr;
@end
