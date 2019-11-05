//
//  SNSystemInfo.h
//  SNFoundation
//
//  Created by liukun on 14-3-3.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD             ([[UIDevice currentDevice].model isEqualToString:@"iPad"])
#define IS_IPHONE           ([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
 

///获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

 
@interface UHSystemInfo : NSObject

/*系统版本*/
+ (NSString *)osVersion;

/*系统当前时间 格式：yyyy-MM-dd HH:mm:ss*/
+ (NSString *)systemTimeInfo;

/*软件版本*/
+ (NSString *)appVersion;

/*软件Build版本*/
+ (NSString *)appBuildVersion;

///获取app name
+ (NSString *)appDisplayName;

///
+ (NSString *)appBundleIdentifier;

/// 获取ip 内网
+ (NSString *)getIPAddress;
 
/**
 检测越狱

 @return 10为未越狱，其他均为越狱
 */
+ (NSInteger)isJailBreak;

@end
