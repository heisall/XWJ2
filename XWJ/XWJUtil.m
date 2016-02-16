//
//  XWJUtil.m
//  XWJ
//
//  Created by Sun on 15/12/20.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJUtil.h"
#import "sys/utsname.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation XWJUtil
+(NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        CLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);  
    
    CLog(@"手机的IP是：%@", address);
    return address;  
}

+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 CDMA";
    
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]|| [platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,2"]|| [platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 plus";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1 Gen";
    
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2 Gen";
    
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3 Gen";
    
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4 Gen";
    
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5 Gen";
    
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 WiFi";
    
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 CDMA";
    
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini WiFi";
    
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini GSM+CDMA";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 WiFi";
    
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 GSM+CDMA";
    
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 WiFi";
    
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 GSM+CDMA";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    
    return @"iphone";
    
}
@end
