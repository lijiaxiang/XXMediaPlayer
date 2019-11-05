//
//  DeviceInfo.m
//  ApplePai
//
//  Created by alice on 16/3/9.
//  Copyright © 2016年 miguopai. All rights reserved.
//

#import "UHDeviceInfo.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <resolv.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <netinet/ip.h>
#import <net/ethernet.h>
#include <sys/param.h>
#include <sys/mount.h>

#define MDNS_PORT       5353
#define QUERY_NAME      "_apple-mobdev2._tcp.local"
#define DUMMY_MAC_ADDR  @"02:00:00:00:00:00"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

typedef NS_ENUM(NSUInteger, DeviceInfoDeviceType) {
    DEVICEINFODEVICE_IPHONE1G,
    DEVICEINFODEVICE_IPHONE3G,
    DEVICEINFODEVICE_IPHONE3GS,
    DEVICEINFODEVICE_IPHONE4_GSM,
    DEVICEINFODEVICE_IPHONE4_GSMRevA,
    DEVICEINFODEVICE_IPHONE4_CDMA,
    DEVICEINFODEVICE_IPHONE4S,
    DEVICEINFODEVICE_IPHONE5_GSM,
    DEVICEINFODEVICE_IPHONE5_Global,
    DEVICEINFODEVICE_IPHONE5C_GSM,
    DEVICEINFODEVICE_IPHONE5C_Global,
    DEVICEINFODEVICE_IPHONE5S_GSM,
    DEVICEINFODEVICE_IPHONE5S_Global,
    DEVICEINFODEVICE_IPHONE6,
    DEVICEINFODEVICE_IPHONE6P,
    DEVICEINFODEVICE_IPHONE6S,
    DEVICEINFODEVICE_IPHONE6SP,
    DEVICEINFODEVICE_IPHONESE,
    DEVICEINFODEVICE_IPHONE7,
    DEVICEINFODEVICE_IPHONE7P,
    DEVICEINFODEVICE_IPHONE8,
    DEVICEINFODEVICE_IPHONE8P,
    DEVICEINFODEVICE_IPHONEX,
    DEVICEINFODEVICE_IPHONEXR,
    DEVICEINFODEVICE_IPHONEXS,
    DEVICEINFODEVICE_IPHONEXSMax,
    
};

@implementation UHDeviceInfo

/// IDFA
+ (NSString *)deviceIDFA
{
    if ([self deviceIDFATracking])
    {
        NSString *idfa = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] uppercaseString];
        
        return idfa;
    }
    else
    {
        return nil;
    }
}

/// IDFA 是否开启广告跟踪 YES-未开启限制广告跟踪   NO-开启限制广告跟踪
+ (BOOL)deviceIDFATracking
{
    return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
}

