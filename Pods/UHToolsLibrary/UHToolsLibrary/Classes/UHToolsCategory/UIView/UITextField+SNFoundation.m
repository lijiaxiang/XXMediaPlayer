//
//  UITextField+SNFoundation.m
//  JiYang
//
//  Created by DimuMac01 on 15/12/18.
//  Copyright © 2015年 优路文娱. All rights reserved.
//

#import "UITextField+SNFoundation.h"
#import <objc/runtime.h>

static char *placeholderColorKey = "placeholderColorKey";
//static char placeholderColorKey2; &placeholderColorKey2 如果没有* 则需要&

@implementation UITextField (SNFoundation)

- (void)setPlaceholderColor:(UIColor *) placeholderColor
{
//    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
  
    objc_setAssociatedObject(self, placeholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)getPlaceholderColor
{
        return objc_getAssociatedObject(self, placeholderColorKey);
}

@end
