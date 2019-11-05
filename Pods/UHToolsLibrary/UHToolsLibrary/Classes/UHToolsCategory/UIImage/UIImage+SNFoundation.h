//
//  UIImage+SNFoundation.h
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SNFoundation)

+ (UIImage *)noCacheImageNamed:(NSString *)imageName;

+ (UIImage *)streImageNamed:(NSString *)imageName;
+ (UIImage *)streImageNamed:(NSString *)imageName capX:(CGFloat)x capY:(CGFloat)y;

- (UIImage *)stretched;
- (UIImage *)grayscale;

- (UIColor *)patternColor;


+ (UIImage *)imageWithScrollView:(UIScrollView *)scrollView;
///使用颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
///使用颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
//UIView转换为UIImage
+ (UIImage *)imageWithView:(UIView *)view;
///扇形的遮罩图片
+ (UIImage *)imageWithMaskFrame:(CGRect)frame process:(float)process;
///将图片处理成圆形
+ (UIImage *)circleImage:(UIImage*)image;
///将图片处理成圆形
+ (UIImage *)circleImage:(UIImage*)image withParam:(CGFloat) inset;
//生成圆角图片
- (UIImage *)imageWithSize:(CGSize)size corner:(CGFloat)corner;
///将一个指定的图形放大或缩小为指定的size
- (UIImage *)scale:(CGFloat)scale;
///按比例缩放以适应一个size
- (UIImage *)fitSize:(CGSize)size;
///拉升图片到某个大小
- (UIImage *)aspectFillSize:(CGSize)size;
///从中间截取特定大小
- (UIImage *)cropSize:(CGSize)size;
///从中间裁取一个正方形
- (UIImage *)squareImage;
///将图片处理成圆形
- (UIImage *)circleImageWithInset:(CGFloat)inset;
///计算一个图片的平均颜色
- (UIColor *)averageColor;
///设备的分辨率倍数
+ (CGFloat)sysScale;

- (UIImage*)getSubImage:(CGRect)rect;


#pragma mark - 图片剪裁
#pragma mark --

///将图片压缩到最大20k进行显示 ,[UIImage scaleImage:image maxDataSize:1024 * 20];
+ (UIImage *)scaleImage:(UIImage *)image maxDataSize:(NSUInteger)dataSize ;

/**
 *  裁剪图片
 *  @param clipSize  实际需要剪裁的size，会自动根据scale放大
 */
- (UIImage *)clipSize:(CGSize)clipSize;


#pragma mark - 使用blend改变图片颜色
#pragma mark --

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

@end