/// IDFV
+ (NSString *)deviceIDFV
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/// CFUUID
+ (NSString *)deviceCFUUID
{
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    return (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
}

/// NSUUID
+ (NSString *)deviceNSUUID
{
    return [[NSUUID UUID] UUIDString];
}

/// BundleID
+ (NSString *)deviceBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/// 检测是否有sim卡 name code 46001
+ (NSDictionary *)checkSIMInfo
{
    if ([UHDeviceInfo isSimulator])
    {
        NSDictionary *resultDic = @{@"name":@"Simulator",
                                    @"code":@"00"};
        return resultDic;
    }
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *carrierName = carrier.carrierName;
    NSString *mobileCountryCode = carrier.mobileCountryCode;
    NSString *mobileNetworkCode = carrier.mobileNetworkCode;
    
    if (!mobileNetworkCode)
    {
        /// "查询不到运营商"
//        UIStatusBar *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
//        NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
//        UIView *serviceView = nil;
//        Class serviceClass = NSClassFromString([NSString stringWithFormat:@"UIStat%@Serv%@%@", @"usBar", @"ice", @"ItemView"]);
//        for (UIView *subview in subviews) {
//            if([subview isKindOfClass:[serviceClass class]]) {
//                serviceView = subview;
//                break;
//            }
//        }
//        if (serviceView) {
//            NSString *carrierName2 = [serviceView valueForKey:[@"service" stringByAppendingString:@"String"]];
//            //            if ([carrierName2 hasPrefix:@"iPod"] || [carrierName2 hasPrefix:@"iPad"]) {
//            //                return nil;
//            //            }
//            NSDictionary *resultDic = @{@"name":carrierName2,
//                                        @"code":@""};
//            return resultDic;
//        } else {
//            NSDictionary *resultDic = @{@"name":@"",
//                                        @"code":@""};
//            return resultDic;
//            //            return nil;
//        }
        NSDictionary *resultDic = @{@"name":@"未知",
                                    @"code":@"00"};
        return resultDic;
        
    }
    else
    {
        NSDictionary *resultDic = @{@"name":carrierName,
                                    @"code":[NSString stringWithFormat:@"%@%@",mobileCountryCode,mobileNetworkCode]};
        return resultDic;
    }
}

/// 随机IDFA
+ (NSString *)deviceRandomIDFA
{
    NSString *deviceId = [[NSUUID UUID] UUIDString];
    return deviceId;
}

/*
 * 获取设备物理地址
 */
+ (nullable NSString *)deviceMAC
{
    return @"02:00:00:00:00:00";
}

/**
 获取设备ip

 @return 返回ipv4的ip
 */
+ (NSString *)deviceIPAdress
{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0)  // 0 表示获取成功
    {
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] ||
                [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"])
            {
                //如果是IPV4地址，直接转化
                if (temp_addr->ifa_addr->sa_family == AF_INET)
                {
                    // Get NSString from C String
                    address = [self formatIPV4Address:((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr];
                }
                
                //如果是IPV6地址
                else if (temp_addr->ifa_addr->sa_family == AF_INET6)
                {
                    address = [self formatIPV6Address:((struct sockaddr_in6 *)temp_addr->ifa_addr)->sin6_addr];
                    if (address && ![address isEqualToString:@""] && ![address.uppercaseString hasPrefix:@"FE80"])
                    {
                        break;
                    }
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    //以FE80开始的地址是单播地址
    if (address && ![address isEqualToString:@""] &&
        ![address.uppercaseString hasPrefix:@"FE80"])
    {
        return address;
        //iOS9 fe80::475:aaef:8a5e:1304  172.16.100.171
    }
    else
    {
        return @"127.0.0.1";
    }
}

+ (NSString *)formatIPV4Address:(struct in_addr)ipv4Addr
{
    NSString *address = nil;
    
    char dstStr[INET_ADDRSTRLEN];
    char srcStr[INET_ADDRSTRLEN];
    memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
    
    if (inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL)
    {
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

+ (NSString *)formatIPV6Address:(struct in6_addr)ipv6Addr
{
    NSString *address = nil;
    
    char dstStr[INET6_ADDRSTRLEN];
    char srcStr[INET6_ADDRSTRLEN];
    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
    if (inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL)
    {
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}


#pragma mark - 设备信息

+ (NSString *) devicePlatform
{
    static NSString *platform = nil;
    if (platform == nil)
    {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        platform = [NSString stringWithUTF8String:machine];
        free(machine);
    }
    
    return platform;
}

+ (NSString *) platformString
{
    NSString *modelIdentifier = [self devicePlatform];
    // iPhone http://theiphonewiki.com/wiki/IPhone
    
    if ([modelIdentifier isEqualToString:@"iPhone1,1"])     return @"iPhone 1G";
    if ([modelIdentifier isEqualToString:@"iPhone1,2"])     return @"iPhone 3G";
    if ([modelIdentifier isEqualToString:@"iPhone2,1"])     return @"iPhone 3GS";
    if ([modelIdentifier isEqualToString:@"iPhone3,1"])     return @"iPhone 4 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPhone3,2"])     return @"iPhone 4 (GSM Rev A)";
    if ([modelIdentifier isEqualToString:@"iPhone3,3"])     return @"iPhone 4 (CDMA)";
    if ([modelIdentifier isEqualToString:@"iPhone4,1"])     return @"iPhone 4S";
    if ([modelIdentifier isEqualToString:@"iPhone5,1"])     return @"iPhone 5 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPhone5,2"])     return @"iPhone 5 (Global)";
    if ([modelIdentifier isEqualToString:@"iPhone5,3"])     return @"iPhone 5c (GSM)";
    if ([modelIdentifier isEqualToString:@"iPhone5,4"])     return @"iPhone 5c (Global)";
    if ([modelIdentifier isEqualToString:@"iPhone6,1"])     return @"iPhone 5s (GSM)";
    if ([modelIdentifier isEqualToString:@"iPhone6,2"])     return @"iPhone 5s (Global)";
    if ([modelIdentifier isEqualToString:@"iPhone7,1"])     return @"iPhone 6 Plus";
    if ([modelIdentifier isEqualToString:@"iPhone7,2"])     return @"iPhone 6";
    if ([modelIdentifier isEqualToString:@"iPhone8,1"])     return @"iPhone 6s";
    if ([modelIdentifier isEqualToString:@"iPhone8,2"])     return @"iPhone 6s Plus";
    if ([modelIdentifier isEqualToString:@"iPhone8,4"])     return @"iPhone SE";
    if ([modelIdentifier isEqualToString:@"iPhone9,1"])     return @"iPhone 7";
    if ([modelIdentifier isEqualToString:@"iPhone9,3"])     return @"iPhone 7";
    if ([modelIdentifier isEqualToString:@"iPhone9,2"])     return @"iPhone 7 Plus";
    if ([modelIdentifier isEqualToString:@"iPhone9,4"])     return @"iPhone 7 Plus";
    if ([modelIdentifier isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([modelIdentifier isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([modelIdentifier isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([modelIdentifier isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([modelIdentifier isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([modelIdentifier isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([modelIdentifier isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([modelIdentifier isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([modelIdentifier isEqualToString:@"iPhone11,4"])    return @"iPhone XS Max";
    if ([modelIdentifier isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
    if ([modelIdentifier isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([modelIdentifier isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([modelIdentifier isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    
    
    // iPad http://theiphonewiki.com/wiki/IPad
    
    if ([modelIdentifier isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([modelIdentifier isEqualToString:@"iPad2,1"])      return @"iPad 2 (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([modelIdentifier isEqualToString:@"iPad2,4"])      return @"iPad 2 (Rev A)";
    if ([modelIdentifier isEqualToString:@"iPad3,1"])      return @"iPad 3 (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPad3,3"])      return @"iPad 3 (Global)";
    if ([modelIdentifier isEqualToString:@"iPad3,4"])      return @"iPad 4 (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPad3,6"])      return @"iPad 4 (Global)";
    
    if ([modelIdentifier isEqualToString:@"iPad4,1"])      return @"iPad Air (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([modelIdentifier isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    
    // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
    
    if ([modelIdentifier isEqualToString:@"iPad2,5"])      return @"iPad mini 1G (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad2,6"])      return @"iPad mini 1G (GSM)";
    if ([modelIdentifier isEqualToString:@"iPad2,7"])      return @"iPad mini 1G (Global)";
    if ([modelIdentifier isEqualToString:@"iPad4,4"])      return @"iPad mini 2G (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad4,5"])      return @"iPad mini 2G (Cellular)";
    if ([modelIdentifier isEqualToString:@"iPad4,6"])      return @"iPad mini 2G (Cellular)"; // TD-LTE model see https://support.apple.com/en-us/HT201471#iPad-mini2
    if ([modelIdentifier isEqualToString:@"iPad4,7"])      return @"iPad mini 3G (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad4,8"])      return @"iPad mini 3G (Cellular)";
    if ([modelIdentifier isEqualToString:@"iPad4,9"])      return @"iPad mini 3G (Cellular)";
    
    // iPad Pro https://www.theiphonewiki.com/wiki/IPad_Pro
    if ([modelIdentifier isEqualToString:@"iPad6,7"])      return @"iPad Pro 1G (Wi-Fi)"; // http://pdadb.net/index.php?m=specs&id=8960&c=apple_ipad_pro_wifi_a1584_128gb
    if ([modelIdentifier isEqualToString:@"iPad6,8"])      return @"iPad Pro 1G (Cellular)"; // http://pdadb.net/index.php?m=specs&id=8965&c=apple_ipad_pro_td-lte_a1652_32gb_apple_ipad_6,8
    
    if ([modelIdentifier isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 2nd gen Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9 2nd gen Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5 Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5 Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad7,5"]) return @"iPad 9.7 6th gen Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad7,6"]) return @"iPad 9.7 6th gen Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad7,11"]) return @"iPad 10.2 7th gen Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad7,12"]) return @"iPad 10.2 7th gen Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad8,1"]) return @"iPad Pro 11 Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad8,2"]) return @"iPad Pro 11 Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad8,3"]) return @"iPad Pro 11 Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad8,4"]) return @"iPad Pro 11 Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad8,5"]) return @"iPad Pro 12.9 3nd gen Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad8,6"]) return @"iPad Pro 12.9 3nd gen Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad8,7"]) return @"iPad Pro 12.9 3nd gen Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad8,8"]) return @"iPad Pro 12.9 3nd gen Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad11,1"]) return @"iPad mini 5 Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad11,2"]) return @"iPad mini 5 Wi-Fi + Cellular";
    if ([modelIdentifier isEqualToString:@"iPad11,3"]) return @"iPad Air 3rd gen Wi-Fi";
    if ([modelIdentifier isEqualToString:@"iPad11,4"]) return @"iPad Air 3rd gen Wi-Fi + Cellular";
    
    // iPod http://theiphonewiki.com/wiki/IPod
    
    if ([modelIdentifier isEqualToString:@"iPod1,1"])      return @"iPod touch 1G";
    if ([modelIdentifier isEqualToString:@"iPod2,1"])      return @"iPod touch 2G";
    if ([modelIdentifier isEqualToString:@"iPod3,1"])      return @"iPod touch 3G";
    if ([modelIdentifier isEqualToString:@"iPod4,1"])      return @"iPod touch 4G";
    if ([modelIdentifier isEqualToString:@"iPod5,1"])      return @"iPod touch 5G";
    if ([modelIdentifier isEqualToString:@"iPod7,1"])      return @"iPod touch 6G"; // as 6,1 was never released 7,1 is actually 6th generation
    if ([modelIdentifier isEqualToString:@"iPod9,1"])      return @"iPod Touch 7th gen";
    
    // Apple TV https://www.theiphonewiki.com/wiki/Apple_TV
    
    if ([modelIdentifier isEqualToString:@"AppleTV1,1"])      return @"Apple TV 1G";
    if ([modelIdentifier isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2G";
    if ([modelIdentifier isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3G";
    if ([modelIdentifier isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3G"; // small, incremental update over 3,1
    if ([modelIdentifier isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4G"; // as 4,1 was never released, 5,1 is actually 4th generation
    
    // Simulator
    if ([modelIdentifier hasSuffix:@"86"] || [modelIdentifier isEqual:@"x86_64"])
    {
        BOOL smallerScreen = ([[UIScreen mainScreen] bounds].size.width < 768.0);
        return (smallerScreen ? @"iPhone Simulator" : @"iPad Simulator");
    }
    
    return modelIdentifier;
}

+ (NSString *)devicePlatformName
{
    static NSString *name = nil;
    if (name == nil)
    {
        name = [self platformString];
    }
    
    return name;
}

+ (BOOL)isiPhone4_4s
{
    if ([UIScreen mainScreen].bounds.size.width == 320.0 && [UIScreen mainScreen].bounds.size.height == 480.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isiPhone5
{
    NSString *devicePlatform = [self devicePlatformName];
    if ([devicePlatform hasPrefix:@"iPhone 5 "])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isiPhone5_5s_5c
{
    if ([UIScreen mainScreen].bounds.size.width == 320.0 &&
        [UIScreen mainScreen].bounds.size.height == 568.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isiPhone678
{
    if ([UIScreen mainScreen].bounds.size.width == 375.0 &&
        [UIScreen mainScreen].bounds.size.height == 667.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isiPhone6p7p8p
{
    if ([UIScreen mainScreen].bounds.size.width == 414.0 &&
        [UIScreen mainScreen].bounds.size.height == 736.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isSimulator
{
    NSString *modelIdentifier = [self devicePlatform];
    if ([modelIdentifier hasSuffix:@"86"] ||
        [modelIdentifier isEqual:@"x86_64"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isNotch
{
//    需要在主线程，不然有警告
//    BOOL isNotch = NO;
//    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone)
//    {
//        return isNotch;
//    }
//
//    if (@available(iOS 11.0, *))
//    {
//        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
//        if (mainWindow.safeAreaInsets.bottom > 0.0)
//        {
//            isNotch = YES;
//        }
//    }
//    return isNotch;

    
    NSString *platformName = [self devicePlatformName];
    if ([platformName isEqualToString:@"iPhone X"])
    {
        return YES;
    }

    if ([platformName isEqualToString:@"iPhone XR"])
    {
        return YES;
    }

    if ([platformName isEqualToString:@"iPhone XS"])
    {
        return YES;
    }

    if ([platformName isEqualToString:@"iPhone XS Max"])
    {
        return YES;
    }

    if ([platformName isEqualToString:@"iPhone 11"])
    {
        return YES;
    }
    if ([platformName isEqualToString:@"iPhone 11 Pro"])
    {
        return YES;
    }
    if ([platformName isEqualToString:@"iPhone 11 Pro Max"])
    {
        return YES;
    }

    return NO;
    
}

+ (CGFloat)diskFreeZize{
    /// 总大小
    float totalsize = 0.0;
    /// 剩余大小
    float freesize = 0.0;
    /// 是否登录
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0/(1024);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue]*1.0/(1024);
    } else  {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return freesize/1024/1024;
}

static NSDictionary *SIMInfoDic = nil;
+ (NSDictionary *)SIMInfo {
    if (!SIMInfoDic) {
        SIMInfoDic = [UHDeviceInfo checkSIMInfo];
        return SIMInfoDic;
    }else {
        return SIMInfoDic;
    }
    
}

@end
