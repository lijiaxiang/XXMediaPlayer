//
//  UIColor+SNFoundation.h
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import <UIKit/UIKit.h>

//颜色创建
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#undef  RANDOMCOLOR
#define RANDOMCOLOR RGBACOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//16进制颜色值，如：#000000 , 注意：在使用的时候hexValue写成：0x000000
#undef	HexColor_Value
#define HexColor_Value(hexValue)		[UIColor colorWithRGBHex:hexValue]

#undef HexColor_String
#define HexColor_String(hexString)      [UIColor colorWithHexString:hexString]


#define UIImageScale [UIImage sysScale]

@interface UIColor (SNFoundation)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

// only support #RRGGBB
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert DEPRECATED_MSG_ATTRIBUTE("deprecated, please use uh_colorWithHexString");

// support #RGB #ARGB #RRGGBB #AARRGGBB
+ (UIColor *)uh_colorWithHexString:(NSString *)hexString;

+ (UIColor *)randomColor;

- (BOOL)isEqualToColor:(UIColor*)color;

@end
