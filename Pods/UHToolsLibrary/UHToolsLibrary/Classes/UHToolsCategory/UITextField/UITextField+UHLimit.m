//
//  UITextField+UHLimit.m
//  LGVideo
//
//  Created by 郭继超 on 2019/3/16.
//  Copyright © 2019 右划科技. All rights reserved.
//

#import "UITextField+UHLimit.h"
#import <objc/runtime.h>
static void *uhLimitMaxLengthKey = &uhLimitMaxLengthKey;
@implementation UITextField (UHLimit)


- (void)setUh_maxLength:(NSUInteger)uh_maxLength {
    objc_setAssociatedObject(self, uhLimitMaxLengthKey, @(uh_maxLength), OBJC_ASSOCIATION_COPY);
    
    if (uh_maxLength > 0) {
        [self addTarget:self action:@selector(_uh_valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    } else {
        [self removeTarget:self action:@selector(_uh_valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    }
}

- (NSUInteger)uh_maxLength {
    return [objc_getAssociatedObject(self, uhLimitMaxLengthKey) unsignedIntegerValue];
}

#pragma mark - private
- (void)_uh_valueChanged:(UITextField *)textField {
    if (self.uh_maxLength == 0) {
        return;
    }
    
    NSUInteger currentLength = [textField.text length];
    if (currentLength <= self.uh_maxLength) {
        return;
    }
    
    NSString *subString = [textField.text substringToIndex:self.uh_maxLength];
    dispatch_async(dispatch_get_main_queue(), ^{
        textField.text = subString;
        [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    });
}
@end
