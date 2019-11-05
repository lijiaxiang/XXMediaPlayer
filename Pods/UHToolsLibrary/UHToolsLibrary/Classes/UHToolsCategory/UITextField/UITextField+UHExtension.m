//
//  UITextField+UHExtension.m
//  Pods
//
//  Created by coderyi on 2019/6/26.
//

#import "UITextField+UHExtension.h"
#import <objc/runtime.h>

@implementation UITextField (UHExtension)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(didMoveToWindow);
        SEL swizzSel = @selector(uh_didMoveToWindow);
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}

- (void)uh_didMoveToWindow
{
    [self uh_didMoveToWindow];
    // iOS 11.2,UITextField系统内存泄漏修改
    // https://forums.developer.apple.com/thread/94323
    // 亲测iOS11.2.1复现，举例首次启动进入App，点击登录页后返回，如果其他页面有输入框则掉不起键盘
    if (@available(iOS 11.2, *)) {
        NSString *keyPath = @"textContentView.provider";
        @try {
            if (self.window) {
                id provider = [self valueForKeyPath:keyPath];
                if (!provider && self) {
                    [self setValue:self forKeyPath:keyPath];
                }
            } else {
                [self setValue:nil forKeyPath:keyPath];
            }
            
        } @catch (NSException *exception) {
            
        }
    }
}

@end
