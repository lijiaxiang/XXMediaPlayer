//
//  UHAPPLog.m
//  DataRouter
//
//  Created by iOS-dev on 2017/7/11.
//  Copyright © 2017年 weiliang.sun. All rights reserved.
//

#import "UHAPPLog.h"

@implementation UHAPPLog

//#define UHAPPLog_Private_ALL(format, ...) printf("[DataRouter]: <%s:(%d行)> 方法: %s \n%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#define UHAPPLog_Private_Normal(...) printf("%s\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

static UHAPPLog *_instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UHAPPLog alloc] init];
        _instance.logLevel = UHAPPLogLevel_Off;
    });
    
    return _instance;
}

//不受开关控制的打印
- (void)logformat:(NSString *)format, ...
{
    if (format)
    {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        UHAPPLog_Private_Normal(@"%@", message);
    }
}

//ALL
- (void)logALLformat:(char *)file line:(int)line func:(NSString *)func fmt:format, ...
{
    if (_logLevel == UHAPPLogLevel_Off)
    {
        return;
    }
    
    if (format)
    {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        NSString *date = [self fixDate:[NSString stringWithFormat:@"%s",__DATE__]];
        const char * messageChar = (char *)[message UTF8String];
    
//        NSLog(@"%@ %s [weiliang]: <%@:(%d行)> 方法: %@ \n %@\n",date,__TIME__, [[NSString stringWithUTF8String:file] lastPathComponent], line, func,message);
        printf("\n%s %s [V8]: <%s:(%d行)> 方法: %s \n【内容：】 %s\n\n",[date UTF8String],__TIME__, [[[NSString stringWithUTF8String:file] lastPathComponent] UTF8String], line, [func UTF8String],messageChar);
    }
}

//Normal
- (void)logNormalformat:(NSString *)format, ...
{
    if (_logLevel == UHAPPLogLevel_Off)
    {
        return;
    }
    
    if (format)
    {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        UHAPPLog_Private_Normal(@"%@", message);
    }
}

//修复date
- (NSString *)fixDate:(NSString *)date
{
    NSArray *dataArr = [date componentsSeparatedByString:@" "];
    
    NSString *month =dataArr[0];
    NSInteger fixMonth = 0;
    
    if ([month isEqualToString:@"Jan"]) {
         fixMonth = 1;
    }else if ([month isEqualToString:@"Feb"]){
        fixMonth = 2;
    }else if ([month isEqualToString:@"Mar"]){
        fixMonth = 3;
    }else if ([month isEqualToString:@"Apr"]){
        fixMonth = 4;
    }else if ([month isEqualToString:@"May"]){
        fixMonth = 5;
    }else if ([month isEqualToString:@"Jun"]){
        fixMonth = 6;
    }else if ([month isEqualToString:@"Jul"]){
        fixMonth = 7;
    }else if ([month isEqualToString:@"Aug"]){
        fixMonth = 8;
    }else if ([month isEqualToString:@"Sep"]){
        fixMonth = 9;
    }else if ([month isEqualToString:@"Oct"]){
        fixMonth = 10;
    }else if ([month isEqualToString:@"Nov"]){
        fixMonth = 11;
    }else if ([month isEqualToString:@"Dec"]){
        fixMonth = 12;
    }
    
    NSString *result = [NSString stringWithFormat:@"%@-%.2ld-%.2ld",dataArr.lastObject,(long)fixMonth,[dataArr[2] integerValue]];
    
    return result;
}

///使用alert提示string
+ (void)alertLogString:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"alertLog" otherButtonTitles:nil, nil];
    [alert show];
}

@end
