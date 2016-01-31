//
//  AppDelegate.m
//  信我家
//
//  Created by Paul on 9/11/15.
//  Copyright (c) 2015年 Paul. All rights reserved.
//

#import "AppDelegate.h"
#import "XWJdef.h"
#import "AFNetworking.h"
#import "XWJAccount.h"
#import "XWJTabViewController.h"
#import "XWJSplashController.h"
#import "XWJJiesuanViewController.h"
////腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//
////微信SDK头文件
//#import "WXApi.h

#import <SMS_SDK/SMSSDK.h>
#import "XWJCity.h"

//极光推送
#import "XRQJpush.h"
//友盟分享
#import "UMSocial.h"
//微信分享
#import "UMSocialWechatHandler.h"
//通知提示  主要是为了程序在前端的时候的提示
#import "JKNotifier.h"
//微信支付
#import "WXApi.h"

#define mobAppKey @"c647ba762dc0"
#define mobAppSecret @"76e6d7422f5d958e9a882675d0ffbd29"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    /*
     加推送
     */
    [XRQJpush setupWithOptions:launchOptions];
    /*
     加分享
     */
    [UMSocialData setAppKey:@"56938a23e0f55aac1d001cb6"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx706df433748af20c" appSecret:@"f78e80ec755ab99be5a7b1e3565b5f37" url:@""];
    
    //微信支付  向微信注册
    [WXApi registerApp:@"wx706df433748af20c" withDescription:@"demo 2.0"];
    
    [SMSSDK registerApp:mobAppKey withSecret:mobAppSecret];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    //    [ShareSDK registerApp:@"iosv1101"
    //
    //          activePlatforms:@[
    //                            @(SSDKPlatformTypeSinaWeibo),
    //                            @(SSDKPlatformTypeMail),
    //                            @(SSDKPlatformTypeSMS),
    //                            @(SSDKPlatformTypeCopy),
    //                            @(SSDKPlatformTypeWechat),
    //                            @(SSDKPlatformTypeQQ),
    //                            @(SSDKPlatformTypeRenren),
    //                            @(SSDKPlatformTypeGooglePlus)]
    //                 onImport:^(SSDKPlatformType platformType)
    //     {
    //         switch (platformType)
    //         {
    //             case SSDKPlatformTypeWechat:
    //                 [ShareSDKConnector connectWeChat:[WXApi class]];
    //                 break;
    //             case SSDKPlatformTypeQQ:
    //                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
    //                 break;
    //             case SSDKPlatformTypeSinaWeibo:
    //                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
    //                 break;
    //             case SSDKPlatformTypeRenren:
    //                 [ShareSDKConnector connectRenren:[RennClient class]];
    //                 break;
    //             case SSDKPlatformTypeGooglePlus:
    //                 [ShareSDKConnector connectGooglePlus:[GPPSignIn class]
    //                                           shareClass:[GPPShare class]];
    //                 break;
    //             default:
    //                 break;
    //         }
    //     }
    //          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
    //     {
    //
    //         switch (platformType)
    //         {
    //             case SSDKPlatformTypeSinaWeibo:
    //                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
    //                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
    //                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
    //                                         redirectUri:@"http://www.sharesdk.cn"
    //                                            authType:SSDKAuthTypeBoth];
    //                 break;
    //             case SSDKPlatformTypeWechat:
    //                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
    //                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
    //                 break;
    //             case SSDKPlatformTypeQQ:
    //                 [appInfo SSDKSetupQQByAppId:@"100371282"
    //                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
    //                                    authType:SSDKAuthTypeBoth];
    //                 break;
    //             case SSDKPlatformTypeRenren:
    //                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
    //                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
    //                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
    //                                               authType:SSDKAuthTypeBoth];
    //                 break;
    //             case SSDKPlatformTypeGooglePlus:
    //                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
    //                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
    //                                            redirectUri:@"http://localhost"
    //                                               authType:SSDKAuthTypeBoth];
    //                 break;
    //             default:
    //                 break;
    //         }
    //     }];
    
    //    __strong NSMutableArray *arr = [NSMutableArray array];
    
    //    [self getCity];
    //
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSString *uname = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    BOOL islaunched = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLaunched"];

//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
//    self.window.rootViewController = [story instantiateViewControllerWithIdentifier:@"bindhouse2"];
    
//    XWJJiesuanViewController *con = [[UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"jiesuanview"];
//    UIViewController * je = [[XWJJiesuanViewController alloc] init];
//    self.window.rootViewController =con;
//    return NO;
    if (!islaunched) {
        XWJSplashController *view = [[XWJSplashController alloc] init];
        self.window.rootViewController = view;
    }else{
        if (uname&&pass) {
            [self loginUname:uname Pwd:pass];
        }else{
            [self toLoginController];
        }
    }
    //    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
    //    self.window.rootViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"bindhouse2"];
    
    return YES;
}

