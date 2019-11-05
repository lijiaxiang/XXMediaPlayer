//
//  DeviceInfo.h
//  ApplePai
//
//  Created by alice on 16/3/9.
//  Copyright © 2016年 miguopai. All rights reserved.
//

#import <Foundation/Foundation.h>


#define IS_IPHONE_4 [UHDeviceInfo isiPhone4_4s]
#define IS_IPHONE_5_5s_5c [UHDeviceInfo isiPhone5_5s_5c]


@interface UHDeviceInfo : NSObject

/// IDFA
+ (NSString *)deviceIDFA;

/// IDFA 是否开启广告跟踪 YES-未开启限制广告跟踪   NO-开启限制广告跟踪
+ (BOOL)deviceIDFATracking;

/// IDFV
+ (NSString *)deviceIDFV;

/// CFUUID
+ (NSString *)deviceCFUUID;

/// NSUUID
+ (NSString *)deviceNSUUID;

/// BundleID
+ (NSString *)deviceBundleID;

/// 检测是否有sim卡 name code 46001
+(NSDictionary *)checkSIMInfo;

/// 随机IDFA
+ (NSString *)deviceRandomIDFA;
/*
 * 获取设备物理地址
 */
+ (NSString *)deviceMAC;
/**
 获取设备ip
 
 @return 返回ipv4的ip
 */
+ (NSString *)deviceIPAdress;

///"iPhone1,1"
+ (NSString *) devicePlatform;

///@"iPhone 7"
+ (NSString *) devicePlatformName;

+ (BOOL)isiPhone4_4s;
+ (BOOL)isiPhone5;
+ (BOOL)isiPhone5_5s_5c;
+ (BOOL)isiPhone678;
+ (BOOL)isiPhone6p7p8p;
/**
 判断刘海屏是否是刘海屏
 
 @return 返回值YES/NO
 */
+ (BOOL)isNotch;

+ (BOOL)isSimulator;

/**
 手机磁盘剩余大小

 @return 可利用磁盘
 */
+ (CGFloat)diskFreeZize;

/**
 运营商
 
 @return dic
 */
+ (NSDictionary *)SIMInfo;

@end
