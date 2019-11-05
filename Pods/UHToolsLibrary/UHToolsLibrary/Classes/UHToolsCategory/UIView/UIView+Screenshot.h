//
//  UIView+Screenshot.h
//
//
//  Created by 孙卫亮 on 16/5/12.
//  Copyright © 2016年 孙卫亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

/// view截图
- (UIImage *)screenshot;

/// view截图根据rect
- (UIImage *)screenshotWithRect:(CGRect)rect;

/// view截图根据rect scale屏幕比例
- (UIImage *)screenshotWithRect:(CGRect)rect scale:(CGFloat)scale;

@end