-(void)loginUname:(NSString *)username Pwd:(NSString *)pwd{
    if (username.length>0&&pwd.length>0) {
        
        //        NSString *url = @"http://www.hisenseplus.com:8100/appPhone/rest/user/userLogin";
        NSString *url = LOGIN_URL;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:username forKey:@"account"];
        [dict setValue:pwd forKey:@"password"];
        
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSNumber * result = [dic valueForKey:@"result"];
            if ([result intValue]== 1) {
                
                NSDictionary *userDic = [[dic objectForKey:@"data"] objectForKey:@"user"];
                NSString *sid = [userDic valueForKey:@"id"];
                [XWJAccount instance].uid = sid;
                [XWJAccount instance].account = [userDic valueForKey:@"Account"];
                [XWJAccount instance].password = pwd;
                [XWJAccount instance].NickName =[userDic valueForKey:@"NickName"];
                [XWJAccount instance].name = [userDic valueForKey:@"NAME"];
                [XWJAccount instance].Sex = [userDic valueForKey:@"sex"];
                [XWJAccount instance].phone = [userDic valueForKey:@"TEL"];
                [XWJAccount instance].jifen = [NSString stringWithFormat:@"%@",[userDic valueForKey:@"jifen"]];
                [XWJAccount instance].headPhoto = [NSString stringWithFormat:@"%@",[userDic valueForKey:@"Photo"]];
                //设置别名
                NSLog(@"------%@",[XWJAccount instance].uid);
                [XRQJpush setBieming:[XWJAccount instance].uid];
                /*
                 "A_id" = 4;
                 "A_name" = "\U9ea6\U5c9b\U91d1\U5cb8";
                 isDefault = 1;
                 */
                [XWJAccount instance].array = [[dic objectForKey:@"data"] valueForKey:@"area"];
                if ([XWJAccount instance].array&&[XWJAccount instance].array.count>0) {
                    for (NSDictionary *di in [XWJAccount instance].array ) {
                        if ([[di valueForKey:@"isDefault" ] integerValue]== 1) {
                            [XWJAccount instance].aid = [NSString stringWithFormat:@"%@",[di valueForKey:@"A_id"]];
                            
                        }
                    }
                }
                
                BOOL isBind = [XWJAccount instance].aid?TRUE:FALSE;
                if (!isBind) {
                    
                    UIStoryboard * login = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
                    UIViewController *view =[login instantiateViewControllerWithIdentifier:@"xuanzefangshi"];
                    
                    UINavigationController *nav = [[UINavigationController alloc] init];
                    [nav showViewController:view sender:nil];
                    self.window.rootViewController = nav;
                    
                    //                    XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
                    //                    bind.title = @"城市选择";
                    //                    bind.delegate = self;
                    //                    bind->mode = HouseCity;
                    //                    [self.navigationController showViewController:bind sender:nil];
                }else{
                    XWJTabViewController *tab = [[XWJTabViewController alloc] init];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    window.rootViewController = tab;
                }
            }else{
                [self toLoginController];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"log fail ");
            //        dispatch_async(dispatch_get_main_queue(), ^{
            //            XWJTabViewController *tab = [[XWJTabViewController alloc] init];
            //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //            window.rootViewController = tab;            //        });
            
            [self toLoginController];
            
        }];
    }
    
    /*
     XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
     bind.title = @"城市选择";
     bind.dataSource = [NSArray arrayWithObjects:@"青岛市",@"济南市",@"威海市", nil];
     bind.delegate = self;
     bind->mode = HouseCity;
     [self.navigationController showViewController:bind sender:nil];
     */
}

