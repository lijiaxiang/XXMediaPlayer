//
//  UIFont+Extend.h
//  Wifi
//
//  Created by muxi on 14/12/1.
//  Copyright (c) 2014年 muxi. All rights reserved.
//  字体扩展
//
//  注：本类的主要目的是为了引入常用的web字体

#import <UIKit/UIKit.h>

#define KDefaultFont(_fontsize) [UIFont defaultFontWithSize:_fontsize]
#define KDefaultRegularFont(_fontsize) [UIFont defaultRegularFontWithSize:_fontsize]
#define KDefaultMediumFont(_fontsize) [UIFont defaultMediumFontWithSize:_fontsize]
#define KDefaultSemiboldFont(_fontsize) [UIFont defaultSemiboldFontWithSize:_fontsize]

@interface UIFont (Extend)

/**
 *  打印并显示所有字体
 */
+ (void)showAllFonts;

/**
 *  宋体(字体缺失)
 */
+ (UIFont *)songTypefaceFontOfSize:(CGFloat)size;

/**
 *  微软雅黑：正常字体
 */
+ (UIFont *)microsoftYaHeiFontOfSize:(CGFloat)size;

/**
 *  微软雅黑：加粗字体(字体缺失)
 */
+ (UIFont *)boldMicrosoftYaHeiFontOfSize:(CGFloat)size;

/**
 *  DroidSansFallback
 */
+ (UIFont *)customFontNamedDroidSansFallbackWithFontOfSize:(CGFloat)size;

/**
 * 以下是项目中用到的字体
 */
+ (UIFont *)defaultFontWithSize:(CGFloat)size;

+ (UIFont *)defaultRegularFontWithSize:(CGFloat )size;

+ (UIFont *)defaultMediumFontWithSize:(CGFloat )size;
+ (UIFont *)defaultSemiboldFontWithSize:(CGFloat )size;
+ (UIFont *)SFProDisplayMediumFont:(CGFloat )size;
+ (UIFont *)SFProDisplayBookFont:(CGFloat )size;

/**
 自定义font
 
 @return 如果没有会返回默认字体
 */
+ (UIFont *)UHFontWithName:(NSString *)fontName size:(CGFloat)fontSize;


@end
