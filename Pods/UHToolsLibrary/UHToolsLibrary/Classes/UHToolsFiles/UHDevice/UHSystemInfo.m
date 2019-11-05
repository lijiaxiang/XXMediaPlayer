//
//  SNSystemInfo.m
//  SNFoundation
//
//  Created by liukun on 14-3-3.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import "UHSystemInfo.h"

/// IP
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>

@implementation UHSystemInfo

+ (NSString *)osVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//获取系统当前时间
+ (NSString *)systemTimeInfo
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateString;
}

+ (NSString *)appVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@", version];
}

+ (NSString *)appBuildVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@", version];
}

+ (NSString *)appDisplayName
{
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return name;
}

+ (NSString *)appBundleIdentifier
{
    NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
    return name;
}

/// 获取ip 内网
+ (NSString *)getIPAddress
{
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return nil;
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0)
    {
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
        {
            ifr = (struct ifreq *)ptr;
            
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len)
            {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    
    NSString *deviceIP = @"";
    for (int i=0; i < ips.count; i++)
    {
        if (ips.count > 0)
        {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    
    return deviceIP;
}

 
/// 检测越狱
+ (NSInteger)isJailBreak
{
    // 权限
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"])
    {
        //        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/User/Applications/" error:nil];
        return 5;
    }
    
    // 破解文件
    const char* jailbreak_tool_pathes[] = {
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/etc/apt"
    };
    
    for (int i=0; i<(sizeof(jailbreak_tool_pathes)/sizeof(jailbreak_tool_pathes[0])); i++)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]])
        {
            return 6;
        }
    }
    
    return 10;
}

@end