-(void)toLoginController{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
    self.window.rootViewController = [loginStoryboard instantiateInitialViewController];
    
}

-(void)getCity{
    
    NSString *url = GETCITY_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSArray *arr  = [dic objectForKey:@"data"];
            for (NSDictionary *d in arr) {
                NSLog(@"dic %@",d);
            }
            
            
            NSLog(@"dic %@",dic);
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail ",__FUNCTION__);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}

-(BOOL)checkAutoLogin{
    
    return FALSE;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [XRQJpush registerDeviceToken:deviceToken];
    return;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [XRQJpush handleRemoteNotification:userInfo completion:nil];
    return;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
// ios7.0以后才有此功能
- (void)application:(UIApplication *)application didReceiveRemoteNotification
                   :(NSDictionary *)userInfo fetchCompletionHandler
                   :(void (^)(UIBackgroundFetchResult))completionHandler {
    [XRQJpush handleRemoteNotification:userInfo completion:completionHandler];
    
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"-------%@",userInfo);
        
        [JKNotifier showNotifer:[NSString stringWithFormat:@"亲,您中了一千万！！！！!"]];
        
        [JKNotifier handleClickAction:^(NSString *name,NSString *detail, JKNotifier *notifier) {
            [notifier dismiss];
            NSLog(@"点击可在这里边处理一些事情");
            
            
//            self.tabBarController.selectedIndex = 2;
        }];
    }
    return;
}
#endif

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [XRQJpush showLocalNotificationAtFront:notification];
    if (application.applicationState == UIApplicationStateActive) {
        [JKNotifier showNotifer:notification.alertBody];
        
    }
    return;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        result =  [WXApi handleOpenURL:url delegate:self];

    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)confirmOrder:(NSString *)status :(NSString *)orderId{
    
    NSString *url = GETORDERCONFIRM_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:orderId forKey:@"orderId"];
    [dict setValue:status forKey:@"status"];
    
    //    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_id"];
    
    //    [dict setValue:@"1" forKey:@"a_id"];
    //    [dict setValue:[XWJAccount instance].uid forKey:@"userid"];
    /*
     pageindex	第几页	String,从0开始
     countperpage	每页条数	String
     cateId	商户分类	String
     */
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dict);
            NSString *res = [ NSString stringWithFormat:@"%@",[dict objectForKey:@"result"]];
            //            self.orderArr = [dict objectForKey:@"orders"];
            if ([res isEqualToString:@"1"]) {
                //当delegate中  支付回调成功了  然后调修改订单状态接口   当修改订单状态成功了  那就发通知去修改之前支付地方的数据源（删除）  如果是订单列表那就删掉当前数据源并且代付款数量-1  代收货数量+1
                NSLog(@"订单状态修改");
                NSString *orderid  =[[NSUserDefaults standardUserDefaults] valueForKey:@"orderid"];
                NSString *payindex  =[[NSUserDefaults standardUserDefaults] valueForKey:@"payorderindex"];
                //添加 字典，将label的值通过key值设置传递
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:orderid,@"paySuccess",payindex,@"payorderindex", nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"paySuccess" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        
        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
        
        NSString *strMsg;
        
        switch (resp.errCode) {
            case 0:{
                NSString *orderid  =[[NSUserDefaults standardUserDefaults] valueForKey:@"orderid"];
                NSLog(@"=====%@",orderid);
                [self confirmOrder:@"30" :orderid];
            }
                break;
            default:
                strMsg = @"未支付";
                break;
        }
    }
}
@end
