//
//  UHImageTools.h
//  UHUGCSDK
//
//  Created by Viper on 2019/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UHImageTools : NSObject

/**
 获取相对路径下的source资源

 @param imageName 图片名称
 @param bundleName bundle名称
 @return 实例image
 */
+ (UIImage *)uh_imageWithImageName:(NSString *)imageName bundleName:(NSString *)bundleName;


/**
 方法过期，不建议使用! Use - [uh_imageWithImageName:bundleName:]
 */
+ (UIImage *)uh_imageWithImageName:(NSString *)imageName mainClass:(Class)mainClass bundleName:(NSString *)bundleName NS_DEPRECATED_IOS(2_0, 2_0, "方法过期，不建议使用! Use - [uh_imageWithImageName:bundleName:]");

@end

NS_ASSUME_NONNULL_END
