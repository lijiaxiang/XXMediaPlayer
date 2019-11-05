//
//  UHImageTools.m
//  UHUGCSDK
//
//  Created by Viper on 2019/4/12.
//

#import "UHImageTools.h"

@implementation UHImageTools

+ (UIImage *)uh_imageWithImageName:(NSString *)imageName bundleName:(NSString *)bundleName
{
    UIImage *img;
    
    ///1、找当前bundle
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle",bundleName]];
    NSBundle *imageBundle = [NSBundle bundleWithPath:bundlePath];
    
    ///2、找最合适的scale图片
    NSString *imgName = [self uh_fullScaleNameForImageName:imageName];
    NSString *path = [imageBundle pathForResource:imgName ofType:@"png"];
    img = [UIImage imageWithContentsOfFile:path];
    
    ///3、nil 则找次级scale图片
    if (!img)
    {
        imgName = [self uh_forImageChangeScale:imgName];
        NSString *path = [imageBundle pathForResource:imgName ofType:@"png"];
        img = [UIImage imageWithContentsOfFile:path];
    }
    
    ///4、nil 则找1倍图
    if (!img)
    {
        imgName = [self uh_forImageWhenScaleDismiss:imgName];
        NSString *path = [imageBundle pathForResource:imgName ofType:@"png"];
        img = [UIImage imageWithContentsOfFile:path];
    }
    
    return img;
}

+ (UIImage *)uh_imageWithImageName:(NSString *)imageName mainClass:(Class)mainClass bundleName:(NSString *)bundleName
{
    return  [self uh_imageWithImageName:imageName bundleName:bundleName];
}

#pragma mark - —————————————————— 私有方法 ———————————————————

///找最合适的倍图名称
+ (NSString *)uh_fullScaleNameForImageName:(NSString *)imageName
{
    //根据屏幕scale得到后缀
    NSString *suffix = [UIScreen mainScreen].scale > 2 ? @"@3x" : @"@2x";
    imageName = [imageName stringByAppendingString:suffix];
    return imageName;
}

///找次级合适倍图名称
+ (NSString *)uh_forImageChangeScale:(NSString *)oriName
{
    NSString *adatpName = @"";
    //2x替换为3x
    if ([oriName containsString:@"2x"])
    {
        adatpName = [oriName stringByReplacingOccurrencesOfString:@"@2x" withString:@"@3x"];
    }
    //3x替换为2x
    if ([oriName containsString:@"3x"])
    {
        adatpName = [oriName stringByReplacingOccurrencesOfString:@"@3x" withString:@"@2x"];
    }
    return adatpName;
}

///替换1倍图名称
+ (NSString *)uh_forImageWhenScaleDismiss:(NSString *)oriName
{
    NSString *adatpName = @"";
    //2x替换为3x
    if ([oriName containsString:@"2x"])
    {
        adatpName = [oriName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    }
    //3x替换为2x
    if ([oriName containsString:@"3x"])
    {
        adatpName = [oriName stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
    }
    return adatpName;
}

@end
