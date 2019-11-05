//
//  UIColor+SNFoundation.m
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import "UIColor+SNFoundation.h"
CGFloat uh_colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation UIColor (SNFoundation)

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSScanner *scanner = [NSScanner scannerWithString:cString];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)randomColor
{
    CGFloat red = arc4random_uniform(255)/255.0;
    CGFloat green = arc4random_uniform(255)/255.0;
    CGFloat blue = arc4random_uniform(255)/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (BOOL)isEqualToColor:(UIColor*)color
{
    if (CGColorEqualToColor(self.CGColor, color.CGColor))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// support #RGB #ARGB #RRGGBB #AARRGGBB
+ (UIColor *)uh_colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    colorString = [[colorString stringByReplacingOccurrencesOfString:@"0X" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = uh_colorComponentFrom(colorString, 0, 1);
            green = uh_colorComponentFrom(colorString, 1, 1);
            blue  = uh_colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = uh_colorComponentFrom(colorString, 0, 1);
            red   = uh_colorComponentFrom(colorString, 1, 1);
            green = uh_colorComponentFrom(colorString, 2, 1);
            blue  = uh_colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = uh_colorComponentFrom(colorString, 0, 2);
            green = uh_colorComponentFrom(colorString, 2, 2);
            blue  = uh_colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = uh_colorComponentFrom(colorString, 0, 2);
            red   = uh_colorComponentFrom(colorString, 2, 2);
            green = uh_colorComponentFrom(colorString, 4, 2);
            blue  = uh_colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
