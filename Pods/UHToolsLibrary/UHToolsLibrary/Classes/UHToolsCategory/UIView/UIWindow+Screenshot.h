//
//  UIWindow+Screenshot.h
//
//
//  Created by 孙卫亮 on 16/5/12.
//  Copyright © 2016年 孙卫亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Screenshot)

- (UIImage *)screenshot;
- (UIImage *)screenshotWithRect:(CGRect)rect;

@end
