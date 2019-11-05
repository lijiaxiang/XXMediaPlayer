//
//  NSDate+Common.m
//  HLMagic
//
//  Created by marujun on 14-1-26.
//  Copyright (c) 2014年 chen ying. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

//获取天数索引
- (int)dayIndexSince1970
{
//    NSDate *baseDate = [NSDate dateWithTimeIntervalSince1970:1];
//    return [self dayIndexSinceDate:baseDate];
    
    NSTimeInterval offset = [[NSTimeZone localTimeZone] secondsFromGMTForDate:self];
    NSTimeInterval interval = [[self dateByAddingTimeInterval:offset] timeIntervalSince1970];
    return (interval / (24 * 60 * 60));
}

- (int)dayIndexSinceNow
{
    return [self dayIndexSinceDate:[NSDate date]];
}

- (int)dayIndexSinceDate:(NSDate *)date
{
    int days = 0;
    @try {
        NSDate *baseBegin = [date dateAccurateToDay];
        NSDate *lastBegin = [self dateAccurateToDay];
        days = [lastBegin timeIntervalSinceDate:baseBegin]/(24*60*60);
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return days;
}

//获取字符串
- (NSString *)string
{
    return [self stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)yearMonthString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
 
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
    
    return [NSString stringWithFormat:@"%ld月 %ld年",(long)components.month,(long)components.year];
}

- (NSString *)monthDayString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [NSString stringWithFormat:@"%ld月%ld日",(long)components.month,(long)components.day];
}

- (NSString *)hourMinuteString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    return [NSString stringWithFormat:@"%ld:%02ld",(long)components.hour,(long)components.minute];
}

+ (NSString *)stringWithTimestamp:(int)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [date string];
}

//格式化日期 精确到天
- (NSDate *)dateAccurateToDay
{
    NSDate *current = nil;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        current = [calendar dateFromComponents:components];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return current;
}

//格式化日期 精确到小时
- (NSDate *)dateAccurateToHour
{
    NSDate *current = nil;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:self];
        components.minute = 0;
        components.second = 0;
        current = [calendar dateFromComponents:components];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return current;
}

- (NSDate *)dateAccurateToMonth
{
    NSDate *current = nil;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
        components.day = 1;
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        current = [calendar dateFromComponents:components];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return current;
}

//剩余时间
+ (NSString *)leftHourMinWithTimestamp:(int)timestamp
{
    int now = [[NSDate date] timeIntervalSince1970];
    int interval = abs(timestamp - now);
    int hour = interval / 3600;
    int min = (interval % 3600) / 60;
    return [NSString stringWithFormat:@"%d时%d分", hour, min];
}

+ (NSString *)leftHourMinSecWithSeconds:(int)seconds
{
    int hour = seconds / 3600;
    int min = (seconds % 3600) / 60;
    int sec = seconds % 60;
    if (hour > 0)
    {
        return [NSString stringWithFormat:@"%d:%02d:%02d", hour, min, sec];
    }
    else
    {
        return [NSString stringWithFormat:@"%02d:%02d", min, sec];
    }
}

//判断2个日期是否在同一天
- (BOOL)isSameDayWithDate:(NSDate *)date
{
    if (date == nil)
    {
        return NO;
    }
    
    BOOL isSame = NO;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSDateComponents *componentsA = [calendar components:unitFlags fromDate:date];
        NSDateComponents *componentsB = [calendar components:unitFlags fromDate:self];
        
        isSame = (componentsA.year == componentsB.year &&
                   componentsA.month == componentsB.month &&
                   componentsA.day == componentsB.day);
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return isSame;
}

////判断日期是否为当天
//- (BOOL)isToday
//{
//    return [self isSameDayWithDate:[NSDate date]];
//}

//忽略年月日
- (NSDate *)dateRemoveYMD
{
    NSDate *lastDate = nil;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
        [components setYear:2014];
        lastDate = [calendar dateFromComponents:components];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return lastDate;
}

//加上时区偏移
- (NSDate *)changeZone
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    return [self  dateByAddingTimeInterval: interval];
}

//转化成中国时间
- (NSDate *)convertToChineseDate
{
    NSInteger seconds = [NSTimeZone localTimeZone].secondsFromGMT;
    NSDate *date = [self dateByAddingTimeInterval:28800 - seconds];
    return date;
}

//毫秒数
- (NSTimeInterval)millisecondSince1970
{
    return [self timeIntervalSince1970] * 1000;
}

+ (NSDate *)dateByMillisecondSince1970:(NSTimeInterval)millisecond
{
    return [NSDate dateWithTimeIntervalSince1970:millisecond / 1000];
}

//是否有效
- (BOOL)isValid
{
    if ([self isEqualToDate:[NSDate distantPast]])
    {
        return NO;
    }
    
    if ([self isEqualToDate:[NSDate distantFuture]])
    {
        return NO;
    }
    
    if ([self timeIntervalSince1970] <= 0)
    {
        return NO;
    }
    
    return YES;
}

///获取当前时间戳
+ (NSNumber *)getTimestamp
{
    NSTimeInterval date = [[NSDate date] timeIntervalSince1970];
    NSNumber *dateNumber = [NSNumber numberWithLong:date];
    return dateNumber;
}

@end

@implementation NSString (DateCommon)

- (NSDate *)date
{
    return [self dateWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSDate *)dateWithDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}

@end
