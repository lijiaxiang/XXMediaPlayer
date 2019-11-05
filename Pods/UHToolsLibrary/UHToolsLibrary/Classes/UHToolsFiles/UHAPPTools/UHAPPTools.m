//
//  APPTools.m
//  SuperModel
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 yusen. All rights reserved.
//

#import "UHAPPTools.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <Accelerate/Accelerate.h>//毛玻璃效果需要用
#import <QuartzCore/QuartzCore.h>
#import <Photos/Photos.h>

@implementation UHAPPTools
 

#pragma mark---根据颜色 生成图片

+ (UIImage*)imageWithColorOneWidthHeight:(UIColor *)color
{
    return [self imageWithColor:color frame:CGRectMake(0.0f, 0.0f, 1.0f,1.0f)];
}

+ (UIImage*)imageWithColor:(UIColor *)color frame:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark--- /*手机号码验证 */
+ (BOOL)isMobileNumber:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9])|(14[0-9]))\\d{8}$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    return [phoneTest evaluateWithObject:mobile];
    NSString *pattern = @"^(1+[3456789])+\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:mobile];
    return isMatch;
}

#pragma mark--根据时间Date 计算 时间戳
+ (NSString *)getDateIntervalSince1970:(NSDate *)date
{
    return  [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}


#pragma mark--根据时间Date formart 计算字符串
+ (NSString *)getDateString:(NSDate *)date formart:(NSString *)formart
{//@"yyyy-MM-dd"
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter* formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateStyle:NSDateFormatterMediumStyle];
    [formatter3 setTimeStyle:NSDateFormatterShortStyle];
    [formatter3 setTimeZone:zone];
    [formatter3 setDateFormat:formart];//H -- 24小时制，显示为0--23
    
    return [formatter3 stringFromDate:date];
}


#pragma mark--根据时间戳 formart 计算字符串 @"YYYY-MM-dd HH:ss"
+ (NSString *)getDateStringWithShiJianChuo:(NSString *)timeChuo formart:(NSString *)formart
{
    NSDate *fromServerDate1=[NSDate dateWithTimeIntervalSince1970:[timeChuo integerValue]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:formart];
    
    return [formatter stringFromDate:fromServerDate1];
}

///根据高度 计算宽度
+ (CGSize)adaptiveWidthWithString:(NSString *)string font:(UIFont *)font fixedHeight:(CGFloat)height
{
    NSDictionary *arttibutes=@{NSFontAttributeName:font};
    return  [string boundingRectWithSize:CGSizeMake(MAXFLOAT,height) options:NSStringDrawingUsesLineFragmentOrigin attributes:arttibutes context:nil].size;
}


#pragma mark-- url转dic

+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd])
    {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2)
        {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

/** 获取url中的值
 (如：lazyrp://lazymelon.com/h5_detail?vid=123&jid=567)
 
 return: {vid: 123, jid: 567}
 */
+ (NSDictionary *)getURLPargramValue:(NSString *)queryString
{
    NSDictionary *value = nil;
    /** 判断一下是否含有"//" */
    if ([queryString containsString:@"//"])
    {
        NSArray *queryArray = [queryString componentsSeparatedByString:@"//"];
        NSString *lastString = [NSString stringWithFormat:@"%@", uh_arr_private_getValidObject(queryArray, 1)];
        if (lastString && [lastString isKindOfClass:[NSString class]] && lastString.length > 0)
        {
            NSArray *sArray = [lastString componentsSeparatedByString:@"?"];
            NSString *aftString = nil;
            if (sArray.count == 2)
            {
                aftString = [NSString stringWithFormat:@"%@", sArray[1]];
            }
            
            value = [UHAPPTools dictionaryFromQuery:aftString
                                    usingEncoding:NSUTF8StringEncoding];
        }
    }
    
    return value;
}

id uh_arr_private_getValidObject(NSArray *array, NSInteger index)
{
    if (uh_arr_private_valid(array) &&
        index < array.count)
    {
        return array[index];
    }
    
    return nil;
}

BOOL uh_arr_private_valid(id object)
{
    if (object != nil &&
        (NSNull *)object != [NSNull null] &&
        [object isKindOfClass:[NSArray class]])
    {
        return ((NSArray*)object).count > 0 ? YES : NO;
    }
    
    return NO;
}

@end

