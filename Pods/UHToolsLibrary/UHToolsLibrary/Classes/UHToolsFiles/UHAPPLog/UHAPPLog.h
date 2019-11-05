//
//  APPLog.h
//  DataRouter
//
//  Created by iOS-dev on 2017/7/11.
//  Copyright © 2017年 weiliang.sun. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, UHAPPLogLevel) {
    UHAPPLogLevel_All,
    UHAPPLogLevel_Normal,
    UHAPPLogLevel_Off,
};


#define UHAPPLog(format, ...)\
do {\
[[UHAPPLog sharedInstance] logALLformat:__FILE__ line:__LINE__ func:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__] fmt:format,##__VA_ARGS__];\
} while(0)

#define UHAPPLogNone(format, ...)  \
do {[[UHAPPLog sharedInstance] logNormalformat:format, ##__VA_ARGS__];} while(0)

#define UHAPPLogSys(format, ...)  \
do {[[UHAPPLog sharedInstance] logformat:format, ##__VA_ARGS__];} while(0)



@interface UHAPPLog : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) UHAPPLogLevel logLevel;

//不受开关控制的打印
- (void)logformat:(NSString *)format, ...;

//ALL
- (void)logALLformat:(char *)file line:(int)line func:(NSString *)func fmt:format, ...;

//Normal
- (void)logNormalformat:(NSString *)format, ...;

///使用alert提示string
+ (void)alertLogString:(NSString *)title message:(NSString *)message;

@end
