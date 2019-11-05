//
//  UIFont+Extend.m
//  Wifi
//
//  Created by muxi on 14/12/1.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "UIFont+Extend.h"

@implementation UIFont (Extend)


#pragma mark - 打印并显示所有字体

+ (void)showAllFonts
{
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames )
    {
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames )
        {
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
}


#pragma mark - 宋体

+ (UIFont *)songTypefaceFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"经典宋体简" size:size];
}


#pragma mark - 微软雅黑

+ (UIFont *)microsoftYaHeiFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MicrosoftYaHei" size:size];
}


#pragma mark - 微软雅黑：加粗字体

+ (UIFont *)boldMicrosoftYaHeiFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MicrosoftYaHei-Bold" size:size];
}


#pragma mark - DroidSansFallback

+ (UIFont *)customFontNamedDroidSansFallbackWithFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"DroidSansFallback" size:size];
}


#pragma mark - 以下项目中用到的字体

+ (UIFont *)defaultFontWithSize:(CGFloat )size
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
    {
        return [UIFont fontWithName:@"PingFang SC" size:size];
    }
    else
    {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)defaultRegularFontWithSize:(CGFloat )size
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
    {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }
    else
    {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)defaultMediumFontWithSize:(CGFloat )size
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
    {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }
    else
    {
        return [UIFont boldSystemFontOfSize:size];
    }
}

+ (UIFont *)defaultSemiboldFontWithSize:(CGFloat )size
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
    {
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }
    else
    {
        return [UIFont boldSystemFontOfSize:size];
    }
}

+ (UIFont *)SFProDisplayMediumFont:(CGFloat )size
{
    UIFont *font = [UIFont fontWithName:@"Avenir-Medium" size:size];
    if (font == nil)
    {
        return [UIFont systemFontOfSize:size];
    }
    else
    {
        return font;
    }
}

+ (UIFont *)SFProDisplayBookFont:(CGFloat )size
{
    UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:size];
    if (font == nil)
    {
        return [UIFont systemFontOfSize:size];
    }
    else
    {
        return font;
    }
}


/**
 自定义font
 
 @return 如果没有会返回默认字体
 */
+ (UIFont *)UHFontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if (font == nil)
    {
        return [UIFont systemFontOfSize:fontSize];
    }
    else
    {
        return font;
    }
}


@end
