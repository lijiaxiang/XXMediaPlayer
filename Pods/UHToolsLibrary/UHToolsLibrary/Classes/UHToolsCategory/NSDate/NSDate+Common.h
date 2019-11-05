//
//  NSDate+Common.h
//  HLMagic
//
//  Created by marujun on 14-1-26.
//  Copyright (c) 2014年 chen ying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Common)

//获取天数索引
- (int)dayIndexSince1970;
- (int)dayIndexSinceNow;
- (int)dayIndexSinceDate:(NSDate *)date;

//获取字符串
- (NSString *)string;
- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)yearMonthString;
- (NSString *)monthDayString;
- (NSString *)hourMinuteString;
+ (NSString *)stringWithTimestamp:(int)timestamp;

//格式化日期 精确到天或小时
- (NSDate *)dateAccurateToDay;
- (NSDate *)dateAccurateToHour;
- (NSDate *)dateAccurateToMonth;

//剩余时间
+ (NSString *)leftHourMinWithTimestamp:(int)timestamp;
+ (NSString *)leftHourMinSecWithSeconds:(int)seconds;

//判断2个日期是否在同一天
- (BOOL)isSameDayWithDate:(NSDate *)date;
//- (BOOL)isToday;与其他category方法重复

//忽略年月日
- (NSDate *)dateRemoveYMD;

//加上时区偏移
- (NSDate *)changeZone;

//转化成中国时间
- (NSDate *)convertToChineseDate;

//是否有效
- (BOOL)isValid;

//毫秒数
- (NSTimeInterval)millisecondSince1970;
+ (NSDate *)dateByMillisecondSince1970:(NSTimeInterval)millisecond;

///获取当前时间戳
+ (NSNumber *)getTimestamp;

@end

@interface NSString (DateCommon)

//获取日期
- (NSDate *)date;
- (NSDate *)dateWithDateFormat:(NSString *)format;

@end
