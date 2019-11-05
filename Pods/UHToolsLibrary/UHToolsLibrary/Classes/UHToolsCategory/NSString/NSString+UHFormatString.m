//
//  NSString+UHFormatString.m
//  LGVideo
//
//  Created by Viper on 2018/11/9.
//  Copyright © 2018年 孙卫亮. All rights reserved.
//

#import "NSString+UHFormatString.h"

@implementation NSString (UHFormatString)

+ (NSString *)createString:(NSString *)str
{
    CGFloat number = [str floatValue];
    // <1W
    if (number < 10000)
    {
        return str;
    }
    
    NSString *resultStr = nil;
    // >1W && <10W
    if (number >= 10000 && number <100000)
    {
        number = number/10000.0;
        resultStr = [NSString stringWithFormat:@"%.1f万", number];
        // >=10W && <1E
    }
    else if (number >= 100000 && number < 100000000)
    {
        number = number/10000.0;
        resultStr = [NSString stringWithFormat:@"%.0f万", number];
        // >= 1E
    }
    else if (number >= 100000000 && number < 1000000000)
    {
        number = number/100000000.0;
        resultStr = [NSString stringWithFormat:@"%.1f亿", number];
    }
    else if (number >= 1000000000)
    {
        number = number/100000000.0;
        resultStr = [NSString stringWithFormat:@"%.0f亿", number];
    }
    
    return resultStr;
}

@end
